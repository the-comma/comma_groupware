package com.example.comma_groupware.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.comma_groupware.dto.FileResource;
import com.example.comma_groupware.dto.Page;
import com.example.comma_groupware.dto.Project;
import com.example.comma_groupware.dto.ProjectTask;
import com.example.comma_groupware.dto.TaskMember;
import com.example.comma_groupware.service.DepartmentService;
import com.example.comma_groupware.service.ProjectService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ProjectController {

	ProjectService projectService;
	DepartmentService deptService;
	
	public ProjectController(ProjectService projectService, DepartmentService deptService) {
		this.projectService = projectService;
		this.deptService = deptService;
	}
	
	// 업무 수정 폼
	@GetMapping("/modifyTask")
	public String modifyTask(@RequestParam int id, Model model) {
	    ProjectTask task = projectService.selectTaskByTaskId(id);
	    List<Map<String, Object>> taskMember = projectService.selectTaskMemberByTaskId(id);
	    List<FileResource> fileList = projectService.selectTaskFileByTaskId(id);
	    
	    model.addAttribute("task", task);
	    model.addAttribute("taskMember", taskMember);
	    model.addAttribute("fileList", fileList);
	    
	    return "modifyTask"; // modifyTask.jsp
	}
	
	// 업무 수정
	@PostMapping("/modifyTask")
	public String modifyTask(ProjectTask projectTask, HttpSession session
			, @RequestParam(required = false) List<Integer> selectedEmp
			, @RequestParam("file") List<MultipartFile> file) {

		//	int pmId = session.getAttribute(null)
		int pmId = 1;
		projectService.modifyTask(pmId, projectTask, selectedEmp, file);
		return "redirect:/projectDetail?id=" + projectTask.getProjectId();
	}
	
	// 업무 추가 폼
	@GetMapping("/addTask")
	public String addTask() {
		return "addTask";
	}
	
	// 업무 추가
	@PostMapping("/addTask")
	public String addTask(ProjectTask projectTask, HttpSession session
			, @RequestParam(required = false) List<Integer> selectedEmp
			, @RequestParam(required = false) int parentId
			, @RequestParam("file") List<MultipartFile> file) {

		//	int pmId = session.getAttribute(null)
		int pmId = 1;
		projectTask.setTaskParent(parentId);
		projectService.addTask(pmId, projectTask, selectedEmp, file);
		return "redirect:/projectDetail?id=" + projectTask.getProjectId();
	}
	
	@GetMapping("projectDetail")
	public String projectDetail(Model model, HttpSession session
										,@RequestParam int id) {
		model.addAttribute("projectId", id);
		return "projectDetail";
	}
	
	// 프로젝트 메인 페이지
	@GetMapping("projectMain")
	public String projectMain(Model model,HttpSession session
										,@RequestParam(required = false) Integer page
										,@RequestParam(defaultValue = "") String projectName
										,@RequestParam(defaultValue = "") String view) {
		
		// 현재 페이지값 없을때 defaultValue
		if(page == null) page = 0;
		
		// 필터링할 param 값들
		Map<String,Object> param = new HashMap<>();
		param.put("projectName", projectName);
		// param.put("empId", (Employee)session.getAttribute("loginUser").getEmpId());		
		param.put("empId",1);
		
		// 전체 데이터 수 가져옴
		int totalCount = projectService.countProjectByEmpId(param);
		
		// 페이징 옵션
		Page p = new Page(10,page,totalCount,param);
		
		// 프로젝트 리스트 가져오기
		List<Map<String,Object>> projectList = projectService.selectProjectByEmpId(p);
		
		model.addAttribute("projectList",projectList);
		model.addAttribute("page",p);
		model.addAttribute("view",view);
		return "projectMain";
	}
	
	
	@GetMapping("addProject")
	public String addProjectForm(Model model) {
		// 1. 모달창에 쓸 부서/팀 리스트
		List<Map<String,Object>> deptTeamList = deptService.getDeptTeamList();
		model.addAttribute("deptTeamList",deptTeamList);
		model.addAttribute("topbarTitle", "프로젝트 생성");
		
		return "addProject";
	}
	
	@PostMapping("addProject")
	public String addProjectForm(Project project, HttpSession session
								, @RequestParam List<Integer> feList
								, @RequestParam List<Integer> beList
								, @RequestParam List<Integer> plList) {

		// 1. 프로젝트 폼
		// project.setPmId(((Employee)session.getAttribute("loginUser")).getEmpId());
		project.setPmId(1);	// 임시
		project.setProjectStatus("PROGRESS");
		
		List<Map<String,Object>> memberList = new ArrayList<Map<String,Object>>();
		
		inputMember(memberList, feList, "FE");
		inputMember(memberList, beList, "BE");
		inputMember(memberList, plList, "PL");
		
		// service에 프로젝트랑, 멤버 넘기기
		projectService.addProject(project, memberList);
		
		return "redirect:/projectMain";
	}

	// FE, BE, PL 리스트 멤버 리스트에 넣는 메서드
	private void inputMember(List<Map<String,Object>> memberList, List<Integer> inputList , String role) {
		for(Integer empId : inputList) {
			Map<String, Object> emp = new HashMap<>();
			
			emp.put("role", role);
			emp.put("empId", empId);
			
			memberList.add(emp);
		}
	}
}
