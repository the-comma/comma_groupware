package com.example.comma_groupware.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.comma_groupware.service.EquipmentService;
import com.example.comma_groupware.dto.EquipmentRequest;

@RestController
@RequestMapping("/api/equipment")
@RequiredArgsConstructor
public class EquipmentController {

    private final EquipmentService equipmentService;

    /**
     * 비품 신청 (PM만 가능)
     */
    @PostMapping("/request")
    public ResponseEntity<String> requestEquipment(@RequestBody EquipmentRequest request) {
        try {
            equipmentService.requestEquipment(request);
            return ResponseEntity.ok("비품 신청이 완료되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("비품 신청 실패: " + e.getMessage());
        }
    }
}
