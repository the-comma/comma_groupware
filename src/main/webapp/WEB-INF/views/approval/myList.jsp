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
<h3>내 결재문서 (${empty status ? '전체' : status})</h3>
<table class="table">
  <tr><th>ID</th><th>제목</th><th>유형</th><th>상태</th><th>작성</th><th>완료</th><th></th></tr>
  <c:forEach var="r" items="${items}">
    <tr>
      <td>${r.approvalDocumentId}</td>
      <td>${r.title}</td>
      <td>${r.documentType}</td>
      <td>${r.status}</td>
      <td>${r.createdAt}</td>
      <td>${r.completeAt}</td>
      <td><a href="<c:url value='/approval/doc/${r.approvalDocumentId}'/>">상세</a></td>
    </tr>
  </c:forEach>
</table>
</body>
</html>