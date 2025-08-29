package com.example.comma_groupware.controller;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.comma_groupware.service.ApprovalService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/approval")
public class VacationController extends BaseApprovalController {

    private final ApprovalService approvalService;

    // 작성 폼 (GET)
    @GetMapping("/vacations/new")
    public String form(@AuthenticationPrincipal Object principal, Model model) {
        int empId = getLoginEmpId(principal);
        model.addAttribute("codes", approvalService.getVacationCodes());
        model.addAttribute("annualLeave", approvalService.getAnnualLeave(empId));
        model.addAttribute("empId", empId);
        model.addAttribute("org", approvalService.getMyDeptTeam(empId));
        model.addAttribute("editing", false);                 // [ADDED] 작성모드 플래그
        return "approval/vacationForm";
    }

    // 작성 제출 (POST)
    @PostMapping("/vacations/new")
    public String submit(
            @AuthenticationPrincipal Object principal,
            @RequestParam(required = false) String title,      // [CHANGED] 서버에서 무시해도 됨
            @RequestParam int vacationId,
            @RequestParam String startDate,
            @RequestParam String endDate,
            @RequestParam(required = false) Double totalDays,  // [CHANGED] 빈문자→변환오류 방지
            @RequestParam(required = false) String emergencyContact,
            @RequestParam(required = false) String handover,
            @RequestParam(required = false) String vacationReason,
            @RequestParam(required = false, name="files") List<MultipartFile> files,
            Model model                                       // [ADDED] 에러시 값 유지용
    ) throws Exception {

        // [ADDED] 과거 날짜 생성 방지 (요구사항 3)
        LocalDate s = LocalDate.parse(startDate);
        LocalDate e = LocalDate.parse(endDate);
        LocalDate today = LocalDate.now();
        if (s.isBefore(today) || e.isBefore(today)) {
            return backToNewFormWithError(principal, model, "과거 날짜는 신청할 수 없습니다.", 
                    vacationId, startDate, endDate, emergencyContact, handover, vacationReason);
        }

        // [ADDED] 서버에서 안전하게 일수 재계산 (빈값/조작 대비)
        if (totalDays == null) {
            totalDays = computeBusinessDays(startDate, endDate, vacationId == 6);
        }
        if (totalDays <= 0) {
            return backToNewFormWithError(principal, model, "사용일수가 0 이하입니다. 날짜/반차 선택을 확인하세요.",
                    vacationId, startDate, endDate, emergencyContact, handover, vacationReason);
        }

        try {
            int empId = getLoginEmpId(principal);
            int docId = approvalService.createVacationDocument(
                    empId, title,
                    vacationId, startDate, endDate, totalDays,
                    emergencyContact, handover, vacationReason,
                    files
            );
            return "redirect:/approval/doc/" + docId;
        } catch (Exception ex) {
            // [ADDED] 겹침/잔여연차부족 등 서비스 예외를 폼으로 돌려 메시지 노출
            return backToNewFormWithError(principal, model, ex.getMessage(),
                    vacationId, startDate, endDate, emergencyContact, handover, vacationReason);
        }
    }

    // 수정 폼 (GET)
    @GetMapping("/vacations/{docId}/edit")
    public String editForm(@AuthenticationPrincipal Object principal,
                           @PathVariable int docId, Model model){
        int empId = getLoginEmpId(principal);

        // (선택) 수정 가능 여부 체크하고 막고 싶으면 canEditOrDelete 사용
        // if (!approvalService.canEditOrDelete(docId, empId)) return "redirect:/approval/doc/" + docId;

        Map<String,Object> doc = approvalService.getDocumentDetail(docId);
        model.addAttribute("doc", doc);
        model.addAttribute("codes", approvalService.getVacationCodes());
        model.addAttribute("annualLeave", approvalService.getAnnualLeave(empId));
        model.addAttribute("empId", empId);
        model.addAttribute("org", approvalService.getMyDeptTeam(empId));
        model.addAttribute("editing", true);                  // [ADDED] 수정모드 플래그
        return "approval/vacationForm";
    }

    // 수정 제출 (POST)
    @PostMapping("/vacations/{docId}/edit")
    public String update(@AuthenticationPrincipal Object principal,
			            @PathVariable int docId,
			            @RequestParam int vacationId,
			            @RequestParam String startDate,
			            @RequestParam String endDate,
			            @RequestParam(required=false) Double totalDays,
			            @RequestParam(required=false) String emergencyContact,
			            @RequestParam(required=false) String handover,
			            @RequestParam(required=false) String vacationReason,
			            @RequestParam(required=false, name="addFiles") List<MultipartFile> addFiles,
			            @RequestParam(required=false, name="deleteFileIds") List<Integer> deleteFileIds,
			            Model model) throws Exception {
			int empId = getLoginEmpId(principal);
			// 클라이언트가 hidden으로 보내는 게 정상. 누락 시 서버에서 재계산(반차코드=6은 0.5/day 규칙)
			if (totalDays == null) {
			totalDays = computeBusinessDays(startDate, endDate, vacationId == 6);
			}
			try {
			approvalService.updateVacationDocument(
			   docId, empId, vacationId, startDate, endDate, totalDays,
			   emergencyContact, handover, vacationReason,
			   addFiles, deleteFileIds
			);
			return "redirect:/approval/doc/" + docId;
			} catch (Exception ex) {
			return backToEditFormWithError(principal, model, docId, ex.getMessage(),
			       vacationId, startDate, endDate, emergencyContact, handover, vacationReason);
			}	
		}

    // ====== 내부 유틸 ======

    private double computeBusinessDays(String s, String e, boolean isHalf) {
        LocalDate start = LocalDate.parse(s);
        LocalDate end   = LocalDate.parse(e);
        if (end.isBefore(start)) return 0d;

        if (isHalf) {
            // 반차(6)는 "같은 날"만 허용
            return start.equals(end) ? 0.5 : 0d;              // [CHANGED] 범위선택은 0 처리
        }

        double days = 0d;
        for (LocalDate d = start; !d.isAfter(end); d = d.plusDays(1)) {
            DayOfWeek w = d.getDayOfWeek();
            if (w != DayOfWeek.SATURDAY && w != DayOfWeek.SUNDAY) days += 1d;
        }
        return Math.max(0d, days);
    }

    // 새 작성 폼으로 값/오류 되돌리기
    private String backToNewFormWithError(Object principal, Model model, String msg,
                                          int vacationId, String startDate, String endDate,
                                          String emergencyContact, String handover, String vacationReason) {
        int empId = getLoginEmpId(principal);
        model.addAttribute("codes", approvalService.getVacationCodes());
        model.addAttribute("annualLeave", approvalService.getAnnualLeave(empId));
        model.addAttribute("empId", empId);
        model.addAttribute("org", approvalService.getMyDeptTeam(empId));
        model.addAttribute("editing", false);
        model.addAttribute("error", msg);                     // [ADDED]

        // 폼 값 유지용(신규 모드라 doc가 없으니 개별로 내려줌)
        model.addAttribute("pre_vacationId", vacationId);
        model.addAttribute("pre_startDate", startDate);
        model.addAttribute("pre_endDate", endDate);
        model.addAttribute("pre_emergencyContact", emergencyContact);
        model.addAttribute("pre_handover", handover);
        model.addAttribute("pre_vacationReason", vacationReason);

        return "approval/vacationForm";
    }

    // 수정 폼으로 값/오류 되돌리기
    private String backToEditFormWithError(Object principal, Model model, int docId, String msg,
                                           int vacationId, String startDate, String endDate,
                                           String emergencyContact, String handover, String vacationReason) {
        int empId = getLoginEmpId(principal);

        Map<String,Object> doc = approvalService.getDocumentDetail(docId);
        if (doc != null && doc.get("vacation") instanceof Map) {
            Map<String,Object> vac = (Map<String,Object>) doc.get("vacation");
            vac.put("vacationId", vacationId);
            vac.put("startDate", startDate);
            vac.put("endDate", endDate);
            vac.put("emergencyContact", emergencyContact);
            vac.put("handover", handover);
            vac.put("vacationReason", vacationReason);
            vac.put("totalDays", computeBusinessDays(startDate, endDate, vacationId == 6));
        }

        model.addAttribute("doc", doc);
        model.addAttribute("codes", approvalService.getVacationCodes());
        model.addAttribute("annualLeave", approvalService.getAnnualLeave(empId));
        model.addAttribute("empId", empId);
        model.addAttribute("org", approvalService.getMyDeptTeam(empId));
        model.addAttribute("editing", true);
        model.addAttribute("error", msg);                     // [ADDED]
        return "approval/vacationForm";
    }
}