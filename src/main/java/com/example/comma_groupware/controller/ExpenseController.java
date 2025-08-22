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
public class ExpenseController extends BaseApprovalController {

    private final ApprovalService approvalService;

    @GetMapping("/expenses/new")
    public String form(@AuthenticationPrincipal Object principal, Model model) {
        model.addAttribute("codes", approvalService.getExpenseCodes());
        return "approval/expenseForm";
    }

    @PostMapping("/expenses/new")
    public String submit(@AuthenticationPrincipal Object principal,
                         @RequestParam String title,
                         @RequestParam String reason,
                         @RequestParam int expenseId,
                         @RequestParam long amount,
                         @RequestParam String expenseDate,
                         @RequestParam(required=false, name="files") List<MultipartFile> files) throws Exception {
        int empId = getLoginEmpId(principal);
        int docId = approvalService.createExpenseDocument(empId, title, reason, expenseId, amount, expenseDate, files);
        return "redirect:/approval/doc/" + docId;
    }
}
