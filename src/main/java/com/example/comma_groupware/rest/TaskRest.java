package com.example.comma_groupware.rest;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.example.comma_groupware.service.ProjectService;

@RestController
public class TaskRest {
	ProjectService projectService;
	
	public TaskRest(ProjectService projectService){
		this.projectService = projectService;
	}
	
	/** 작업 아이디로 작업 상세 조회 **/
	@GetMapping("getTask/{id}")
    public List<Map<String, Object>> getTask(@PathVariable int id, @PathVariable(required = false) String searchName) {
    	
		if(searchName == null) searchName = ""; // 빈 문자열로 처리
		
    	Map<String, Object> param = new HashMap<>();
    	param.put("projectId", id);
    	param.put("searchName", searchName);
    	
    	List<Map<String, Object>> memberList = projectService.selectProjectMebmerListByProjectId(param);

    	return memberList;
    }
	
	/** 작업 아이디로 작업 멤버 리스트 조회 **/
	@GetMapping("selectTaskMemberByTaskId/{id}")
	public List<Map<String,Object>> selectTaskMemberByTaskId(@PathVariable int id){		
		return projectService.selectTaskMemberByTaskId(id);
	}
}
