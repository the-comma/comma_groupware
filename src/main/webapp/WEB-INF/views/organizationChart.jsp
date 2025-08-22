<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<!-- CSS -->
	<jsp:include page ="../views/nav/head-css.jsp"></jsp:include>
	
   	<!-- App 아이콘 -->
	<link rel="shortcut icon" href="/HTML/Admin/dist/assets/images/favicon.ico">
<meta charset="UTF-8">
<title>조직도</title>
</head>
<style>
    /* thead 배경색 + 글자색 */
    .table thead th {
        background-color: #343a40; /* 원하는 색 */
        color: #ffffff;            /* 글자색 */
        text-align: center;        /* 가운데 정렬 (선택) */
    }

    /* hover 될 때 행 색상 */
    .table-hover tbody tr:hover {
        background-color: #f5f5f5; /* 연한 회색 */
        cursor: pointer;           /* 마우스 올렸을 때 손가락 모양 */
    }

    /* 원하는 경우 td 기본 padding / border도 조정 가능 */
    .table td {
    	text-align: center;
        vertical-align: middle;
    }
</style>
<body>
    <!-- 페이지 시작 -->
    <div class="wrapper">

	<!-- 사이드바 -->
	<jsp:include page ="../views/nav/sidenav.jsp"></jsp:include>
	
	<!-- 헤더 -->
	<jsp:include page ="../views/nav/header.jsp"></jsp:include>
	
        <div class="page-content">

            <div class="page-container">
            
            	<div class="container">
            	<!-- 본문 내용 -->
            	
            	<div class="row">
                    <div class="col-16">
                        <div class="card">
                            <div class="card-header border-bottom border-dashed d-flex align-items-center">
                                <h4 class="header-title">콤마컴퍼니 조직도</h4>
                            </div>

                            <div class="card-body">
                            	<p class="text-muted">
	                            	<!-- 부가 설명 -->
	                            	사원 이름을 클릭하면 사원카드를 확인할 수 있습니다.
                                </p>
                                <div class="row">
                                    <div class="col-lg-3">
                                        <form>
                                            <!-- 사원카드 출력 -->
											<div id="standard-modal" class="modal fade" tabindex="-1" aria-labelledby="standard-modalLabel" aria-hidden="true">
											    <div class="modal-dialog">
											        <div class="modal-content">

											        </div>
											    </div>
											</div>
											<!-- 사원카드 끝 -->
											
												<div class="mb-3">
										        <!-- 왼쪽: 부서/팀 -->
									            <c:if test="${deptTeam == null}">
									                부서/팀이 없습니다.
									            </c:if>
									            <c:if test="${deptTeam != null}">
									            	<h4>부서/팀 선택</h4>
									                <a class="link-offset-2 link-offset-3-hover text-decoration-underline link-underline link-underline-opacity-0 link-underline-opacity-75-hover" 
									                	href="?page=0">콤마컴퍼니</a><br>
									                <c:forEach items="${deptTeam}" var="dept">
									                    &nbsp;&nbsp;&nbsp;<a class="link-offset-2 link-offset-3-hover text-decoration-underline link-underline link-underline-opacity-0 link-underline-opacity-75-hover" 
									                    						href="?page=0&name=${page.searchWord}&dept=${dept.key}">ㄴ${dept.key}</a>
									                    <c:forEach items="${dept.value}" var="team">
									                        <br>
									                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a class="link-offset-2 link-offset-3-hover text-decoration-underline link-underline link-underline-opacity-0 link-underline-opacity-75-hover" 
									                        										href="?page=0&name=${page.searchWord}&dept=${dept.key}&team=${team}">ㄴ${team}</a>
									                    </c:forEach>
									                    <br>
									                </c:forEach>
									            </c:if>
											<!-- 왼쪽 영역 끝 -->
											</div>
                                        </form>
                                    </div> <!-- end col -->

                                    <div class="col-lg-9">
                                        <form>
                                            <div class="mb-3">
                                                <!-- 오른쪽: 사원 리스트 -->
										        	<!-- 이름 검색 -->
										            <div class="row mb-6" style="margin-bottom:10px;">
										            	<form action="organizationChart" method="get">
										            		<div class="col-3">
											                <input type="text" class="form-control" name="name" placeholder="이름으로 검색.." value="${name != null ? name : ''}">
											                </div>
											                <div class="col-3">
											                <button type="submit" class="btn btn-primary">검색</button>
											                </div>
										                </form>
										            </div>
										            <!-- 이름 검색 끝 -->
										            
										            <c:if test="${totalCount == 0}">
										                사원이 없습니다.
										            </c:if>
										            <c:if test="${totalCount != 0}">
										                <div class="table-responsive-sm">
										                    <table class="table table-hover mb-0">
										                        <thead>
										                        <tr>
										                            <th>
											                            <a style="color:${page.searchList.order == 'empName' ? '#228ae2' : 'white'}" href="?page=${page.prevGroupPage}&name=${page.searchList.name}&dept=${page.searchList.dept}&team=${page.searchList.team}&order=empName&sort=${page.searchList.order == 'empName' && page.searchList.sort == 'asc' ? 'desc' : 'asc'}">
																			이름
																			<c:if test="${page.searchList.order == 'empName'}">
																			<i class="ri-arrow-${page.searchList.sort == 'asc' ? 'up' : 'down'}-line"></i>
																			</c:if>
																		</a>
																	</th>
										                            <th><a style="color:${page.searchList.order == 'empEmail' ? '#228ae2' : 'white'}" href="?page=${page.prevGroupPage}&name=${page.searchList.name}&dept=${page.searchList.dept}&team=${page.searchList.team}&order=empEmail&sort=${page.searchList.order == 'empEmail' && page.searchList.sort == 'asc' ? 'desc' : 'asc'}">
																			이메일
																			<c:if test="${page.searchList.order == 'empEmail'}">
																			<i class="ri-arrow-${page.searchList.sort == 'asc' ? 'up' : 'down'}-line"></i>
																			</c:if>
																		</a></th>
										                            <th><a style="color:${page.searchList.order == 'rankName' ? '#228ae2' : 'white'}" href="?page=${page.prevGroupPage}&name=${page.searchList.name}&dept=${page.searchList.dept}&team=${page.searchList.team}&order=rankName&sort=${page.searchList.order == 'rankName' && page.searchList.sort == 'asc' ? 'desc' : 'asc'}">
																			직급
																			<c:if test="${page.searchList.order == 'rankName'}">
																			<i class="ri-arrow-${page.searchList.sort == 'asc' ? 'up' : 'down'}-line"></i>
																			</c:if>
																		</a></th>
										                            <th><a style="color:${page.searchList.order == 'deptName' ? '#228ae2' : 'white'}" href="?page=${page.prevGroupPage}&name=${page.searchList.name}&dept=${page.searchList.dept}&team=${page.searchList.team}&order=deptName&sort=${page.searchList.order == 'deptName' && page.searchList.sort == 'asc' ? 'desc' : 'asc'}">
																			부서
																			<c:if test="${page.searchList.order == 'deptName'}">
																			<i class="ri-arrow-${page.searchList.sort == 'asc' ? 'up' : 'down'}-line"></i>
																			</c:if>
																		</a></th>
										                            <th><a style="color:${page.searchList.order == 'teamName' ? '#228ae2' : 'white'}" href="?page=${page.prevGroupPage}&name=${page.searchList.name}&dept=${page.searchList.dept}&team=${page.searchList.team}&order=teamName&sort=${page.searchList.order == 'teamName' && page.searchList.sort == 'asc' ? 'desc' : 'asc'}">
																			팀
																			<c:if test="${page.searchList.order == 'teamName'}">
																			<i class="ri-arrow-${page.searchList.sort == 'asc' ? 'up' : 'down'}-line"></i>
																			</c:if>
																		</a></th>
										                        </tr>
										                    </thead>
										                    <tbody>
										                        <c:forEach items="${organiList}" var="e">
										                        <tr>
										                            <td>
																	    <a class="link-dark" href="javascript:void(0)" onclick="openEmpCard(${e.empId})">${e.empName}</a>
																	</td>
																	
																	<script>
																	function openEmpCard(empId){
																	    // 모달 내부 내용 비우고 새로운 JSP 로드
																	    $("#standard-modal .modal-content").load("/employeeCard?id=" + empId, function(){
																	        $("#standard-modal").modal("show"); // 로드 끝나면 모달 띄우기
																	    });
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
											            <div style="display:flex; justify-content:center; align-items:center; margin:10px">
											            <nav>
						                                    <ul class="pagination pagination-boxed">
						                                    
						                                    <c:if test="${page.prevGroup}">
																<c:if test="${page.currentPage != 0}">
																	<li class="page-item">
																	<a class="page-link" aria-label="Previous"
																		href="?page=${page.prevGroupPage}&name=${page.searchWord}&dept=${dept}&team=${team}&order=empName&sort=${page.searchList.sort}">
																		<i class="ti ti-chevron-left"></i>
																	</a>
																	</li>
																</c:if>
															</c:if>
															
												            <!-- [1][2][3][4][5] -->
												            <c:forEach var="i" begin="${page.startPage}" end="${page.endPage}">
												            	<li class="page-item <c:if test='${i-1 == page.currentPage}'>active</c:if>">
												            	<a class="page-link" href="?page=${i-1}&name=${page.searchWord}&dept=${dept}&team=${team}&order=empName&sort=${page.searchList.sort}">${i}</a>
												            	</li>
												            </c:forEach>
					                                        
											            	<c:if test="${page.nextGroup}">
													            <c:if test="${page.currentPage != page.lastPage - 1}">
													             <li class="page-item">
																	<a class="page-link" aria-label="Next"
																		href="?page=${page.nextGroupPage}&name=${page.searchWord}&dept=${dept}&team=${team}&order=empName&sort=${page.searchList.sort}">
																		<i class="ti ti-chevron-right align-middle"></i>
																	</a>
																 <li class="page-item">
																</c:if>
															</c:if>
														
															</ul>
														Showing ${page.currentPage + 1} to 10 of ${page.lastPage} entries
														</nav>
														</div>
														<!-- 페이징 끝 -->
										            </c:if>
										            <!-- 사원 리스트 끝 -->
										        </div>
										        <!-- 오른쪽 영역 끝 -->
                                            </div>
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
            	<jsp:include page ="../views/nav/footer.jsp"></jsp:include>
            	
            </div><!-- page-container 끝 -->
            
       	</div><!-- page-content 끝 -->
       	
   </div><!-- wrapper 끝 -->
       	
   <!-- 자바 스크립트 -->
   <jsp:include page ="../views/nav/javascript.jsp"></jsp:include>
</body>
</html>