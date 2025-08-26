package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class FileResource {

	private int fileId;
	private long fileSize;
	private String fileOriginName;
	private String fileName;
	private String fileRefType;
	private long fileRefId;
	private String fileExt;
	private int fileUploader;
	private LocalDateTime uploadAt;
	
}
