package com.example.comma_groupware.controller;

import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.comma_groupware.service.ApprovalService;

import lombok.RequiredArgsConstructor;
@Controller 
@RequiredArgsConstructor 
@RequestMapping("/approval") 
public class ApprovalController extends BaseApprovalController { 
	private final ApprovalService approvalService; 
	@Value("${upload.path:./uploads}") private String uploadPath; // 메인 + 리스트(별칭) : 기본은 "전체" 보이도록 status 파라미터 없으면 "" 처리 
	
	@GetMapping({"", "/", "/list"}) 
	public String approvalMain(@AuthenticationPrincipal Object principal, 
			@RequestParam(required = false) String status, Model model) { 
		int empId = getLoginEmpId(principal); if (status == null) status = ""; 
		// 기본: 전체 요청 
		model.addAttribute("status", status); 
		model.addAttribute("items", approvalService.getMyDocuments(empId, status)); 
		return "approval/approvalMain"; } // 결재하기(해야할결재) 
	
	@GetMapping("/todo") 
	public String todo(@AuthenticationPrincipal Object principal, Model model) { 
		int empId = getLoginEmpId(principal);
		model.addAttribute("todo", approvalService.getMyTodoLines(empId)); 
		model.addAttribute("done", approvalService.getMyDoneLines(empId)); 
		return "approval/todoIndex"; } 
	
	// 문서 상세 + 결재/반려 폼 
	@GetMapping("/doc/{docId}") 
	public String documentDetail(@AuthenticationPrincipal Object principal, @PathVariable int docId, Model model) {
		int empId = getLoginEmpId(principal); 
		Map<String,Object> doc = approvalService.getDocumentDetail(docId); 
		model.addAttribute("doc", doc); 
		model.addAttribute("canEdit", approvalService.canEditOrDelete(docId, empId)); 
		model.addAttribute("myLine", approvalService.getMyActionableLineForDoc(empId, docId)); 
		if (doc != null && doc.get("writerEmpId") != null) { 
			int writerEmpId = ((Number) doc.get("writerEmpId")).intValue(); 
			Map<String,Object> org = approvalService.getMyDeptTeam(writerEmpId); // deptName, teamName 
			model.addAttribute("org", org); } return "approval/detail"; } // 결재 승인 
	
	@PostMapping("/line/{lineId}/approve") 
	public String approve(@PathVariable int lineId, @AuthenticationPrincipal Object principal, RedirectAttributes ra) { 
		int empId = getLoginEmpId(principal); 
		try { 
			approvalService.approveLine(lineId, empId); ra.addFlashAttribute("msg", "승인되었습니다.");
			} catch (IllegalStateException ex) { 
				ra.addFlashAttribute("error", ex.getMessage()); } 
		return "redirect:/approval/todo"; } // 결재 반려 
	
	@PostMapping("/line/{lineId}/reject") 
	public String reject(@PathVariable int lineId, @RequestParam String reason, @AuthenticationPrincipal Object principal) { 
		int empId = getLoginEmpId(principal); 
		approvalService.rejectLine(lineId, empId, reason); 
		return "redirect:/approval/todo"; } // (선택) PDF 다운로드 (단순 스텁: HTML→PDF 라이브러리 붙이기 전) 
	
	@GetMapping("/doc/{docId}/download") public void downloadPdf(@PathVariable int docId, 
			jakarta.servlet.http.HttpServletResponse resp) throws Exception { // TODO 실제 PDF 생성 라이브러리(iText/OpenPDF/FlyingSaucer 등) 연결 
		resp.setContentType("application/pdf"); 
		resp.setHeader("Content-Disposition", "attachment; filename=approval-" + docId + ".pdf"); 
		try (OutputStream os = resp.getOutputStream()) { 
			os.write(("%PDF-1.4\n% Demo PDF for docId=" + docId + "\n").getBytes()); 
			} 
		}
	@PostMapping("/doc/{docId}/delete") 
	public String deleteDoc(@AuthenticationPrincipal Object principal, @PathVariable int docId, RedirectAttributes ra) { 
		int empId = getLoginEmpId(principal); 
		try { approvalService.deleteDocument(docId, empId); // 이제 체크예외 안 던짐 
		ra.addFlashAttribute("msg", "문서를 삭제했습니다."); return "redirect:/approval"; 
		} catch (RuntimeException ex) { // 권한/상태 등 비즈니스 예외 대응 
			ra.addFlashAttribute("error", ex.getMessage()); 
			return "redirect:/approval/doc/" + docId; } } 
	
	@GetMapping("/file/{fileId}/download") 
	public ResponseEntity<Resource> downloadFile(@PathVariable int fileId) throws Exception { 
		Map<String,Object> f = approvalService.getFileMeta(fileId); 
		if (f == null) return ResponseEntity.notFound().build(); 
		String saveName = (String) f.get("saveName"); 
		String origin = (String) f.get("originName"); 
		Path root = java.nio.file.Paths.get(uploadPath); 
		if (!root.isAbsolute()) { 
			root = java.nio.file.Paths.get(System.getProperty("user.dir")).resolve(root).normalize().toAbsolutePath();
			} Path path = root.resolve(saveName);
			if (!Files.exists(path)) return ResponseEntity.notFound().build(); 
			InputStreamResource body = new InputStreamResource(Files.newInputStream(path)); 
			String encoded = java.net.URLEncoder.encode(origin, java.nio.charset.StandardCharsets.UTF_8).replaceAll("\\+", "%20"); 
			return ResponseEntity.ok() .header("Content-Disposition", 
					"attachment; filename*=UTF-8''" + encoded) .contentLength(Files.size(path)) 
					.contentType(org.springframework.http.MediaType.APPLICATION_OCTET_STREAM) 
					.body(body); 
			} 
}