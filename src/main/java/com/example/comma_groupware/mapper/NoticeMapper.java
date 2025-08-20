package com.example.comma_groupware.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.comma_groupware.dto.FileResource;
import com.example.comma_groupware.dto.Notice;

//NoticeMapper.java

@Mapper
public interface NoticeMapper {
 // ===== Notice =====
 List<Notice> selectNoticeList(Map<String, Object> param);
 int selectNoticeCount(Map<String, Object> param);

 Notice selectNoticeOne(int noticeId);
 int increaseViewCount(int noticeId);

 int insertNotice(Notice notice);
 int updateNotice(Notice notice);
 int deleteNotice(int noticeId);

 // ✨ changed: is_file/file_count만 갱신하는 경량 업데이트
 int updateNoticeFileFlags(Notice notice);                     // ✨ changed

 // ===== File (통합) =====
 int insertFile(FileResource f);
 List<FileResource> selectFilesByRef(@Param("refType") String refType, @Param("refId") long refId);
 FileResource selectFileOne(int fileId);
 int deleteFile(int fileId);
 int deleteFilesByRef(@Param("refType") String refType, @Param("refId") long refId);

 // ✨ changed: 파일 개수 / 첫 파일 id
 int countFilesByRef(@Param("refType") String refType, @Param("refId") long refId); // ✨ changed
 Integer selectFirstFileIdByNotice(@Param("refId") int noticeId);                   // ✨ changed

 // empId로 dept_name조회
 String selectDeptNameByEmpId(int empId);
 // 권한
 int isSupportDeptNow(@Param("empId") int empId, @Param("deptName") String deptName);
}

