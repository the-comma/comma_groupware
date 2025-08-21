<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<!-- Vendor css -->
    <link href= "<c:url value='/HTML/Admin/dist/assets/css/vendor.min.css'/>" rel="stylesheet" type="text/css" />

    <!-- App css -->
    <link href= "<c:url value='/HTML/Admin/dist/assets/css/app.min.css'/>"  rel="stylesheet" type="text/css" id="app-style" />

    <!-- Icons css -->
    <link href= "<c:url value='/HTML/Admin/dist/assets/css/icons.min.css'/>" rel="stylesheet" type="text/css" />

   <!-- App favicon -->
	<link rel="shortcut icon" href="/HTML/Admin/dist/assets/images/favicon.ico">
<meta charset="UTF-8">
<title>프로젝트 추가</title>
</head>
<body>
    <!-- Begin page -->
    <div class="wrapper">

	<!-- Menu -->
	<%@ include file="/HTML/Admin/src/partials/sidenav.html" %>
	
	<c:choose>
	  <c:when test="${not empty title}">
	    <jsp:include page="/HTML/Admin/src/partials/topbar.html">
	      <jsp:param name="topbarTitle" value="${title}" />
	    </jsp:include>
	  </c:when>
	  <c:otherwise>
	    <%@ include file="/HTML/Admin/src/partials/topbar.html" %>
	  </c:otherwise>
	</c:choose>
	
	<%-- 필요하면 수평 네비게이션 활성화
	<%@ include file="/WEB-INF/views/partials/horizontal-nav.jsp" %>
	--%>

        <!-- ============================================================== -->
        <!-- Start Page Content here -->
        <!-- ============================================================== -->

        <div class="page-content">

            <div class="page-container">
            
            <div class="container">
				<h1>프로젝트 추가</h1>
				
				<form action="/addProjectForm" method="post" id="project" name="project">
					<label for="empName">PM</label>
					<input type="text" id="empName" name="empName" value=""><br>
					
					<label for="projectTitle">프로젝트 명</label>
					<input type="text" id="projectTitle" name="projectTitle" placeholder="프로젝트 명 입력.."><br>
					
					<label for="projectDesc">설명</label>
					<textarea rows="10" cols="20" id="projectDesc" name="projectDesc"></textarea><br>
					
					<label for="projectGitUrl">Github URL</label>
					<input type="text" id="projectGitUrl" name="projectGitUrl" placeholder="Git URL 입력.."><br>
					
					<label for="startDate">시작일</label>
					<input type="date" id="startDate" name="startDate"><br>
					
					<label for="endDate">마감일</label>
					<input type="date" id="endDate" name="endDate"><br>
					
					FE 개발자
					<!-- 추가 버튼 -->
                    <button type="button" class="btn btn-secondary" data-bs-toggle="modal"
                     data-bs-target="#scrollable-modal">추가</button>	<br>
					<input type="text"><br>
					
					<!-- 모달 -->
					<div class="modal fade" id="scrollable-modal" tabindex="-1" role="dialog"
	                    aria-labelledby="scrollableModalTitle" aria-hidden="true">
	                    <div class="modal-dialog modal-dialog-scrollable" role="document">
	                        <div class="modal-content">
	                            <div class="modal-header">
	                                <h4 class="modal-title" id="scrollableModalTitle">개발자 추가</h4>
	                                <button type="button" class="btn-close" data-bs-dismiss="modal"
	                                    aria-label="Close"></button>
	                            </div>
	                            <div class="modal-body">
	                            	부서/팀<br>
	                                <select id="deptTeam" name="deptTeam">
	                                	<option value="">부서/팀 선택</option>
	                                	<c:if test="${deptTeamList != null}">
	                                		<c:forEach items="${deptTeamList}" var="dept">
	                                			<option value="${dept.teamName}">${dept.deptName}/${dept.teamName}</option>
							                </c:forEach>
	                                	</c:if>
	                                </select>
	                                
	                                <br>사원<br>
	                                <table>
	                                	<tbody id="empList" name="empList">
	                                	</tbody>
	                                </table>	                                
	                                <br>
	                                <br>
	                                <br>
	                                <br>
	                                <br>
	                                <br>
	                                <br>
	                                <br>
	                                <br>
	                            </div>
	                            <div class="modal-footer">
	                                <button type="button" class="btn btn-secondary"
	                                    data-bs-dismiss="modal">취소</button>
	                                <button type="button" class="btn btn-primary">등록</button>
	                            </div>
	                        </div><!-- /.modal-content -->
	                    </div><!-- /.modal-dialog -->
	                </div><!-- /.modal -->
					
					BE 개발자 <button>추가</button><br>
					<input type="text"><br>
					
					기획자 <button>추가</button><br>
					<input type="text"><br>
					
					<button type="submit">생성</button>
				</form>
		    </div> <!-- container -->

			<%@ include file="/HTML/Admin/src/partials/footer.html" %>
        </div>

        <!-- ============================================================== -->
        <!-- End Page content -->
        <!-- ============================================================== -->

    </div>
    </div>
    
    <script>
    	document.querySelector('#deptTeam').addEventListener('change',function() {
    		if(this.value == ''){
    			alert('부서/팀을 선택하세요');
    			return;
    		}
    	/*
			fetch("API 주소", {method: "POST"})
			.then((respons) => {return response.json()})
			.then((data) => {console.log(data)})
			.catch((error) => {console.log(error)});
		*/
		fetch('/empListByTeam/'+this.value)
		.then(function(res){
			return res.json();
		})
		.then(function(result) {
			document.querySelector('#empList').innerHTML = '';
			result.forEach(function(e){
				document.querySelector('#empList').innerHTML += `
					<tr>
						<td><input type="checkbox"></td>
						<td>[\${e.rankName}]</td>
						<td>\${e.empName}</td>
						<td>\${e.empExp}</td>
					</tr>
				`;
			})
		});
    	})
    	
		
    </script>
    
    <!-- END wrapper -->
    <%@ include file="/HTML/Admin/src/partials/customizer.html" %>
    <%@ include file="/HTML/Admin/src/partials/footer-scripts.html" %>
</body>
</html>