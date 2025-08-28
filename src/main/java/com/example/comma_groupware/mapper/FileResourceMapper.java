package com.example.comma_groupware.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.comma_groupware.dto.FileResource;

@Mapper
public interface FileResourceMapper {
	int addFile(FileResource fileResource);	// 파일 추가
	
	List<FileResource> selectTaskFileByTaskId(int taskId);	// 작업 아이디로 파일 리스트 조회
	FileResource selectFileByFileId(int fileId);			// 파일 아이디로 조회
}
