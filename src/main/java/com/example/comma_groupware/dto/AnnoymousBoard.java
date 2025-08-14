package com.example.comma_groupware.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class AnnoymousBoard {      //게시판 정보 (ex.고민상담게시판, 유머게시판)
  private Long boardId;            //게시판ID
  private String boardName;        //게시판이름
  private String boardDesc;        //게시판설명
  private LocalDateTime createdAt; //생성 일시
}
