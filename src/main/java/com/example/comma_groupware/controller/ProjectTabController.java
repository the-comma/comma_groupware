package com.example.comma_groupware.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

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
        model.addAttribute("projectId",id);
        return "project/fragments/taskList"; // JSP 조각
    }
}

