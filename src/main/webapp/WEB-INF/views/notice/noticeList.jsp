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
	<h2>공지사항</h2>
	
	<form method="get" action="/notice/list">
	  <input type="text" name="keyword" value="${keyword}" placeholder="제목/내용 검색"/>
	  <button type="submit">검색</button>
	  <a href="/notice/add">글쓰기</a>
	</form>
	
	<table class="table">
	  <thead>
	    <tr>
	      <th>핀</th>
	      <th>제목</th>
	      <th>작성자ID</th>
	      <th>첨부</th>
	      <th>조회</th>
	      <th>작성일</th>
	    </tr>
	  </thead>
	  <tbody>
	    <c:forEach var="n" items="${data.list}">
	      <tr>
	        <td><c:if test="${n.isPin == 1}"><span class="pin">PIN</span></c:if></td>
	        <td><a href="/notice/one?noticeId=${n.noticeId}"><c:out value="${n.noticeTitle}"/></a></td>
	        <td>${n.writerId}</td>
	        <td><c:if test="${n.isFile == 1}">📎</c:if></td>
	        <td>${n.noticeViewCount}</td>
	        <td>${n.createdAt}</td>
	      </tr>
	    </c:forEach>
	    <c:if test="${empty data.list}">
	      <tr><td colspan="6">등록된 공지사항이 없습니다.</td></tr>
	    </c:if>
	  </tbody>
	</table>
</body>
</html>