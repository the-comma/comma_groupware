package com.example.comma_groupware.controller;

import java.io.OutputStream;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.comma_groupware.service.ApprovalService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/approval")
public class ApprovalController extends BaseApprovalController {

    private final ApprovalService approvalService;

    // ✅ 메인 + 리스트(별칭) : 기본은 "전체" 보이도록 status 파라미터 없으면 "" 처리
    @GetMapping({"", "/", "/list"})
    public String approvalMain(@AuthenticationPrincipal Object principal,
                               @RequestParam(required = false) String status,
                               Model model) {
        int empId = getLoginEmpId(principal);
        if (status == null) status = ""; // 기본: 전체 요청
        model.addAttribute("status", status);
        model.addAttribute("items", approvalService.getMyDocuments(empId, status));
        return "approval/approvalMain";
    }
    
    // 결재하기(해야할결재)
    @GetMapping("/todo")
    public String todo(@AuthenticationPrincipal Object principal, Model model) {
        int empId = getLoginEmpId(principal);
        model.addAttribute("todo", approvalService.getMyTodoLines(empId));
        model.addAttribute("done", approvalService.getMyDoneLines(empId));
        return "approval/todoIndex";
    }

    // 문서 상세 + 결재/반려 폼
    @GetMapping("/doc/{docId}")
    public String documentDetail(@PathVariable int docId, Model model) {
        model.addAttribute("doc", approvalService.getDocumentDetail(docId));
        return "approval/detail";
    }

    // 결재 승인
    @PostMapping("/line/{lineId}/approve")
    public String approve(@PathVariable int lineId, @AuthenticationPrincipal Object principal) {
        int empId = getLoginEmpId(principal);
        approvalService.approveLine(lineId, empId);
        return "redirect:/approval/todo";
    }

    // 결재 반려
    @PostMapping("/line/{lineId}/reject")
    public String reject(@PathVariable int lineId,
                         @RequestParam String reason,
                         @AuthenticationPrincipal Object principal) {
        int empId = getLoginEmpId(principal);
        approvalService.rejectLine(lineId, empId, reason);
        return "redirect:/approval/todo";
    }

    // (선택) PDF 다운로드 (단순 스텁: HTML→PDF 라이브러리 붙이기 전)
    @GetMapping("/doc/{docId}/download")
    public void downloadPdf(@PathVariable int docId, jakarta.servlet.http.HttpServletResponse resp) throws Exception {
        // TODO 실제 PDF 생성 라이브러리(iText/OpenPDF/FlyingSaucer 등) 연결
        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "attachment; filename=approval-" + docId + ".pdf");
        try (OutputStream os = resp.getOutputStream()) {
            os.write(("%PDF-1.4\n% Demo PDF for docId=" + docId + "\n").getBytes());
        }
    }
}
