package com.example.comma_groupware.rest;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.example.comma_groupware.service.ProjectService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
public class ProjectMemberRest {

	ProjectService projectService;
	
	public ProjectMemberRest(ProjectService projectService) {
		this.projectService = projectService;
	}
	
	/** 프로젝트 아이디로 멤버 조회 **/
	@GetMapping({"memberListByProjectId/{id}/{searchName}", "memberListByProjectId/{id}"})
    public List<Map<String, Object>> memberListByProjectId(@PathVariable int id, @PathVariable(required = false) String searchName) {
    	
		if(searchName == null) searchName = ""; // 빈 문자열로 처리
		
    	Map<String, Object> param = new HashMap<>();
    	param.put("projectId", id);
    	param.put("searchName", searchName);
    	
    	List<Map<String, Object>> memberList = projectService.selectProjectMebmerListByProjectId(param);

    	return memberList;
    }
}
