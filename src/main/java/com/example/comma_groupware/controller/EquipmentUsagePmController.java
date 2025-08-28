package com.example.comma_groupware.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.comma_groupware.service.EquipmentUsageService;
import com.example.comma_groupware.dto.EquipmentUsage;

import java.util.List;

@RestController
@RequestMapping("/api/equipment/pm")
@RequiredArgsConstructor
public class EquipmentUsagePmController {

    private final EquipmentUsageService usageService;

    // 특정 프로젝트 전체 사용 이력 조회
    @GetMapping("/usage/project/{projectId}")
    public ResponseEntity<List<EquipmentUsage>> getProjectUsage(@PathVariable int projectId) {
        List<EquipmentUsage> usageList = usageService.findByProject(projectId);
        return ResponseEntity.ok(usageList);
    }

    // 반납 처리
    @PostMapping("/usage/{usageId}/return")
    public ResponseEntity<String> returnEquipment(@PathVariable int usageId) {
        usageService.returnEquipment(usageId);
        return ResponseEntity.ok("반납 완료");
    }

    // 파손 보고
    @PostMapping("/usage/{usageId}/damage")
    public ResponseEntity<String> reportDamage(
            @PathVariable int usageId,
            @RequestParam int empId,
            @RequestParam String desc) {
        usageService.reportDamage(usageId, empId, desc);
        return ResponseEntity.ok("파손 보고 완료");
    }
}
