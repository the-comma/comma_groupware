package com.example.comma_groupware.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.comma_groupware.dto.Employee;

@Mapper
public interface EmployeeMapper {

	// SpringSecurity 로그인에 사용
	Employee selectByUserName(@Param("username") String username);

	// 비밀번호 업데이트
	void updatePw(@Param("password") String password, @Param("username") String username);



}
