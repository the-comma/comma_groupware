package com.example.comma_groupware.controller;

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

    // 폼
    @GetMapping("/vacations/new")
    public String form(@AuthenticationPrincipal Object principal, Model model) {
        int empId = getLoginEmpId(principal);
        model.addAttribute("codes", approvalService.getVacationCodes());
        model.addAttribute("annualLeave", approvalService.getAnnualLeave(empId));
        
        Map<String,Object> org = approvalService.getMyDeptTeam(empId);  
        model.addAttribute("empId", empId);                           
        model.addAttribute("org", org);                                
        return "approval/vacationForm";
    }

    @PostMapping("/vacations/new")
    public String submit(@AuthenticationPrincipal Object principal,
                         @RequestParam String title,
                         @RequestParam int vacationId,
                         @RequestParam String startDate,
                         @RequestParam String endDate,
                         @RequestParam double totalDays,                    
                         @RequestParam(required=false) String emergencyContact, 
                         @RequestParam(required=false) String handover,       
                         @RequestParam String vacationReason, 
                         @RequestParam(required=false, name="files") List<MultipartFile> files
    ) throws Exception {
        int empId = getLoginEmpId(principal);
        
        int docId = approvalService.createVacationDocument(
            empId, title, vacationId, startDate, endDate, totalDays,
            emergencyContact, handover, vacationReason, 
            files
        );
        return "redirect:/approval/doc/" + docId;
    }
    
    @GetMapping("/vacations/{docId}/edit")                  // [ADDED]
    public String editForm(@AuthenticationPrincipal Object principal,
                           @PathVariable int docId, Model model){
        int empId = getLoginEmpId(principal);

        Map<String,Object> doc = approvalService.getDocumentDetail(docId);
        model.addAttribute("doc", doc);
        model.addAttribute("codes", approvalService.getVacationCodes());
        model.addAttribute("annualLeave", approvalService.getAnnualLeave(empId));

        Map<String,Object> org = approvalService.getMyDeptTeam(empId);   // [ADDED]
        model.addAttribute("empId", empId);                              // [ADDED]
        model.addAttribute("org", org);                                  // [ADDED]

        return "approval/vacationForm"; // 폼 재사용(액션만 edit URL로 바꿔서 제출)  // [ADDED]
    }

    @PostMapping("/vacations/{docId}/edit")                // [ADDED]
    public String update(@AuthenticationPrincipal Object principal,
                         @PathVariable int docId,
                         @RequestParam int vacationId,
                         @RequestParam String startDate,
                         @RequestParam String endDate,
                         @RequestParam double totalDays,
                         @RequestParam(required=false) String emergencyContact,
                         @RequestParam(required=false) String handover,
                         @RequestParam(required=false) String vacationReason,
                         @RequestParam(required=false, name="addFiles") List<MultipartFile> addFiles,
                         @RequestParam(required=false, name="deleteFileId") List<Integer> deleteFileIds
    ) throws Exception {
        int empId = getLoginEmpId(principal);

        approvalService.updateVacationDocument(
            docId, empId, vacationId, startDate, endDate, totalDays,
            emergencyContact, handover, vacationReason,
            addFiles, deleteFileIds
        );
        return "redirect:/approval/doc/" + docId;
    }
}
