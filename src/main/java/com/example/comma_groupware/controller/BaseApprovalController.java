package com.example.comma_groupware.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;

public abstract class BaseApprovalController {
    protected int getLoginEmpId(@AuthenticationPrincipal Object principal) {
        // TODO: 프로젝트의 UserDetails 구현에 맞춰 수정
        // 예) ((CustomUser)principal).getEmpId();
        if (principal instanceof com.example.comma_groupware.security.CustomUserDetails u) {
        	 return u.getEmployee().getEmpId();
        }
        // 데모/테스트용 fallback
        return 1;
    }
}