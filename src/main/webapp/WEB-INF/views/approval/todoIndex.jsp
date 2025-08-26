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
<h3>결재하기</h3>

<h4>해야할 결재</h4>
<table class="table">
  <tr><th>문서ID</th><th>제목</th><th>유형</th><th>단계</th><th>작성자</th><th>열기</th></tr>
  <c:forEach var="r" items="${todo}">
    <tr>
      <td>${r.approvalDocumentId}</td>
      <td>${r.title}</td>
      <td>${r.documentType}</td>
      <td>${r.step}</td>
      <td>${r.writerEmpId}</td>
      <td><a href="<c:url value='/approval/doc/${r.approvalDocumentId}'/>">보기</a></td>
    </tr>
  </c:forEach>
</table>

<h4>완료된 결재</h4>
<table class="table">
  <tr><th>문서ID</th><th>제목</th><th>유형</th><th>내 처리</th><th>처리일</th></tr>
  <c:forEach var="r" items="${done}">
    <tr>
      <td>${r.approvalDocumentId}</td>
      <td>${r.title}</td>
      <td>${r.documentType}</td>
      <td>${r.lineStatus}</td>
      <td>${r.approveAt}</td>
    </tr>
  </c:forEach>
</table>
</body>
</html>