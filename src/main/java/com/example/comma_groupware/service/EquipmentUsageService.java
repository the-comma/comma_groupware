package com.example.comma_groupware.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

import com.example.comma_groupware.mapper.EquipmentUsageMapper;
import com.example.comma_groupware.mapper.EquipmentMapper;
import com.example.comma_groupware.mapper.EquipmentDamageReportMapper;
import com.example.comma_groupware.dto.EquipmentUsage;
import com.example.comma_groupware.dto.EquipmentDamageReport;

@Service
@RequiredArgsConstructor
public class EquipmentUsageService {

    private final EquipmentUsageMapper usageMapper;
    private final EquipmentMapper equipmentMapper;
    private final EquipmentDamageReportMapper damageReportMapper;

    /**
     * 비품 반납 처리 (status 변경 + 재고 복구)
     */
    @Transactional
    public void returnEquipment(int usageId) {
        // 1) 상태 변경
        int updated = usageMapper.markAsReturned(usageId); // 
        if (updated == 0) {
            throw new RuntimeException("반납 처리 실패: 사용 이력 없음");
        }

        // 2) 재고 복구
        EquipmentUsage usage = usageMapper.selectById(usageId); // ✅ 단건 조회
        equipmentMapper.updateStockRelease(usage.getEquipmentId(), usage.getUsageQuantity());
    }

    /**
     * 비품 파손 보고
     */
    @Transactional
    public void reportDamage(int usageId, int empId, String desc) {
        // 1) 상태 변경
        usageMapper.markAsDamaged(usageId); // 

        // 2) damage_report 테이블 insert
        EquipmentDamageReport report = new EquipmentDamageReport();
        report.setUsageId(usageId);
        report.setReportedBy(empId);
        report.setDamageDesc(desc);

        damageReportMapper.insertDamageReport(report);
    }

    /**
     * 프로젝트 종료 → 자동 반납 대기 처리
     */
    @Transactional
    public void autoReturnPending(int projectId) {
        usageMapper.updateStatusToReturnPending(projectId); // 
    }
    
    @Transactional
    public List<EquipmentUsage> findByProject(int projectId) {
        return usageMapper.findByProject(projectId);
    }

    @Transactional
    public List<EquipmentUsage> findByEmp(int empId) {
        return usageMapper.findByEmp(empId);
    }

    // 멤버용 반납 요청 (상태만 바꾸는 용도)
    @Transactional
    public void requestReturn(int usageId) {
        usageMapper.updateStatusToReturnRequested(usageId);
    }
}
