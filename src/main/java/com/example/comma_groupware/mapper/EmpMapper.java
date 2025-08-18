package com.example.comma_groupware.mapper;


import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.comma_groupware.dto.Employee;

@Mapper
public interface EmpMapper {
    int selectEmployeeCount(String searchWord);
    List<Employee> selectEmployeeList(Map<String, Object> param);
}
