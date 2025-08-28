package com.example.comma_groupware.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.comma_groupware.service.EquipmentUsageService;

@RestController
@RequestMapping("/api/equipment/usage")
@RequiredArgsConstructor
public class EquipmentUsageController {

    private final EquipmentUsageService usageService;

    /**
     * 비품 반납 처리
     * @param usageId 사용 이력 ID
     */
    @PostMapping("/{usageId}/return")
    public ResponseEntity<String> returnEquipment(@PathVariable int usageId) {
        usageService.returnEquipment(usageId);
        return ResponseEntity.ok("반납 완료");
    }

    /**
     * 비품 파손 보고
     * @param usageId 사용 이력 ID
     * @param empId   보고자 사원 ID
     * @param desc    파손 설명
     */
    @PostMapping("/{usageId}/damage")
    public ResponseEntity<String> reportDamage(
            @PathVariable int usageId,
            @RequestParam int empId,
            @RequestParam String desc) {

        usageService.reportDamage(usageId, empId, desc);
        return ResponseEntity.ok("파손 보고 완료");
    }

    /**
     * 프로젝트 종료 → 자동 반납 대기 처리
     * @param projectId 프로젝트 ID
     */
    @PostMapping("/project/{projectId}/auto-return")
    public ResponseEntity<String> autoReturn(@PathVariable int projectId) {
        usageService.autoReturnPending(projectId);
        return ResponseEntity.ok("해당 프로젝트 비품을 자동 반납대기로 변경했습니다.");
    }
}
