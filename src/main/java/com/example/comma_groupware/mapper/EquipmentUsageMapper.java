package com.example.comma_groupware.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.example.comma_groupware.dto.EquipmentUsage;

@Mapper
public interface EquipmentUsageMapper {

    // 사용 이력 등록
    int insertUsage(EquipmentUsage usage);

    // 프로젝트 종료 시 상태 자동 변경 (스케줄러에서 호출)
    int updateStatusToReturnPending(@Param("projectId") int projectId);

    // 파손 처리
    int markAsDamaged(@Param("usageId") int usageId);

    // 반납 완료 처리
    int markAsReturned(@Param("usageId") int usageId);

    // 특정 프로젝트 이력 조회
    List<EquipmentUsage> findByProject(@Param("projectId") int projectId);

    // 특정 사용자 이력 조회
    List<EquipmentUsage> findByEmp(@Param("empId") int empId);

    // 단건 조회
    EquipmentUsage selectById(@Param("usageId") int usageId);
    
    // 멤버 반납 요청
    int updateStatusToReturnRequested(@Param("usageId") int usageId);
}
