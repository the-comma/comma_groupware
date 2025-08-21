package com.example.comma_groupware.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.comma_groupware.dto.Page;
import com.example.comma_groupware.mapper.EmployeeMapper;

@Service
public class EmployeeService {

	EmployeeMapper employeeMapper;
	
	/** 생성자 **/
	public EmployeeService(EmployeeMapper employeeMapper) {
		this.employeeMapper = employeeMapper;
	}
	
	/** 조직도 리스트 **/
	public List<Map<String,Object>> organizationList(Page p){
		return employeeMapper.organizationList(p);
	}
	
	/** 조직도 리스트 전체 데이터 수 **/
	public int organizationListCount(Map<String,Object> param){
		return employeeMapper.organizationListCount(param);
	}
	
	/** 사원 카드 조회 **/
	public Map<String, Object> employeeCard(int id){
		return employeeMapper.employeeCard(id);
	}
	
	/** 해당 팀 소속 사원 조회 **/
	public List<Map<String,Object>> empListByTeam(String team){
		return employeeMapper.empListByTeam(team);
	}
}
