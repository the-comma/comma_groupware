package com.example.comma_groupware.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.comma_groupware.dto.FileResource;

@Mapper
public interface FileResourceMapper {
	int addFile(FileResource fileResource);	// 파일 추가
}
