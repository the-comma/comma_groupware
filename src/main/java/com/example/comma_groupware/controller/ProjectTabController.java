package com.example.comma_groupware.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.comma_groupware.dto.Project;
import com.example.comma_groupware.service.ProjectService;

@Controller
@RequestMapping("/project")
public class ProjectTabController {

	ProjectService projectService;
	
	public ProjectTabController(ProjectService projectService) {
		this.projectService = projectService;
	}
	
	/** 업무탭 **/
    @GetMapping("/{id}/task")
    public String getTasks(@PathVariable int id, Model model) {
    	
    	Map<String, Object> param = new HashMap<>();
    	param.put("projectId", id);
    	
    	List<Map<String,Object>> taskList = projectService.selectTaskListByProjectId(param);
    	
        model.addAttribute("projectId",id);
        model.addAttribute("taskList",taskList);
        return "project/fragments/taskList"; // JSP 조각
    }
    
	/** 메인탭 **/
    @GetMapping("/{id}/main")
    public String getMain(@PathVariable int id, Model model) {
    	
    	Map<String, Object> project = projectService.selectProjectByProjectId(id);
    	model.addAttribute("project",project);
    	
        return "project/fragments/taskMain"; // JSP 조각
    }
}

