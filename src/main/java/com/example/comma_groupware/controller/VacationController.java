package com.example.comma_groupware.controller;

import java.util.List;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
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
        return "approval/vacationForm";
    }

    // 제출
    @PostMapping("/vacations/new")
    public String submit(@AuthenticationPrincipal Object principal,
                         @RequestParam String title,
                         @RequestParam String reason,
                         @RequestParam int vacationId,
                         @RequestParam String startDate,
                         @RequestParam String endDate,
                         @RequestParam int totalDays,
                         @RequestParam(required=false, name="files") List<MultipartFile> files) throws Exception {
        int empId = getLoginEmpId(principal);
        int docId = approvalService.createVacationDocument(empId, title, reason, vacationId, startDate, endDate, totalDays, files);
        return "redirect:/approval/doc/" + docId;
    }

}
