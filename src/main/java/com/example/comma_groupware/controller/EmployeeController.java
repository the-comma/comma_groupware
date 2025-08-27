package com.example.comma_groupware.controller;

import java.text.Format;
import java.time.Duration;
import java.time.Instant;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.service.EmployeeService;
import com.example.comma_groupware.service.JwtEmailOtpService;
import jakarta.mail.Session;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.comma_groupware.dto.Page;
import com.example.comma_groupware.service.DepartmentService;
import com.example.comma_groupware.service.EmployeeService;

@Slf4j
@Controller
public class EmployeeController {

    private final JwtEmailOtpService jwtEmailOtpService;
	private final EmployeeService employeeService;
	private final DepartmentService deptmentService;
	
	public EmployeeController(EmployeeService employeeService, JwtEmailOtpService jwtEmailOtpService, DepartmentService deptmentService) {
		this.employeeService = employeeService;
		this.jwtEmailOtpService = jwtEmailOtpService;
		this.deptmentService = deptmentService;
	}
	
	// 사원카드 페이지
	@GetMapping("employeeCard")
	public String employeeCard(Model model,
			@RequestParam Integer id) {
		
		// 해당 사원 한 명 조회
		Map<String,Object> emp = employeeService.employeeCard(id);
		model.addAttribute("emp",emp);
		
		return "employeeCard";
	}
	
	// 조직도 페이지
	@GetMapping("organizationChart")
	public String organizationChart(Model model,
									@RequestParam(required = false) Integer page,
									@RequestParam(defaultValue = "") String name,
									@RequestParam(defaultValue = "") String dept,
									@RequestParam(defaultValue = "") String team,
									@RequestParam(defaultValue = "") String order,
									@RequestParam(defaultValue = "") String sort) {
		
		// 현재 페이지값 없을때 defaultValue
		if(page == null) page = 0;
		
		// 받아온 부서/팀 리스트
		List<Map<String,Object>> deptTeamList = deptmentService.getDeptTeamList();

		// 분류 리스트
		Map<String,List<String>> deptTeam = new HashMap<>();
		
		// key는 부서이고 value 리스트에 해당 부서 소속의 팀들 분류 작업
		for(Map<String,Object> dt : deptTeamList) {
			String key = (String) dt.get("deptName");
			String val = (String) dt.get("teamName");
			if(deptTeam.containsKey(key)) {
				deptTeam.get(key).add(val);
			}
			else {
				List<String> list = new ArrayList<>();
				list.add(val);
				deptTeam.put(key, list);
			}
		}
		
		// 전체 데이터 수 구할때 필터링할 param 값들
		Map<String,Object> param = new HashMap<>();
		param.put("name", name);
		param.put("team", team);
		param.put("dept", dept);
		param.put("order", order);
		param.put("sort", sort);
		
		
		// 전체 데이터 수 가져옴
		int totalCount = employeeService.organizationListCount(param);
		
		// 페이징 옵션
		Page p = new Page(10,page,totalCount,param);
		
		// 해당 페이지에 사원 리스트
		List<Map<String,Object>> organiList = employeeService.organizationList(p);
		
		// model 값 전달
		model.addAttribute("organiList",organiList);
		model.addAttribute("totalCount",totalCount);
		model.addAttribute("deptTeam",deptTeam);
		model.addAttribute("name", name);
		model.addAttribute("topbarTitle", "조직도");
		model.addAttribute("page", p);
		return "organizationChart";
	}

	@GetMapping("/login") // 로그인 페이지 이동
	public String login() {
		return "login";
	}
	
	@GetMapping("/mainPage") // 메인페이지로 이동
	public String mainPage() {
		return "mainPage";
	}
	
	@GetMapping("/resetPw") // 비밀번호 재설정 페이지로 이동
	public String createPw() {
		return "resetPw";
	}
	
	@GetMapping("/login-pin")
	public String loginPin(HttpSession session, Model model , RedirectAttributes ra) {
		
	String token = (String) session.getAttribute("otpToken");
	Instant deadline = (Instant) session.getAttribute("otpDeadLine");
	
	if(token == null  || deadline == null) {
		ra.addFlashAttribute("error", "인증 세션이 없습니다. 처음부터 다시 시도하세요.");
		return "redirect:/findPw";
	}
		long remain = Math.max(0, Duration.between(Instant.now(), deadline).toSeconds());
		model.addAttribute("remainSeconds", remain);
		return "login-pin";
	}
 
	@GetMapping("/updateInfo") // 이메일 페이지로 이동
	public String updateInfo(HttpSession session, Model model) {
		String username = (String) session.getAttribute("username");
		Employee employee = employeeService.selectEmpInfo(username);
		
		log.info("email:" + employee.getEmpEmail());
		
		model.addAttribute("email",employee.getEmpEmail());
		model.addAttribute("phone", employee.getEmpPhone());
		
		
		
		return "updateInfo";
	}
	
	
	
	
	
	@PostMapping("/updateInfo") // 휴대폰, 이메일 재설정
	public String updateInfo(HttpSession session, @RequestParam String email, @RequestParam String phone ) {
		String username = (String) session.getAttribute("username");
		employeeService.updateInfo(username, email, phone);
		
		return "redirect:/mainPage";
	}
	
	
	
	
	@PostMapping("/resetPw") // 비밀번호 재설정
	public String resetPw(@RequestParam("new-password") String password, HttpSession session) {
		String username = (String) session.getAttribute("username");
		employeeService.updatePw(password, username);
		
		session.invalidate();
		return "redirect:/login";
	}
	
	@PostMapping("/findPw") // 비밀번호 인증 보내기
	public String  findPw(@RequestParam("username") String username, @RequestParam("emp_email") String email
						,RedirectAttributes ra , HttpSession session) {
		Map<String,Object> res = employeeService.sendEmail(username,email);
		String token = (String) res.get("token");
		long ttl = (long) res.get("ttlSeconds");
		
		
		session.setAttribute("otpToken", token);
		session.setAttribute("otpDeadLine", Instant.now().plusSeconds(ttl));
		
	    // (재전송용) 사용자 식별도 세션에 보관
		/*
		 * session.setAttribute("otpUsername", username);
		 * session.setAttribute("otpEmail", email);
		 */
		
		ra.addFlashAttribute("msg" , "이메일로 인증번호를 보냈습니다.");
		return "redirect:/login-pin";
		
	}
	
	@PostMapping("/login-pin")
	public String verifyPin(@RequestParam("code") String code,
							HttpSession session,
							RedirectAttributes ra) {
		String token = (String) session.getAttribute("otpToken");
		if(token == null) {
			ra.addFlashAttribute("error", "인증 세션이 없습니다.");
			return "redirect:/findPw";
		}
		
		boolean ok = jwtEmailOtpService.verify(token, code);
		if(ok) {
			session.removeAttribute("otpToken");
			session.removeAttribute("otpDeadline");
			
			log.info("인증성공!");
			ra.addFlashAttribute("msg", "이메일 인증이 완료되었습니다.");
			return "redirect:/resetPw";
			
			
		}
		else {
			ra.addFlashAttribute("error", "코드가 틀렸거나 만료/이미 사용되었습니다.");
			log.info("인증실패!");
			
			return "redirect:/login-pin";
		}
		
	}
}