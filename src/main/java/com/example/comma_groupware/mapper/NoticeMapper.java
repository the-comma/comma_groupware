package com.example.comma_groupware.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.comma_groupware.dto.FileResource;
import com.example.comma_groupware.dto.Notice;

@Mapper
public interface NoticeMapper {
    // ===== Notice =====
    List<Notice> selectNoticeList(Map<String, Object> param);
    int selectNoticeCount(Map<String, Object> param);

    Notice selectNoticeOne(int noticeId);
    int increaseViewCount(int noticeId);

    int insertNotice(Notice notice);    // useGeneratedKeys로 PK 세팅
    int updateNotice(Notice notice);
    int deleteNotice(int noticeId);

    // ===== File (통합) =====
    int insertFile(FileResource f);
    List<FileResource> selectFilesByRef(@Param("refType") String refType, @Param("refId") long refId);
    FileResource selectFileOne(int fileId);
    int deleteFile(int fileId);
    int deleteFilesByRef(@Param("refType") String refType, @Param("refId") long refId);

    // ===== 권한: 현재 경영지원팀 여부 (1=가능) =====
    int isSupportDeptNow(int empId);
}
