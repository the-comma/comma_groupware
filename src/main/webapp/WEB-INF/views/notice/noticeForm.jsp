<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
	<h2>공지 ${empty notice.noticeId ? '작성' : '수정'}</h2>
	
	<form method="post" enctype="multipart/form-data"
	      action="${empty notice.noticeId ? '/notice/add' : '/notice/edit'}">
	
	  <c:if test="${not empty notice.noticeId}">
	    <input type="hidden" name="noticeId" value="${notice.noticeId}"/>
	  </c:if>
	
	  <div>
	    <label>제목</label>
	    <input type="text" name="noticeTitle" value="${notice.noticeTitle}" required/>
	  </div>
	
	  <div>
	    <label>내용</label><br/>
	    <textarea name="noticeContent" rows="10" cols="80" required>${notice.noticeContent}</textarea>
	  </div>
	
	  <div>
	    <label>최상단 고정</label>
	    <input type="checkbox" name="isPin" value="1" <c:if test="${notice.isPin == 1}">checked</c:if> />
	  </div>
	
	  <div>
	    <label>파일 첨부(여러개)</label>
	    <input type="file" name="files" multiple />
	  </div>
	
	  <c:if test="${not empty files}">
	    <h4>기존 첨부파일</h4>
	    <ul>
	      <c:forEach var="f" items="${files}">
	        <li>
	          <a href="/notice/file/download/${f.fileId}">${f.fileOriginName}</a>
	          <form method="post" action="/notice/file/remove" style="display:inline;">
	            <input type="hidden" name="fileId" value="${f.fileId}"/>
	            <input type="hidden" name="noticeId" value="${notice.noticeId}"/>
	            <button type="submit">삭제</button>
	          </form>
	        </li>
	      </c:forEach>
	    </ul>
	  </c:if>
	
	  <div style="margin-top:10px;">
	    <button type="submit">저장</button>
	    <a href="/notice/list">목록</a>
	  </div>
	</form>
</body>
</html>