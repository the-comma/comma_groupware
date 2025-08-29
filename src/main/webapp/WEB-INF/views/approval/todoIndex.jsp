<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<!-- CSS -->
	<jsp:include page ="../../views/nav/head-css.jsp"></jsp:include>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
    <!-- 페이지 시작 -->
    <div class="wrapper">

	<!-- 사이드바 -->
	<jsp:include page ="../../views/nav/sidenav.jsp"></jsp:include>
	
	<!-- 헤더 -->
	<jsp:include page ="../../views/nav/header.jsp"></jsp:include>
	
        <div class="page-content">

            <div class="page-container">
            
            	<div class="container">
            	<!-- 본문 내용 -->
            	
            	<div class="row">
                    <div class="col-16">
                        <div class="card">
                            <div class="card-header border-bottom border-dashed d-flex align-items-center">
                                <h4 class="header-title">결재하기</h4>
                            </div>

                            <div class="card-body">
                                <p class="text-muted">
	                            	<!-- 부가 설명 -->
                                </p>
                                <div class="row">
                                    <div class="col-lg-12">
                                        <form>
                                        
	<c:if test="${not empty error}">
	  <div style="color:#b91c1c; background:#fee2e2; padding:8px 12px; border-radius:8px; margin-bottom:8px;">
	    ${error}
	  </div>
	</c:if>
	<c:if test="${not empty msg}">
	  <div style="color:#065f46; background:#d1fae5; padding:8px 12px; border-radius:8px; margin-bottom:8px;">
	    ${msg}
	  </div>
	</c:if>

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
       	<a class="btn" href="/approval">홈으로</a>
                                       </form>
                                    </div> <!-- end col -->
                                </div>
                                <!-- end row-->
                            </div> <!-- end card-body -->
                        </div> <!-- end card -->
                    </div><!-- end col -->
                </div><!-- end row -->
            	
            	
            	<!-- 본문 내용 끝 -->
            
            	</div><!-- container 끝 -->
            	
            	<!-- 푸터 -->
            	<jsp:include page ="../../views/nav/footer.jsp"></jsp:include>
            	
            </div><!-- page-container 끝 -->
            
       	</div><!-- page-content 끝 -->
       	
   </div><!-- wrapper 끝 -->
       	
   <!-- 자바 스크립트 -->
   <jsp:include page ="../../views/nav/javascript.jsp"></jsp:include>
</body>
</html>