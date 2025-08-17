package com.example.comma_groupware.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.comma_groupware.mapper.DepartmentMapper;

@Service
public class DepartmentService {

	DepartmentMapper departmentMapper;
	
	public DepartmentService(DepartmentMapper departmentMapper) {
		this.departmentMapper = departmentMapper;
	}
	
	public List<Map<String,Object>> getDeptTeamList(){
		return departmentMapper.getDeptTeamList();
	}
}
