package com.example.comma_groupware.dto;

import java.util.Map;

import lombok.Data;

@Data
public class Page {
	public int getRowPerPage() {
		return rowPerPage;
	}

	public void setRowPerPage(int rowPerPage) {
		this.rowPerPage = rowPerPage;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getBeginRow() {
		return beginRow;
	}

	public void setBeginRow(int beginRow) {
		this.beginRow = beginRow;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public String getSearchWord() {
		return searchWord;
	}

	public void setSearchWord(String searchWord) {
		this.searchWord = searchWord;
	}

	public int getLastPage() {
		return lastPage;
	}

	public void setLastPage(int lastPage) {
		this.lastPage = lastPage;
	}

	public int getPageCount() {
		return pageCount;
	}

	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
	}

	public int getStartPage() {
		return startPage;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	private int rowPerPage;		// 페이지 분할 갯수
	private int currentPage;	// 현재 페이지
	private int beginRow;		// 시작행
	private int totalCount;		// 데이터 전체 수
	private String searchWord; 	// 검색어
	private Map<String, Object> searchList;
	private int lastPage;		// 마지막 페이지 번호
	private int pageCount = 5; 	// 한 화면에 보여줄 그룹 번호 개수 [<<][1][2][3][4][5][>>]
	private int startPage;		// 그룹 시작 번호
	private int endPage;		// 그룹 끝 번호
	
	/** 페이징 생성자(<페이지 분할갯수>, <현재 페이지>, <데이터 전체 개수>, <검색어>)**/
	public Page(int rowPerPage, int currentPage, int totalCount, String searchWord) {
		this.rowPerPage = rowPerPage;
		this.currentPage = currentPage;
		this.totalCount = totalCount;
		this.searchWord= searchWord;
		this.beginRow = currentPage * rowPerPage;
		
		// 전체 페이지 수
		this.lastPage = (int) Math.ceil((double) totalCount / rowPerPage);

		// 페이지 그룹 시작 번호
		this.startPage = ((currentPage - 1) / pageCount) * pageCount + 1;

		// 페이지 그룹 끝 번호
		this.endPage = startPage + pageCount - 1;
		if (endPage > lastPage) {
			endPage = lastPage;
		}
	}

	/** 검색 조건 많을때 **/
	public Page(int rowPerPage, int currentPage, int totalCount, Map<String, Object> searchList) {
		this.rowPerPage = rowPerPage;
		this.currentPage = currentPage;
		this.totalCount = totalCount;
		this.searchList = searchList;
		this.beginRow = currentPage * rowPerPage;
		
		// 전체 페이지 수
		this.lastPage = (int) Math.ceil((double) totalCount / rowPerPage);

		// 페이지 그룹 시작 번호
		this.startPage = ((currentPage - 1) / pageCount) * pageCount + 1;

		// 페이지 그룹 끝 번호
		this.endPage = startPage + pageCount - 1;
		if (endPage > lastPage) {
			endPage = lastPage;
		}
	}
	
	public Map<String, Object> getSearchList() {
		return searchList;
	}

	public void setSearchList(Map<String, Object> searchList) {
		this.searchList = searchList;
	}

	public boolean isPrevGroup() {
	    return startPage > 1;
	}

	public boolean isNextGroup() {
	    return endPage < lastPage;
	}

	public int getPrevGroupPage() {
	    return startPage - 1;
	}

	public int getNextGroupPage() {
	    return endPage + 1;
	}
	
}
