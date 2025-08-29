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
public class ExpenseController extends BaseApprovalController {

    private final ApprovalService approvalService;

    @GetMapping("/expenses/new")
    public String newForm(@AuthenticationPrincipal Object principal, Model model){
        int empId = getLoginEmpId(principal);
        model.addAttribute("codes", approvalService.getExpenseCodes());
        model.addAttribute("empId", empId);
        model.addAttribute("org", approvalService.getMyDeptTeam(empId));
        model.addAttribute("editing", false);                // ← 중요
        return "approval/expenseForm";
    }

    @PostMapping("/expenses/new")
    public String submit(@AuthenticationPrincipal Object principal,
                         @RequestParam String title,          // [KEEP] 제목(날짜 제외)
                         @RequestParam int expenseId,         // 지출 카테고리
                         @RequestParam long amount,           // 총액
                         @RequestParam String expenseDate,    // 대표 지출일(테이블 첫 행 등)
                         @RequestParam String vendor,         // 거래처
                         @RequestParam String payMethod,      // CORP_CARD / PERSONAL_CARD / TRANSFER / CASH
                         @RequestParam(required=false) String bankInfo, // 계좌(선택)
                         @RequestParam String expenseReason, 
                         @RequestParam(required=false, name="files") List<MultipartFile> files
    ) throws Exception {
        int empId = getLoginEmpId(principal);
        
        int docId = approvalService.createExpenseDocument(
            empId, title, expenseId, amount, expenseDate, vendor, payMethod, bankInfo, expenseReason, files
        );
        return "redirect:/approval/doc/" + docId;
    }
    
    @GetMapping("/expenses/{docId}/edit")
    public String expenseEditForm(@AuthenticationPrincipal Object principal,
                                  @PathVariable int docId, Model model){
        int empId = getLoginEmpId(principal);

        Map<String,Object> doc = approvalService.getDocumentDetail(docId); // files, expense 포함
        model.addAttribute("doc", doc);
        model.addAttribute("codes", approvalService.getExpenseCodes());
        model.addAttribute("empId", empId);
        model.addAttribute("org", approvalService.getMyDeptTeam(empId));
        model.addAttribute("editing", true);
        return "approval/expenseForm"; // 위 JSP 파일명
    }

    @PostMapping("/expenses/{docId}/edit")
    public String expenseUpdate(@AuthenticationPrincipal Object principal,
                                @PathVariable int docId,
                                @RequestParam int expenseId,
                                @RequestParam long amount,
                                @RequestParam String expenseDate,
                                @RequestParam(required=false) String vendor,
                                @RequestParam(required=false) String payMethod,
                                @RequestParam(required=false) String bankInfo,
                                @RequestParam(required=false) String expenseReason,
                                @RequestParam(required=false, name="addFiles") List<MultipartFile> addFiles,
                                @RequestParam(required=false, name="deleteFileIds") List<Integer> deleteFileIds) throws Exception {
        int empId = getLoginEmpId(principal);
        approvalService.updateExpenseDocument(
            docId, empId, expenseId, amount, expenseDate,
            vendor, payMethod, bankInfo, expenseReason,
            addFiles, deleteFileIds
        );
        return "redirect:/approval/doc/" + docId;
    }
}
