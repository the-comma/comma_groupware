<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원카드</title>
<!-- JQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<jsp:include page ="../views/nav/head-css.jsp"></jsp:include>
</head>
<body>
	<c:if test="${emp != null}">
		<div class="modal-header p-1">
			<div class="w-100" style="position: relative; padding-top: 100%; background: #f8f9fa;"> 
			<img src="/HTML/Admin/dist/assets/images/default_profile.png" alt="사원사진" 
			style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; border-radius: 8px; overflow: hidden;"> 
			</div> 
			<button type="button" class="btn-close position-absolute top-0 end-0 m-2" data-bs-dismiss="modal"></button> 
		</div>
		
		<div class="modal-body">
		  <div class="row">
		    <div class="col-6 mb-2">
		      <label class="form-label">이름</label>
		      <p class="mb-0">${emp.empName}</p>
		    </div>
		    <div class="col-6 mb-2">
		      <label class="form-label">직급</label>
		      <p class="mb-0">${emp.rankName != null ? emp.rankName : '없음'}</p>
		    </div>
		    <div class="col-6 mb-2">
		      <label class="form-label">부서</label>
		      <p class="mb-0">${emp.deptName != null ? emp.deptName : '미배정'}</p>
		    </div>
		    <div class="col-6 mb-2">
		      <label class="form-label">팀</label>
		      <p class="mb-0">${emp.teamName != null ? emp.teamName : '미배정'}</p>
		    </div>
		    <div class="col-12 mb-2">
		      <label class="form-label">이메일</label>
		      <p class="mb-0">${emp.empEmail}</p>
		    </div>
		  </div>
		</div>

		
		<div class="modal-footer">
		  <button class="btn btn-secondary" data-bs-dismiss="modal">1:1채팅</button>
		  <button class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
		</div>
	</c:if>
</body>
</html>