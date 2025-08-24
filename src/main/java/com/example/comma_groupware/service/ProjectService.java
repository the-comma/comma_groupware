package com.example.comma_groupware.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.comma_groupware.dto.Page;
import com.example.comma_groupware.dto.Project;
import com.example.comma_groupware.dto.ProjectMember;
import com.example.comma_groupware.mapper.ProjectMapper;
import com.example.comma_groupware.mapper.ProjectMemberMapper;

@Service
public class ProjectService {

	ProjectMapper projectMapper;
	ProjectMemberMapper projectMemberMapper;
	
	public ProjectService(ProjectMapper projectMapper, ProjectMemberMapper projectMemberMapper){
		this.projectMapper = projectMapper;
		this.projectMemberMapper = projectMemberMapper;
	}
	
	/** 프로젝트 조회 **/
	public List<Map<String, Object>> selectProjectByEmpId(Page page){
		return projectMapper.selectProjectByEmpId(page);
	}
	
	/** 프로젝트 카운트 **/
	public int countProjectByEmpId(Map<String,Object> param){
		return projectMapper.countProjectByEmpId(param);
	}
	
	/** 프로젝트 추가 (prjectDto, memberList) **/
	@Transactional
	public int addProject(Project project, List<Map<String, Object>> memberList) {

		// 프로젝트 추가
		int row = projectMapper.addProject(project);
		
		if(row != 1) {
			throw new RuntimeException("프로젝트 추가 실패");
		}
		
		int projectId = project.getProjectId();
		
		// 멤버 추가까지
		for(Map<String, Object> m : memberList) {
			ProjectMember pm = new ProjectMember((int) m.get("empId"), projectId, (String) m.get("role"));			
			projectMemberMapper.addProjectMember(pm);
		}
		
		return 1;
	}
}
