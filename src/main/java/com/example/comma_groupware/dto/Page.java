package com.example.comma_groupware.dto;

import lombok.Data;

@Data
public class Page {
    private int rowPerPage;    // 페이지 당 행 수
    private int currentPage;   // 현재 페이지
    private int beginRow;      // 시작 행
    private int totalCount;    // 전체 데이터 수
    private String searchWord; // 검색어
    
    private int lastPage;      // 마지막 페이지 번호
    private int pageCount = 5; // 한 화면에 보여줄 그룹 번호 개수
    private int startPage;     // 그룹 시작 번호
    private int endPage;       // 그룹 끝 번호

    public Page(int rowPerPage, int currentPage, int totalCount, String searchWord) {
        this.rowPerPage = rowPerPage;
        this.currentPage = currentPage;
        this.totalCount = totalCount;
        this.searchWord = searchWord;

        // 시작 행 계산
        this.beginRow = (currentPage - 1) * rowPerPage;

        // 마지막 페이지 번호 계산
        this.lastPage = (int) Math.ceil((double) totalCount / rowPerPage);

        // 현재 그룹 시작/끝 번호 계산
        this.startPage = ((currentPage - 1) / pageCount) * pageCount + 1;
        this.endPage = Math.min(startPage + pageCount - 1, lastPage);
    }
}
