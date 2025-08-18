package com.example.comma_groupware.service;


import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
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

@Service
@RequiredArgsConstructor
public class NoticeService {

    private final NoticeMapper noticeMapper;

    @Value("${comma.upload.notice-root}")
    private String noticeRoot;       // 예: C:/comma_upload/notice

    private static final String REF_TYPE_NOTICE = "NOTICE";
    private static final String NOTICE_DEPT_NAME = "경영"; 
    //경영지원팀만 가능하게
    //@Value("${comma.auth.notice-writable-dept:경영}")
    //private String writableDeptName;
    
    /** 현재 로그인 사용자가 경영지원팀인지 검사(작성/수정/삭제 권한) */
    private void assertWritable(int empId) {
        //if (noticeMapper.isSupportDeptNow(empId, writableDeptName) != 1) {
    	if (empId > 0 && noticeMapper.isSupportDeptNow(empId, NOTICE_DEPT_NAME) == 1) return;
    	throw new RuntimeException("권한이 없습니다. (" + NOTICE_DEPT_NAME +" 전용)");
    }

    /** 목록 + 페이징 */
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

    /** 상세조회 + 조회수 증가 */
    @Transactional
    public Notice getNoticeAndIncreaseVC(int noticeId) {
        noticeMapper.increaseViewCount(noticeId);
        return noticeMapper.selectNoticeOne(noticeId);
    }

    /** 공지 등록 (파일 업로드 포함) */
    @Transactional(rollbackFor = Exception.class)
    public int addNotice(Notice notice, int loginEmpId, List<MultipartFile> files) throws IOException {
    	System.out.println("[addNotice] after insert, noticeId=" + notice.getNoticeId());
        assertWritable(loginEmpId);
        notice.setWriterId(loginEmpId);

        boolean hasFiles = files != null && files.stream().anyMatch(f -> !f.isEmpty());
        notice.setIsFile(hasFiles ? 1 : 0);

        noticeMapper.insertNotice(notice); // PK 채워짐

        if (hasFiles) saveFiles(notice.getNoticeId(), loginEmpId, files);
        return notice.getNoticeId();
    }

    /** 공지 수정 (파일 추가 가능, 기존 파일 유지 / 개별 삭제 API 별도) */
    @Transactional(rollbackFor = Exception.class)
    public void modifyNotice(Notice notice, int loginEmpId, List<MultipartFile> addFiles) throws IOException {
        assertWritable(loginEmpId);

        // 1) 추가 파일 저장
        if (addFiles != null && addFiles.stream().anyMatch(f -> !f.isEmpty())) {
            saveFiles(notice.getNoticeId(), loginEmpId, addFiles);
        }
        // 2) 남은 파일 여부로 is_file 갱신
        boolean stillHas = !noticeMapper
                .selectFilesByRef(REF_TYPE_NOTICE, notice.getNoticeId()).isEmpty();
        notice.setIsFile(stillHas ? 1 : 0);

        // 3) 본문/핀값 업데이트
        noticeMapper.updateNotice(notice);
    }

    /** 공지 삭제 (첨부 레코드 + 물리파일 함께 제거) */
    @Transactional(rollbackFor = Exception.class)
    public void removeNotice(int noticeId, int loginEmpId) throws IOException {
        assertWritable(loginEmpId);

        // 물리 파일 선삭제
        List<FileResource> files = noticeMapper.selectFilesByRef(REF_TYPE_NOTICE, noticeId);
        for (FileResource f : files) {
            File real = buildPath((int) f.getFileRefId(), f.getFileName());
            if (real.exists()) Files.delete(real.toPath());
        }
        // 파일 레코드 삭제 → 공지 삭제
        noticeMapper.deleteFilesByRef(REF_TYPE_NOTICE, noticeId);
        noticeMapper.deleteNotice(noticeId);
    }

    /** 파일 단건 삭제 (수정 화면에서) */
    @Transactional(rollbackFor = Exception.class)
    public void removeFile(int fileId, int loginEmpId) throws IOException {
        assertWritable(loginEmpId);

        FileResource f = noticeMapper.selectFileOne(fileId);
        if (f == null) return;

        // 물리 파일 삭제
        File real = buildPath((int) f.getFileRefId(), f.getFileName());
        if (real.exists()) Files.delete(real.toPath());

        // 레코드 삭제
        noticeMapper.deleteFile(fileId);

        // 남은 파일 없으면 notice.is_file=0으로 갱신
        boolean left = !noticeMapper.selectFilesByRef(REF_TYPE_NOTICE, f.getFileRefId()).isEmpty();
        Notice n = noticeMapper.selectNoticeOne((int) f.getFileRefId());
        n.setIsFile(left ? 1 : 0);
        noticeMapper.updateNotice(n);
    }

    /** 파일 목록/단건 조회 (뷰 렌더링용) */
    public List<FileResource> getFiles(int noticeId) {
        return noticeMapper.selectFilesByRef(REF_TYPE_NOTICE, noticeId);
    }
    public FileResource getFile(int fileId) {
        return noticeMapper.selectFileOne(fileId);
    }

    // === 내부 유틸 ===

    /** 파일 실저장 + 파일테이블 INSERT */
    private void saveFiles(int noticeId, int uploader, List<MultipartFile> files) throws IOException {
        File dir = new File(noticeRoot, String.valueOf(noticeId)); // /{noticeId}
        if (!dir.exists()) dir.mkdirs();

        for (MultipartFile mf : files) {
            if (mf.isEmpty()) continue;

            String origin = mf.getOriginalFilename();
            String ext = (origin != null && origin.contains(".")) ? origin.substring(origin.lastIndexOf('.') + 1) : "";
            String saved = UUID.randomUUID().toString().replace("-", ""); // 충돌 최소화를 위한 UUID

            File target = new File(dir, saved);
            mf.transferTo(target);

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
    
    /** 물리 경로 조합 유틸 */
    private File buildPath(int noticeId, String savedName) {
        return new File(new File(noticeRoot, String.valueOf(noticeId)), savedName);
    }
}