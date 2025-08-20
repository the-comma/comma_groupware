package com.example.comma_groupware.controller;

import java.io.File;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.comma_groupware.dto.FileResource;
import com.example.comma_groupware.dto.Notice;
import com.example.comma_groupware.security.CustomUserDetails;
import com.example.comma_groupware.service.NoticeService;

import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/notice")
public class NoticeController {
	private final NoticeService noticeService;	
	 @Value("${comma.upload.notice-root}")// application.properties에 경로 설정해놔서 주입받아 사용
	    private String noticeRoot; // 다운로드 시 경로 계산에 사용
	 
	 
	 // 목록 + 페이징 + 검색
	 @GetMapping("/list")
	 public String list(@RequestParam(required=false) String keyword,
	                    @RequestParam(defaultValue="1") int page,
	                    @RequestParam(defaultValue="10") int pageSize,
	                    Model model, 
	                    @AuthenticationPrincipal CustomUserDetails me) {
	     Map<String, Object> data = noticeService.getNoticeList(keyword, page, pageSize); // 목록/카운트 조회
	     int total = (int) data.get("total"); // 총 갯수
	     int totalPages = (int) Math.ceil((double) total / (double) pageSize); // 총 페이지수
	     data.put("totalPages", totalPages); 
	     model.addAttribute("data", data);
	     model.addAttribute("keyword", keyword); 
	     
	     // 경영부서면 글쓰기 노출
	     boolean canWrite = (me != null) && noticeService.isDeptManager(me.getEmployee().getEmpId());
	     model.addAttribute("canWrite", canWrite);
	     return "notice/noticeList";
	 }
	 
	 // 글쓰기 폼
	 @GetMapping("/add")
	 public String addForm(Model model, @AuthenticationPrincipal CustomUserDetails me) {
		 noticeService.assertDeptWritableOrThrow(me.getEmployee().getEmpId()); // 권한 사전체크(경영팀만 작성가능)
	     model.addAttribute("notice", new Notice()); // 빈 폼 객체 (noticeId=0) -> 새 글 쓰게 (안전한 바인딩을 위해 넣어둠)
	     model.addAttribute("mode", "add");          // JSP에서 작성/수정 분기
	     return "notice/noticeForm";
	 }

	    // 글쓰기 등록
	    @PostMapping("/add")
	    public String add(@ModelAttribute Notice notice,
	                      @RequestParam(required=false, name="files") List<MultipartFile> files,
	                      @AuthenticationPrincipal CustomUserDetails me) throws Exception {
	    	int empId = me.getEmployee().getEmpId(); 
	    	int id = noticeService.addNotice(notice, empId, files); // DB + 파일 저장(트랜잭션으로)
	        return "redirect:/notice/one?noticeId="+ id;
	    }

	    // 글 상세 + 조회수 증가
	    @GetMapping("/one")
	    public String detail(@RequestParam int noticeId, Model model,
                @AuthenticationPrincipal CustomUserDetails me) {
	        Notice n = noticeService.getNoticeAndIncreaseVC(noticeId);	// 조회수 증가 + 상세
	        List<FileResource> files = noticeService.getFiles(noticeId); // 첨부목록
	        model.addAttribute("notice", n);
	        model.addAttribute("files", files);	
	        Integer firstFileId = noticeService.getFirstFileId(noticeId); 
	        model.addAttribute("firstFileId", firstFileId);               
	        
	        // 작성자 or 경영 부서면 관리 가능
	        boolean canManage = (me != null) && noticeService.canManageNotice(noticeId, me.getEmployee().getEmpId());
	        model.addAttribute("canManage", canManage);
	        return "notice/noticeOne";
	    }

	    // 글 수정 + 조회수 안오르게
	    @GetMapping("/edit")	
	    public String editForm(@RequestParam int noticeId, Model model,
	                           @AuthenticationPrincipal CustomUserDetails me) {
	    	noticeService.assertWritableOrThrow(noticeId, me.getEmployee().getEmpId()); // 수정 권한
	        Notice n = noticeService.getNoticeOnly(noticeId);				  // 조회수 증가 안하게
	        model.addAttribute("notice", n);								  
	        model.addAttribute("files", noticeService.getFiles(noticeId));
	        model.addAttribute("mode", "edit");         					  // JSP에서 분기
	        return "notice/noticeForm";
	    }

	    // 글 수정
	    @PostMapping("/edit")
	    public String edit(@ModelAttribute Notice notice,
	                       @RequestParam(required=false, name="files") List<MultipartFile> addFiles,
	                       @AuthenticationPrincipal CustomUserDetails me) throws Exception {
	    	int empId = me.getEmployee().getEmpId(); 
	        noticeService.modifyNotice(notice, empId, addFiles);			// 트랜잭션으로 한번에
	        return "redirect:/notice/one?noticeId=" + notice.getNoticeId();
	    }

	    // 글 삭제
	    @PostMapping("/remove")
	    public String remove(@RequestParam int noticeId, @AuthenticationPrincipal CustomUserDetails me) throws Exception {
	    	int empId = me.getEmployee().getEmpId(); 
	        noticeService.removeNotice(noticeId, empId);				//트랜잭션으로 파일삭제 후 글 삭제
	        return "redirect:/notice/list";
	    }

	    // 파일 다운로드(개별)	
	    @GetMapping("/file/download/{fileId}")
	    public void download(@PathVariable int fileId, HttpServletResponse resp) throws Exception {
	        FileResource f = noticeService.getFile(fileId);

	        File real = new File(new File(noticeRoot, String.valueOf(f.getFileRefId())), f.getFileName());
	        resp.setContentType("application/octet-stream");
	        String encoded = URLEncoder.encode(f.getFileOriginName(), "UTF-8").replace("+", "%20");
	        resp.setHeader("Content-Disposition", "attachment; filename=\"" + encoded + "\"");
	        Files.copy(real.toPath(), resp.getOutputStream());
	        resp.getOutputStream().flush();
	    }
	    
	    // 파일 다운로드(한번에->압축)
	    @GetMapping("/file/download-all")
	    public void downloadAll(@RequestParam int noticeId, HttpServletResponse resp) throws Exception { 
	        List<FileResource> files = noticeService.getFiles(noticeId);
	        if (files == null || files.isEmpty()) {
	            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
	            return;
	        }
	        
	        String zipName = "notice-" + noticeId + ".zip";				// ZIP 파일명
	        resp.setContentType("application/zip"); 					// ZIP 컨텐츠 타입
	        String encoded = URLEncoder.encode(zipName, "UTF-8").replace("+", "%20");  // 파일명 인코딩
	        resp.setHeader("Content-Disposition", "attachment; filename=\"" + encoded + "\""); 
	        try (java.util.zip.ZipOutputStream zos = new java.util.zip.ZipOutputStream(resp.getOutputStream())) {
	            for (FileResource f : files) {
	                File real = new File(new File(noticeRoot, String.valueOf(f.getFileRefId())), f.getFileName());
	                if (!real.exists()) continue;
	                java.util.zip.ZipEntry e = new java.util.zip.ZipEntry(f.getFileOriginName());
	                zos.putNextEntry(e);
	                Files.copy(real.toPath(), zos);
	                zos.closeEntry();
	            }
	            zos.finish();
	        }
	    }

	    // 파일 개별 삭제 (수정 화면에서)
	    @PostMapping("/file/remove")
	    public String deleteFile(@RequestParam int fileId, @RequestParam int noticeId,
	    		@AuthenticationPrincipal CustomUserDetails me) throws Exception {
	    	int empId = me.getEmployee().getEmpId(); 
	        noticeService.removeFile(fileId, empId);
	        return "redirect:/notice/edit?noticeId=" + noticeId;
	    }
}