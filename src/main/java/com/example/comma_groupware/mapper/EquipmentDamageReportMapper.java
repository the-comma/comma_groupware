package com.example.comma_groupware.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.example.comma_groupware.dto.EquipmentDamageReport;

@Mapper
public interface EquipmentDamageReportMapper {

    // 파손 보고 등록
    int insertDamageReport(EquipmentDamageReport report);

    // 특정 이력의 파손 보고 조회
    List<EquipmentDamageReport> findByUsage(@Param("usageId") int usageId);

    // 특정 사용자 파손 내역
    List<EquipmentDamageReport> findByEmp(@Param("empId") int empId);
}
