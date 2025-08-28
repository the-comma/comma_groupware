package com.example.comma_groupware.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.comma_groupware.service.EquipmentUsageService;
import com.example.comma_groupware.dto.EquipmentUsage;

import java.util.List;

@RestController
@RequestMapping("/api/equipment/member")
@RequiredArgsConstructor
public class EquipmentUsageMemberController {

    private final EquipmentUsageService usageService;

    // 내가 배정 받은 비품 조회
    @GetMapping("/usage/emp/{empId}")
    public ResponseEntity<List<EquipmentUsage>> getMyUsage(@PathVariable int empId) {
        List<EquipmentUsage> myUsage = usageService.findByEmp(empId);
        return ResponseEntity.ok(myUsage);
    }

    // 반납 요청 (선택)
    @PostMapping("/usage/{usageId}/request-return")
    public ResponseEntity<String> requestReturn(@PathVariable int usageId) {
        // 👉 실제 반납은 PM 승인 or 자동 처리, 여기선 상태를 RETURN_REQUESTED로만 업데이트
        usageService.requestReturn(usageId);
        return ResponseEntity.ok("반납 요청 완료");
    }
}
