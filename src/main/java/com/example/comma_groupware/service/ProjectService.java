package com.example.comma_groupware.service;

import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.comma_groupware.dto.FileResource;
import com.example.comma_groupware.dto.Page;
import com.example.comma_groupware.dto.Project;
import com.example.comma_groupware.dto.ProjectMember;
import com.example.comma_groupware.dto.ProjectTask;
import com.example.comma_groupware.dto.TaskMember;
import com.example.comma_groupware.mapper.FileResourceMapper;
import com.example.comma_groupware.mapper.ProjectMapper;
import com.example.comma_groupware.mapper.ProjectMemberMapper;
import com.example.comma_groupware.mapper.ProjectTaskMapper;
import com.example.comma_groupware.mapper.TaskMemberMapper;

@Service
public class ProjectService {

	ProjectMapper projectMapper;
	ProjectMemberMapper projectMemberMapper;
	ProjectTaskMapper projectTaskMapper;
	TaskMemberMapper taskMemberMapper;
	FileResourceMapper fileResourceMapper;
	
	public ProjectService(ProjectMapper projectMapper, ProjectMemberMapper projectMemberMapper, ProjectTaskMapper projectTaskMapper, TaskMemberMapper taskMemberMapper
			,FileResourceMapper fileResourceMapper){
		this.projectMapper = projectMapper;
		this.projectMemberMapper = projectMemberMapper;
		this.projectTaskMapper = projectTaskMapper;
		this.taskMemberMapper = taskMemberMapper;
		this.fileResourceMapper = fileResourceMapper;
	}
	
	/** 업무 조회 **/
	public List<Map<String,Object>> selectTaskListByProjectId(Map<String, Object> param){
		return projectTaskMapper.selectTaskListByProjectId(param);
	}	
	
	/** 업무 상세 조회 **/
	public ProjectTask selectTaskByTaskId(int taskId){
		return projectTaskMapper.selectTaskByTaskId(taskId);
	}
	
	/** 업무 참여자 조회 **/
	public List<Map<String, Object>> selectTaskMemberByTaskId(int taskId) {
		return taskMemberMapper.selectTaskMemberByTaskId(taskId);
	}
	
	/** 업무 추가 **/
	@Transactional
	public int addTask(int pmId, ProjectTask projectTask, List<Integer> empList, List<MultipartFile> fileList) {
		
		// 1. 업무 추가
		projectTask.setFileCount(fileList.size());
		int row = projectTaskMapper.addProjectTask(projectTask);
		if(row != 1) {
			throw new RuntimeException("작업 추가 실패");
		}
		
		// 추가한 작업 pk
		int taskId = projectTask.getTaskId();
		
		// 2. 해당 업무에 담당자 추가
		
		if(empList != null) {			
			for(Integer empId : empList) {
				TaskMember taskMember = new TaskMember(taskId, empId);
				taskMemberMapper.addTaskMember(taskMember);
			}
		}
		
		// 3. 멀티 파일 있으면 추가
		for(MultipartFile file : fileList) {
			// DB 파일 정보 저장
			FileResource fileResource = new FileResource();
			
			fileResource.setFileRefType("TASK");
			fileResource.setFileRefId(taskId);			
			fileResource.setFileSize(file.getSize());
			fileResource.setFileOriginName(file.getOriginalFilename());
			fileResource.setFileUploader(10);
			
			String filename = UUID.randomUUID().toString().replace("-", "");
			String ext = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".")+1); // UUID 문자열 + .확장자
			fileResource.setFileName(filename);
			fileResource.setFileExt(ext);
			
			fileResourceMapper.addFile(fileResource);
			
			// 실제 파일 저장			
			File emptyFile = new File("c:/project/upload/"+filename+ext);
			// file 안에 파일스트림을 emptyFile로 이동
			try {
				file.transferTo(emptyFile);
			} catch (Exception e) {
				throw new RuntimeException();
			}
		}
				
		return 0;
	}
	
	/** 업무 수정 **/
	
	/** 업무 삭제 **/
	
	/** 프로젝트 참여자 조회 **/
	public List<Map<String, Object>> selectProjectMebmerListByProjectId(Map<String, Object> param){
		return projectMemberMapper.selectProjectMebmerListByProjectId(param);
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
