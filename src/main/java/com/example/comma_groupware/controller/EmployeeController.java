package com.example.comma_groupware.controller;

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

import com.example.comma_groupware.service.EmployeeService;
import com.example.comma_groupware.service.JwtEmailOtpService;
import jakarta.mail.Session;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class EmployeeController {

    private final JwtEmailOtpService jwtEmailOtpService;
	private final EmployeeService employeeService;
	
	public EmployeeController(EmployeeService employeeService, JwtEmailOtpService jwtEmailOtpService) {
		this.employeeService = employeeService;
		this.jwtEmailOtpService = jwtEmailOtpService;
	}
	
	@GetMapping("/login") // 로그인 페이지 이동
	public String login() {
		return "login";
	}
	
	@GetMapping("/findPw") // 비밀번호 찾기 페이지 이동
	public String findPw() {
		return "findPw";
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
