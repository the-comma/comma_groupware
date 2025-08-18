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
	<h2>[<c:out value="${notice.isPin==1 ? 'PIN ' : ''}"/>] <c:out value="${notice.noticeTitle}"/></h2>
	<div>작성자: ${notice.writerId} | 조회수: ${notice.noticeViewCount} | 작성일: ${notice.createdAt}</div>
	<hr/>
	<div style="white-space:pre-wrap;">${notice.noticeContent}</div>
	
	<c:if test="${not empty files}">
	  <h4>첨부파일</h4>
	  <ul>
	    <c:forEach var="f" items="${files}">
	      <li><a href="/notice/file/download/${f.fileId}">${f.fileOriginName}</a></li>
	    </c:forEach>
	  </ul>
	</c:if>
	
	<div style="margin-top:16px;">
	  <a href="/notice/edit?noticeId=${notice.noticeId}">수정</a>
	  <form method="post" action="/notice/remove" style="display:inline;">
	    <input type="hidden" name="noticeId" value="${notice.noticeId}"/>
	    <button type="submit" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
	  </form>
	  <a href="/notice/list">목록</a>
	</div>
</body>
</html>