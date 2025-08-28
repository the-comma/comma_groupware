package com.example.comma_groupware.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.example.comma_groupware.dto.EquipmentRequest;

@Mapper
public interface EquipmentRequestMapper {

    // 비품 신청 등록
    int insertRequest(EquipmentRequest request);

    // 신청과 동시에 사용 이력 생성
    int insertUsageFromRequest(EquipmentRequest request);

    // 재고 차감
    int decreaseStock(@Param("equipmentId") int equipmentId, @Param("quantity") int quantity);

    // 특정 프로젝트 신청 내역 조회
    List<EquipmentRequest> findByProject(@Param("projectId") int projectId);

    // 특정 사용자 신청 내역 조회
    List<EquipmentRequest> findByEmp(@Param("empId") int empId);
}
