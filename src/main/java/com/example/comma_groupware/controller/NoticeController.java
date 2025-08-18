package com.example.comma_groupware.controller;

import java.io.File;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
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
import com.example.comma_groupware.service.NoticeService;

import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/notice")
public class NoticeController {
	private final NoticeService noticeService;	
	 @Value("${comma.upload.notice-root}")
	    private String noticeRoot; // 다운로드 시 경로 계산에 사용

	    /** TODO: 실제 로그인 세션/시큐리티 연동 */
	    private int getLoginEmpId() { return 1001; }

	    /** TODO: 실제 로그인 세션/시큐리티 연동 */
	    private int getLoginEmpId() { return 1001; }

	    /** 목록 */
	    @GetMapping("/list")
	    public String list(@RequestParam(required=false) String keyword,
	                       @RequestParam(defaultValue="1") int page,
	                       @RequestParam(defaultValue="10") int pageSize,
	                       Model model) {
	        Map<String, Object> data = noticeService.getNoticeList(keyword, page, pageSize);
	        model.addAttribute("data", data);
	        model.addAttribute("keyword", keyword);
	        return "notice/noticeList";
	    }

	    /** 작성 폼 */
	    @GetMapping("/add")
	    public String addForm(Model model) {
	        model.addAttribute("notice", new Notice());
	        return "notice/noticeForm";
	    }

	    /** 등록 */
	    @PostMapping("/add")
	    public String add(@ModelAttribute Notice notice,
	                      @RequestParam(required=false, name="files") List<MultipartFile> files) throws Exception {
	        int id = noticeService.addNotice(notice, getLoginEmpId(), files);
	        return "redirect:/notice/detail?noticeId="+ id;
	    }

	    /** 상세 (조회수 증가) */
	    @GetMapping("/one")
	    public String detail(@RequestParam int noticeId, Model model) {
	        Notice n = noticeService.getNoticeAndIncreaseVC(noticeId);
	        List<FileResource> files = noticeService.getFiles(noticeId);
	        model.addAttribute("notice", n);
	        model.addAttribute("files", files);
	        return "notice/noticeOne";
	    }

	    /** 수정 폼 */
	    @GetMapping("/edit")
	    public String editForm(@RequestParam int noticeId, Model model) {
	        // 조회수 증가 원치 않으면 selectNoticeOne을 서비스에 따로 만들어 사용
	        Notice n = noticeService.getNoticeAndIncreaseVC(noticeId);
	        model.addAttribute("notice", n);
	        model.addAttribute("files", noticeService.getFiles(noticeId));
	        return "notice/noticeForm";
	    }

	    /** 수정 */
	    @PostMapping("/edit")
	    public String edit(@ModelAttribute Notice notice,
	                       @RequestParam(required=false, name="files") List<MultipartFile> addFiles) throws Exception {
	        noticeService.modifyNotice(notice, getLoginEmpId(), addFiles);
	        return "redirect:/notice/one?noticeId=" + notice.getNoticeId();
	    }

	    /** 삭제 */
	    @PostMapping("/remove")
	    public String remove(@RequestParam int noticeId) throws Exception {
	        noticeService.removeNotice(noticeId, getLoginEmpId());
	        return "redirect:/notice/list";
	    }

	    /** 파일 다운로드 */
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

	    /** 파일 개별 삭제 (수정 화면에서) */
	    @PostMapping("/file/remove")
	    public String deleteFile(@RequestParam int fileId, @RequestParam int noticeId) throws Exception {
	        noticeService.removeFile(fileId, getLoginEmpId());
	        return "redirect:/notice/edit?noticeId=" + noticeId;
	    }
}