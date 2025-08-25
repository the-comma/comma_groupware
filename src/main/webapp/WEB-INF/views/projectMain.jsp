<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>

	<!-- CSS -->
	<jsp:include page ="../views/nav/head-css.jsp"></jsp:include>
<meta charset="UTF-8">
<title>프로젝트 메인</title>
</head>
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
                    <div class=col-12>
                        <div class="card">
                            <div class="card-header justify-content-between d-sm-flex gap-2">
                            	<a href="projectMain?view=table" class="btn btn-info mb-sm-0 mb-2">
                                    <i class="ti ti-list fs-20 me-2"></i>테이블 뷰
                                </a>
                                <a href="projectMain?view=grid" class="btn btn-info mb-sm-0 mb-2">
                                    <i class="ti ti-layout-grid fs-20 me-2"></i>그리드 뷰
                                </a>
                                <a href="addProject" class="btn btn-primary mb-sm-0 mb-2">
                                    <i class="ti ti-circle-plus fs-20 me-2"></i>프로젝트 생성
                                </a>

                                <form class="row g-2 align-items-center">
                                    <div class="col-auto">
                                        <!-- Search Input -->
                                        <div class="d-flex align-items-start flex-wrap">
                                            <label for="membersearch-input" class="visually-hidden">Search</label>
                                            <input type="search" class="form-control border-light bg-light bg-opacity-50" id="membersearch-input"
                                                placeholder="프로젝트 명..">
                                        </div>
                                    </div>
                                </form>

                            </div>
						</div>
						
						<!-- 그리드 뷰 -->
						<c:if test="${view == 'grid' || view == ''}">
							<c:if test="${projectList != null}">
							<div class="row">
								<c:forEach items="${projectList}" var="p">
								<div class="col-xl-4" id="project-${p.projectId}">
			                        <div class="card">
			                            <div class="card-body">
			                                <div class="d-flex justify-content-between">
			                                    <div>
			                                        <h4 class="mt-0"><a href="" class="text-dark">${p.projectTitle}</a></h4>
			                                        <p class="text-dark text-uppercase fw-semibold fs-11">마감일 : ${p.endDate}</p>
			                                    </div>
			                                    <div>
													<c:choose>
														<c:when test="${p.projectStatus eq 'PROGRESS'}">
															<span class="badge badge-soft-primary p-1">진행</span>
														</c:when>
														<c:when test="${p.projectStatus eq 'PAUSED'}">
															<span class="badge badge-soft-secondary p-1">대기</span>
														</c:when>
														<c:when test="${p.projectStatus eq 'COMPLETED'}">
															<span class="badge badge-soft-success p-1">완료</span>
														</c:when>
													</c:choose>
												</div>
			                                </div>
			
			                                <p class="text-muted mb-3">${p.projectDesc}<a href="#"
			                                        class="link-dark">..더보기</a>
			                                </p>
			
			                                <ul class="list-inline">
			                                    <li class="list-inline-item me-4">
			                                        <h4 class="mb-0 lh-base">56</h4>
			                                        <p class="text-muted">미완료 작업</p>
			                                    </li>
			                                    <li class="list-inline-item">
			                                        <h4 class="mb-0 lh-base">452</h4>
			                                        <p class="text-muted">완료된 작업</p>
			                                    </li>
			                                </ul>
			
			                                <div class="d-flex align-items-center mb-3">
			                                    <h5 class="me-3 mb-0">멤버(${p.projectMemberCount}) :</h5>
			                                    <div class="avatar-group">
			                                        <a href="#" class="avatar" data-bs-toggle="tooltip" data-bs-placement="top"
			                                            aria-label="Mat Helme" data-bs-original-title="Mat Helme">
			                                            <img src="/HTML/Admin/dist/assets/images/default_profile.png" class="rounded-circle avatar-sm"
			                                                alt="friend">
			                                        </a>
			
			                                        <a href="#" class="avatar" data-bs-toggle="tooltip" data-bs-placement="top"
			                                            aria-label="Michael Zenaty" data-bs-original-title="Michael Zenaty">
			                                            <img src="/HTML/Admin/dist/assets/images/default_profile.png" class="rounded-circle avatar-sm"
			                                                alt="friend">
			                                        </a>
			
			                                        <a href="#" class="avatar" data-bs-toggle="tooltip" data-bs-placement="top"
			                                            aria-label="James Anderson" data-bs-original-title="James Anderson">
			                                            <img src="/HTML/Admin/dist/assets/images/default_profile.png" class="rounded-circle avatar-sm"
			                                                alt="friend">
			                                        </a>
			
			                                        <a href="#" class="avatar" data-bs-toggle="tooltip" data-bs-placement="top"
			                                            aria-label="Mat Helme" data-bs-original-title="Mat Helme">
			                                            <img src="/HTML/Admin/dist/assets/images/default_profile.png" class="rounded-circle avatar-sm"
			                                                alt="friend">
			                                        </a>
			                                    </div>
		                                	</div>
			
			
											<h5 class="mb-2">진행
											<c:choose>
													<c:when test="${p.projectStatus eq 'PROGRESS'}">
														<span class="text-primary float-end">80%</span>
													</c:when>
													<c:when test="${p.projectStatus eq 'PAUSED'}">
														<span class="text-secondary float-end">80%</span>
													</c:when>
													<c:when test="${p.projectStatus eq 'COMPLETED'}">
														<span class="text-success float-end">80%</span>
													</c:when>
											</c:choose>
											</h5>
											
			                                <div class="progress progress-soft progress-sm">
			                                	<c:choose>
														<c:when test="${p.projectStatus eq 'PROGRESS'}">
															<div class="progress-bar bg-primary" style="width: 80%" role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100">
			                                    			</div>
														</c:when>
														<c:when test="${p.projectStatus eq 'PAUSED'}">
															<div class="progress-bar bg-secondary" style="width: 80%" role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100">
			                                    			</div>
														</c:when>
														<c:when test="${p.projectStatus eq 'COMPLETED'}">
															<div class="progress-bar bg-success" style="width: 80%" role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100">
			                                    			</div>
														</c:when>
												</c:choose>
			                                </div>
			                            </div>
			                        </div>
			                    </div><!-- end col-->
			                    
			                    <script>
			                    	document.getElementById(`project-${p.projectId}`).addEventListener('click',function(){
										location.href=`/projectDetail?id=${p.projectId}`;
			                    	})
			                    </script>
			                    
                    		</c:forEach>
                    		</div>
                    	</c:if>
					</c:if>
						
						<!-- 테이블 뷰 -->
						<c:if test="${view == 'table'}">
							<div class="card">
	                            <div class="card-body">
	                                <p class="text-muted">
		                            	<!-- 부가 설명 -->
	                                </p>
	                                <div class="row">
	                                    <div class="col-lg-12">
	                                        <form>
	                                        	<c:if test="${projectList != null}">
												<div class="table-responsive-sm">
								                    <table class="table table-hover mb-0">
								                        <thead>
								                        	<tr>
								                        		<th>프로젝트명</th>
								                        		<th>PM</th>
								                        		<th>시작일</th>
								                        		<th>종료일</th>
								                        		<th>진행도</th>
								                        		<th>상태</th>
							                        		</tr>
								                        </thead>
								                        <tbody>
								                        	<c:forEach items="${projectList}" var="p">
								                        		<tr>
								                        			<td>${p.projectTitle}</td>
								                        			<td>${p.empName}</td>
								                        			<td>${p.startDate}</td>
								                        			<td>${p.endDate}</td>
								                        			<td>
								                        				<c:choose>
																				<c:when test="${p.projectStatus eq 'PROGRESS'}">
																					<span class="text-primary float-end">80%</span>
																				</c:when>
																				<c:when test="${p.projectStatus eq 'PAUSED'}">
																					<span class="text-secondary float-end">80%</span>
																				</c:when>
																				<c:when test="${p.projectStatus eq 'COMPLETED'}">
																					<span class="text-success float-end">80%</span>
																				</c:when>
																		</c:choose>
																		<div class="progress progress-soft progress-sm">
										                                	<c:choose>
																					<c:when test="${p.projectStatus eq 'PROGRESS'}">
																						<div class="progress-bar bg-primary" style="width: 80%" role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100">
										                                    			</div>
																					</c:when>
																					<c:when test="${p.projectStatus eq 'PAUSED'}">
																						<div class="progress-bar bg-secondary" style="width: 80%" role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100">
										                                    			</div>
																					</c:when>
																					<c:when test="${p.projectStatus eq 'COMPLETED'}">
																						<div class="progress-bar bg-success" style="width: 80%" role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100">
										                                    			</div>
																					</c:when>
																			</c:choose>
										                                </div>
								                        			</td>
								                        			<td>
								                        				<div>
																			<c:choose>
																				<c:when test="${p.projectStatus eq 'PROGRESS'}">
																					<span class="badge badge-soft-primary p-1">진행</span>
																				</c:when>
																				<c:when test="${p.projectStatus eq 'PAUSED'}">
																					<span class="badge badge-soft-secondary p-1">대기</span>
																				</c:when>
																				<c:when test="${p.projectStatus eq 'COMPLETED'}">
																					<span class="badge badge-soft-success p-1">완료</span>
																				</c:when>
																			</c:choose>
																		</div>
								                        			</td>
								                        		</tr>
								                        	</c:forEach>
								                        </tbody>
							                        </table>			                       
						                       </div>
						                       </c:if>
	                                        </form>
	                                    </div> <!-- end col -->
	                                </div>
	                                <!-- end row-->
	                            </div> <!-- end card-body -->
	                        </div> <!-- end card -->
						</c:if>	<!-- 테이블 뷰 끝 -->
						
                        <!-- 페이징 -->										                
			            <div style="display:flex; justify-content:center; align-items:center; margin:10px">
			            <nav>
	                                 <ul class="pagination pagination-boxed">
	                                 
	                                 <c:if test="${page.prevGroup}">
								<c:if test="${page.currentPage != 0}">
									<li class="page-item">
									<a class="page-link" aria-label="Previous"
										href="?page=${page.prevGroupPage}">
										<i class="ti ti-chevron-left"></i>
									</a>
									</li>
								</c:if>
							</c:if>
							
				            <!-- [1][2][3][4][5] -->
				            <c:forEach var="i" begin="${page.startPage}" end="${page.endPage}">
				            	<li class="page-item <c:if test='${i-1 == page.currentPage}'>active</c:if>">
				            	<a class="page-link" href="?page=${i-1}">${i}</a>
				            	</li>
				            </c:forEach>
	                                    
			            	<c:if test="${page.nextGroup}">
					            <c:if test="${page.currentPage != page.lastPage - 1}">
					             <li class="page-item">
									<a class="page-link" aria-label="Next"
										href="?page=${page.nextGroupPage}">
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