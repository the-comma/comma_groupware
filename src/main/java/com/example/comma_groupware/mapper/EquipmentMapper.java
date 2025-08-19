package com.example.comma_groupware.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.example.comma_groupware.dto.Equipment;

/**
 * EquipmentMapper
 * 비품(재고) 관련 Mapper
 */
public interface EquipmentMapper {

    /**
     * 비품 단건 조회
     * @param equipmentId 장비 PK
     * @return Equipment DTO
     */
    Equipment selectById(@Param("equipmentId") int equipmentId);

    /**
     * 재고 차감
     * @param equipmentId 장비 PK
     * @param qty 차감할 수량
     * @return 업데이트된 행 수 (0이면 실패, 재고 부족)
     */
    int updateStockAllocate(@Param("equipmentId") int equipmentId, @Param("qty") int qty);

    /**
     * 재고 복구 (반납 시)
     * @param equipmentId 장비 PK
     * @param qty 복구할 수량
     */
    int updateStockRelease(@Param("equipmentId") int equipmentId, @Param("qty") int qty);

    /**
     * 신규 비품 등록
     */
    int insert(Equipment e);

    /**
     * 비품 정보 수정
     */
    int update(Equipment e);

    /**
     * 전체 비품 목록 조회
     */
    List<Equipment> findAll();
}
