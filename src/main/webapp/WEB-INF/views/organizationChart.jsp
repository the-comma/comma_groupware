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
<title>조직도</title>
<!-- JQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
    body {
        font-family: Arial, sans-serif;
    }
    .container {
        display: flex;          /* 좌우 분할 */
        gap: 20px;              /* 사이 간격 */
        align-items: flex-start;/* 위쪽 맞춤 */
    }
    .org-tree {
        width: 30%;             /* 왼쪽 영역 */
        border: 1px solid #ccc;
        padding: 10px;
    }
    .emp-table {
        flex: 1;                /* 오른쪽 영역 (남는 공간 전부 차지) */
        border: 1px solid #ccc;
        padding: 10px;
    }
    .emp-table table {
        width: 100%;
        border-collapse: collapse;
    }
    .emp-table th, .emp-table td {
        border: 1px solid #ccc;
        padding: 6px;
        text-align: center;
    }
    .emp-table th {
        background-color: #f5f5f5;
    }
</style>
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
    <h1>조직도</h1>
    
    <!-- 모달창 출력 -->
	<div class="empCard">
	</div>
	
    <div class="container">
        <!-- 왼쪽: 부서/팀 -->
        <div class="org-tree">
            <c:if test="${deptTeam == null}">
                부서/팀이 없습니다.
            </c:if>
            <c:if test="${deptTeam != null}">
                <a href="?page=0">콤마컴퍼니</a><br>
                <c:forEach items="${deptTeam}" var="dept">
                    &nbsp;&nbsp;&nbsp;<a href="?page=0&name=${page.searchWord}&dept=${dept.key}">ㄴ${dept.key}</a>
                    <c:forEach items="${dept.value}" var="team">
                        <br>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="?page=0&name=${page.searchWord}&dept=${dept.key}&team=${team}">ㄴ${team}</a>
                    </c:forEach>
                    <br>
                </c:forEach>
            </c:if>
        </div>
		<!-- 왼쪽 영역 끝 -->
		
        <!-- 오른쪽: 사원 리스트 -->
        <div class="emp-table">
        	<!-- 이름 검색 -->
            <div style="margin-bottom:10px;">
            	<form action="organizationChart" method="get">
	                <input type="text" class="name" name="name" placeholder="이름으로 검색.." value="${name != null ? name : ''}">
	                <button type="submit">검색</button>
                </form>
            </div>
            <!-- 이름 검색 끝 -->
            
            <c:if test="${totalCount == 0}">
                사원이 없습니다.
            </c:if>
            <c:if test="${totalCount != 0}">
                <div class="table-responsive-sm">
                    <table class="table mb-0">
                        <thead class="table-light">
                        <tr>
                            <th>이름</th><th>이메일</th><th>직급</th><th>부서</th><th>팀</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${organiList}" var="e">
                        <tr>
                            <td onclick="openEmpCard(${e.empId})">${e.empName}</td>
                            <script>
                            	/** 이름 클릭하면 모달창 생성**/
                            	function openEmpCard(empId){
                            		$('.empCard').load("/employeeCard?id=" + empId);
                            	}
                            </script>
                            <td>${e.empEmail}</td>
                            <td>${e.rankName}</td>
                            <td>${e.deptName}</td>
                            <td>${e.teamName}</td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
                </div>
                
                <!-- 페이징 -->
				<c:if test="${page.currentPage != 0}">
					<a href="?page=${page.currentPage - 1}&name=${page.searchWord}&dept=${dept}&team=${team}">이전</a>
				</c:if>
	
	            ${page.currentPage + 1} / ${page.lastPage}
	            
	            <c:if test="${page.currentPage != page.lastPage - 1}">
					<a href="?page=${page.currentPage + 1}&name=${page.searchWord}&dept=${dept}&team=${team}">다음</a>
				</c:if>
				<!-- 페이징 끝 -->
            </c:if>
            <!-- 사원 리스트 끝 -->
        </div>
        <!-- 오른쪽 영역 끝 -->
        
    </div>
    </div> <!-- container -->

			<%@ include file="/HTML/Admin/src/partials/footer.html" %>
        </div>

        <!-- ============================================================== -->
        <!-- End Page content -->
        <!-- ============================================================== -->

    </div>
    <!-- END wrapper -->
    
    <%@ include file="/HTML/Admin/src/partials/customizer.html" %>
    
    <%@ include file="/HTML/Admin/src/partials/footer-scripts.html" %>
</body>
</html>
