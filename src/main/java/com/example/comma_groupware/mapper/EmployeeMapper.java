package com.example.comma_groupware.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.comma_groupware.dto.Employee;

@Mapper
public interface EmployeeMapper {

	Employee selectByUserName(@Param("username") String username);
	
	

}
