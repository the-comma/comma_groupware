package com.example.comma_groupware.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

import com.example.comma_groupware.mapper.EquipmentMapper;
import com.example.comma_groupware.mapper.EquipmentRequestMapper;
import com.example.comma_groupware.mapper.EquipmentUsageMapper;
import com.example.comma_groupware.dto.EquipmentRequest;

@Service
@RequiredArgsConstructor
public class EquipmentService {

    private final EquipmentMapper equipmentMapper;
    private final EquipmentRequestMapper requestMapper;
    private final EquipmentUsageMapper usageMapper;

    /**
     * PM이 비품 신청 → 사용이력 생성 → 재고 차감
     */
    @Transactional
    public void requestEquipment(EquipmentRequest request) {
        // 1) 신청 기록 저장
        requestMapper.insertRequest(request);

        // 2) 사용 이력 생성
        requestMapper.insertUsageFromRequest(request);

        // 3) 재고 차감
        int updated = equipmentMapper.updateStockAllocate(request.getEquipmentId(), request.getQuantity());
        if (updated == 0) {
            throw new RuntimeException("재고 부족으로 신청 실패");
        }
    }
}
