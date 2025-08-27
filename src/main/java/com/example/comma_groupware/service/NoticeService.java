package com.example.comma_groupware.service;


import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.comma_groupware.dto.FileResource;
import com.example.comma_groupware.dto.Notice;
import com.example.comma_groupware.mapper.NoticeMapper;

import lombok.RequiredArgsConstructor;

/**
 * 비즈니스 로직:
 * - 경영지원팀 권한 검사
 * - 파일 저장/삭제 + 통합 파일 테이블 연동
 * - is_file(0/1) 유지
 * - 조회수 증가
 */

//NoticeService.java

@Service
@RequiredArgsConstructor
public class NoticeService {
	 private final NoticeMapper noticeMapper;	
	
	 @Value("${comma.upload.notice-root}")
	 private String noticeRoot;

	 private static final String REF_TYPE_NOTICE = "NOTICE";
	 private static final String NOTICE_DEPT_NAME = "경영";		// 권한 있는 부서명
	 
	 // 경영부서 소속여부
	 public boolean isDeptManager(int empId) {
		 String deptName = noticeMapper.selectDeptNameByEmpId(empId);
		 return NOTICE_DEPT_NAME.equals(deptName);
	 }
	 
	 // 공지 관리권한(수정 삭제기능)
	 public boolean canManageNotice(int noticeId, int empId) {
		 Notice n = noticeMapper.selectNoticeOne(noticeId);
		 if(n==null) return false;
		 if(n.getWriterId() == empId) return true;
		 return isDeptManager(empId);
	 }
	 
	 // 권한 case 1. 글쓴이 본인 + 사원이 경영
	 public void assertWritableOrThrow(int noticeId, int loginEmpId) {
		    // 1) 공지 작성자 확인
		    Notice dbNotice = noticeMapper.selectNoticeOne(noticeId);

		    if (dbNotice.getWriterId() == loginEmpId) {
		        return; // 작성자 본인 → 허용
		    }

		    // 2) 로그인한 사원의 부서 조회
		    String deptName = noticeMapper.selectDeptNameByEmpId(loginEmpId);

		    if ("경영".equals(deptName)) {
		        return; // 경영팀 → 허용
		    }

		    throw new AccessDeniedException("수정/삭제 권한이 없습니다.");
		}
	 
	 // 권한 case 2. 사원이 경영
	 public void assertDeptWritableOrThrow(int loginEmpId) {	
		    String deptName = noticeMapper.selectDeptNameByEmpId(loginEmpId);
		    if (!NOTICE_DEPT_NAME.equals(deptName)) {
		        throw new org.springframework.security.access.AccessDeniedException("공지 작성 권한이 없습니다.");
		    }
		}
	 
	 // 목록 + 페이징 + 검색 (파일 여부/파일개수 함께 노출)
	 public Map<String, Object> getNoticeList(String keyword, int page, int pageSize) {
	     int offset = (page - 1) * pageSize;
	     Map<String, Object> p = new HashMap<>();
	     p.put("keyword", keyword);
	     p.put("limit", pageSize);
	     p.put("offset", offset);
	
	     Map<String, Object> r = new HashMap<>();
	     r.put("list", noticeMapper.selectNoticeList(p));
	     r.put("total", noticeMapper.selectNoticeCount(p));
	     r.put("page", page);
	     r.put("pageSize", pageSize);
	     return r;
	 }	

	 // 상세조회 + 조회수 증가(트랜잭션으로 조회+증가)
	 @Transactional
	 public Notice getNoticeAndIncreaseVC(int noticeId) {
	     noticeMapper.increaseViewCount(noticeId);				// 조회수 +1 증가
	     return noticeMapper.selectNoticeOne(noticeId);			
	 }
	
	 // 상세조회(조회수 증가 없음->수정폼 전용)
	 public Notice getNoticeOnly(int noticeId) {    
		    return noticeMapper.selectNoticeOne(noticeId);
		}

	 // 공지 등록 (파일 업로드 포함)
	 @Transactional(rollbackFor = Exception.class)
	 public int addNotice(Notice notice, int loginEmpId, List<MultipartFile> files) throws IOException {
			 String deptName = noticeMapper.selectDeptNameByEmpId(loginEmpId);
			 if (!"경영".equals(deptName)) {
			     throw new AccessDeniedException("공지 작성 권한이 없습니다.");
			 }		// 권한 확인
		    notice.setWriterId(loginEmpId);			
	
		    boolean hasFiles = files != null && files.stream().anyMatch(f -> !f.isEmpty());
		    notice.setIsFile(hasFiles ? 1 : 0);
	
		    noticeMapper.insertNotice(notice); // 공지 INSERT → PK 채워짐(useGeneratedKeys)
	
		    if (hasFiles) saveFiles(notice.getNoticeId(), loginEmpId, files);  
	
		    int cnt = noticeMapper.countFilesByRef(REF_TYPE_NOTICE, notice.getNoticeId()); // 최종 파일 갯수
		    notice.setIsFile(cnt > 0 ? 1 : 0);                                              // is_file 세팅 1이면 있는거
		    notice.setFileCount(cnt);                                                       // file_count 저장
		    noticeMapper.updateNoticeFileFlags(notice);                                    
		    return notice.getNoticeId();
		}

	 // 공지 수정 (본문/핀/파일 추가) 
	 @Transactional(rollbackFor = Exception.class)
	 public void modifyNotice(Notice notice, int loginEmpId, List<MultipartFile> addFiles) throws IOException {
		 	assertWritableOrThrow(notice.getNoticeId(), loginEmpId);											// 수정 권한
	
		    if (addFiles != null && addFiles.stream().anyMatch(f -> !f.isEmpty())) {
		        saveFiles(notice.getNoticeId(), loginEmpId, addFiles);					// 새 첨부만 추가
		    }
		    int cnt = noticeMapper.countFilesByRef(REF_TYPE_NOTICE, notice.getNoticeId()); // 남은 파일 수 
		    notice.setIsFile(cnt > 0 ? 1 : 0);                                          
		    notice.setFileCount(cnt);                                                     
	
		    noticeMapper.updateNotice(notice); // 본문/핀 + is_file/file_count까지 업데이트
		}

	 // 공지 삭제 (첨부 레코드 + 물리파일 함께 제거)
	 @Transactional(rollbackFor = Exception.class)
	 public void removeNotice(int noticeId, int loginEmpId) throws IOException {
		 assertWritableOrThrow(noticeId, loginEmpId);						// 삭제 권한
	
	     // 1.물리 파일 선삭제(실패하면 예외로 전체 롤백)
	     List<FileResource> files = noticeMapper.selectFilesByRef(REF_TYPE_NOTICE, noticeId);
	     for (FileResource f : files) {
	         File real = buildPath((int) f.getFileRefId(), f.getFileName());
	         if (real.exists()) Files.delete(real.toPath());
	     }
	     // 2.파일 삭제
	     noticeMapper.deleteFilesByRef(REF_TYPE_NOTICE, noticeId);
	     // 3.공지 본문 삭제
	     noticeMapper.deleteNotice(noticeId);
	 }
	 
	 
	 // 파일 개별 삭제
	 @Transactional(rollbackFor = Exception.class)
	 public void removeFile(int fileId, int loginEmpId) throws IOException {
	
		    FileResource f = noticeMapper.selectFileOne(fileId);					// 삭제 대상
		    if (f == null) return;													// 삭제 할 거 없을때
		    assertWritableOrThrow((int) f.getFileRefId(), loginEmpId);
		    
		    File real = buildPath((int) f.getFileRefId(), f.getFileName());
		    if (real.exists()) Files.delete(real.toPath());
	
		    noticeMapper.deleteFile(fileId);
	
		    int cnt = noticeMapper.countFilesByRef(REF_TYPE_NOTICE, f.getFileRefId()); 
		    Notice n = noticeMapper.selectNoticeOne((int) f.getFileRefId());
		    n.setIsFile(cnt > 0 ? 1 : 0);                                            
		    n.setFileCount(cnt);                                                     
		    noticeMapper.updateNoticeFileFlags(n);                                  
		}


	 // 파일 단건 조회
	 public List<FileResource> getFiles(int noticeId) {
	     return noticeMapper.selectFilesByRef(REF_TYPE_NOTICE, noticeId);
	 }
	 public FileResource getFile(int fileId) {
	     return noticeMapper.selectFileOne(fileId);
	 }

	 /** 리스트용: 첫 파일 id */
	 public Integer getFirstFileId(int noticeId) {            // ✨ changed
	     return noticeMapper.selectFirstFileIdByNotice(noticeId);
	 }

 // === 내부 유틸 ===
	 // 파일 실저장 + 파일테이블 insert
	 private void saveFiles(int noticeId, int uploader, List<MultipartFile> files) throws IOException {
		    File dir = new File(noticeRoot, String.valueOf(noticeId));
		    if (!dir.exists() && !dir.mkdirs()) { // 경로 생성 실패 시 예외처리
		        throw new IOException("업로드 경로 생성 실패: " + dir.getAbsolutePath());
		    }
	
	     for (MultipartFile mf : files) {
	         if (mf.isEmpty()) continue;		//공백 건너뜀
	
	         String origin = mf.getOriginalFilename();		// 원본파일명
	         String ext = (origin != null && origin.contains(".")) ? origin.substring(origin.lastIndexOf('.') + 1) : ""; // 확장자 추출(없으면 "")
	         String saved = UUID.randomUUID().toString().replace("-", ""); // UUID방식으로 저장
	
	         File target = new File(dir, saved); // 실제 저장 파일
	         mf.transferTo(target); // 디스크에 저장
	
	         FileResource meta = new FileResource();
	         meta.setFileSize(mf.getSize());
	         meta.setFileOriginName(origin);
	         meta.setFileName(saved);
	         meta.setFileRefType(REF_TYPE_NOTICE);
	         meta.setFileRefId(noticeId);
	         meta.setFileExt(ext);
	         meta.setFileUploader(uploader);
	         noticeMapper.insertFile(meta);
	     }
	 }
 	
	 // 파일이 실제로 저장될 경로
	 private File buildPath(int noticeId, String savedName) {
	     return new File(new File(noticeRoot, String.valueOf(noticeId)), savedName);
	 }
}
