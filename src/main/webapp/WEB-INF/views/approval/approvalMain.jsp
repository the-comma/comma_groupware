<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
<h2>전자결재</h2>
<div>
  <a href="<c:url value='/approval/vacations/new'/>"  class="btn btn-success">휴가신청서 작성</a>
  <a href="<c:url value='/approval/expenses/new'/>"  class="btn btn-success">지출결의서 작성</a>
  <a href="<c:url value='/approval/todo'/>" class="btn btn-warning">해야 할 결재</a>
</div> 
 <hr>
 <div>
  <a href="<c:url value='/approval?status='/>" class="btn btn-primary">전체 신청내역</a>
  <a href="<c:url value='/approval?status=IN_PROGRESS'/>" class="btn btn-secondary">진행중인결재</a>
  <a href="<c:url value='/approval?status=REJECTED'/>" class="btn btn-secondary">반려된결재</a>
  <a href="<c:url value='/approval?status=APPROVED'/>" class="btn btn-secondary">완료된결재</a>  
</div>

<!-- 현재 필터 표시 -->
<p>
  현재 필터:
  <strong>
    <c:choose>
      <c:when test="${empty status}">전체</c:when>
      <c:when test="${status eq 'IN_PROGRESS'}">진행중</c:when>
      <c:when test="${status eq 'REJECTED'}">반려</c:when>
      <c:when test="${status eq 'APPROVED'}">완료</c:when>
      <c:otherwise>${status}</c:otherwise>
    </c:choose>
  </strong>
</p>

<!-- 리스트 테이블 -->
<table class="table" border="1" cellpadding="6" cellspacing="0">
  <thead>
    <tr>
      <th>구분</th>
      <th>ID</th>
      <th>제목</th>
      <th>상태</th>
      <th>작성일</th>
      <th>완료일</th>
      <th>보기</th>
    </tr>
  </thead>
  <tbody>
  <c:choose>
    <c:when test="${empty items}">
      <tr>
        <td colspan="7" style="text-align:center;">표시할 문서가 없습니다.</td>
      </tr>
    </c:when>
    <c:otherwise>
      <c:forEach var="r" items="${items}">
        <tr>
       	  <td>  
       	  	<c:choose>
    			 <c:when test="${fn:toLowerCase(r.documentType) eq 'vacation'}">휴가</c:when>
   				 <c:when test="${fn:toLowerCase(r.documentType) eq 'expense'}">지출</c:when>
   				 <c:otherwise>${r.documentType}</c:otherwise>
  			</c:choose>
  		  </td>
          <td>${r.approvalDocumentId}</td>
          <td>${r.title}</td>
          <td>${r.status}</td>
          <td>${r.createdAt}</td>
          <td>${r.completeAt}</td>
          <td><a href="<c:url value='/approval/doc/${r.approvalDocumentId}'/>">상세</a></td>
        </tr>
      </c:forEach>
    </c:otherwise>
  </c:choose>
  </tbody>
</table>
</body>
</html>