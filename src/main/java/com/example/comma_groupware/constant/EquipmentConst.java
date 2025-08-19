package com.example.comma_groupware.constant;
//상수 모음집(Utility 클래스)
public final class EquipmentConst {
    private EquipmentConst() {}
 
    // 사용 이력 상태
    public static final String USAGE_IN_USE = "IN_USE";               // 사용중
    public static final String USAGE_RETURN_PENDING = "RETURN_PENDING"; // 반납 대기(자정 자동전환)
    public static final String USAGE_RETURNED = "RETURNED";           // 반납 완료
    public static final String USAGE_DAMAGED = "DAMAGED";             // 파손

    // 신청 상태(승인 절차 없으면 'ISSUED'로 바로 처리)
    public static final String REQ_REQUESTED = "REQUESTED";
    public static final String REQ_ISSUED = "ISSUED";
}