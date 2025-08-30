<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<!-- CSS -->
	<jsp:include page ="../views/nav/head-css.jsp"></jsp:include>

<meta charset="UTF-8">
<title>프로젝트 상세</title>
</head>
<script>

</script>
<style>
.mention-tag {
  color: #0d6efd;      /* 파랑색 */
  font-weight: 600;
  cursor: pointer;
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
                    <div class=col-12>
                        <div class="card">
                            <div class="card-header justify-content-between d-sm-flex gap-2">
                            	<!-- 프로젝트 타이틀 -->
                            	<h1>${project.projectTitle}</h1>
                            	
                            	<!-- 상태 뱃지 -->
                            	<c:choose>
									<c:when test="${project.projectStatus eq 'PROGRESS'}">
										<h1 class="badge badge-soft-primary p-1">진행</h1>
									</c:when>
									<c:when test="${project.projectStatus eq 'PAUSED'}">
										<h1 class="badge badge-soft-secondary p-1">대기</h1>
									</c:when>
									<c:when test="${project.projectStatus eq 'COMPLETED'}">
										<h1 class="badge badge-soft-success p-1">완료</h1>
									</c:when>
								</c:choose>
                            	
                                <a href="addProject" class="btn btn-primary mb-sm-0 mb-2">
                                    <i class="ti ti-settings fs-20 me-2"></i>프로젝트 수정
                                </a>
                            </div>
						</div>
						
					<div class="row">
                        <div class="card">
                            <div class="card-body">
                                <ul class="nav nav-tabs nav-bordered mb-3" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <a href="#main-b1" data-url="/project/${project.projectId}/main" data-bs-toggle="tab" aria-expanded="true" class="nav-link" aria-selected="false" role="tab" tabindex="-1">
                                            <i class="ti ti-home fs-18 me-md-1"></i>
                                            <span class="d-none d-md-inline-block">메인</span>
                                        </a>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <a href="#dev-b1" data-url="${pageContext.request.contextPath}/project/${project.projectId}/task" data-bs-toggle="tab" aria-expanded="false" class="nav-link" aria-selected="false" role="tab" tabindex="-1">
                                            <i class="ti ti-brand-github fs-18 me-md-1"></i>
                                            <span class="d-none d-md-inline-block">개발</span>
                                        </a>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <a href="#task-b1" data-url="/project/${project.projectId}/task" data-bs-toggle="tab" aria-expanded="false" class="nav-link active" aria-selected="true" role="tab">
                                            <i class="ti ti-list-check fs-18 me-md-1"></i>
                                            <span class="d-none d-md-inline-block">업무</span>
                                        </a>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <a href="#meet-b1" data-url="/project/${project.projectId}/meet" data-bs-toggle="tab" aria-expanded="false" class="nav-link" aria-selected="false" role="tab" tabindex="-1">
                                            <i class="ti ti-clipboard fs-18 me-md-1"></i>
                                            <span class="d-none d-md-inline-block">회의</span>
                                        </a>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <a href="#schedule-b1" data-url="/project/${project.projectId}/schedule" data-bs-toggle="tab" aria-expanded="false" class="nav-link" aria-selected="false" role="tab" tabindex="-1">
                                            <i class="ti ti-calendar-event fs-18 me-md-1"></i>
                                            <span class="d-none d-md-inline-block">일정</span>
                                        </a>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <a href="#file-b1" data-url="/project/${project.projectId}/file" data-bs-toggle="tab" aria-expanded="false" class="nav-link" aria-selected="false" role="tab" tabindex="-1">
                                            <i class="ti ti-folder fs-18 me-md-1"></i>
                                            <span class="d-none d-md-inline-block">파일</span>
                                        </a>
                                    </li>
                                </ul>

                                <div class="tab-content">
                                    <div class="tab-pane" id="main-b1" role="tabpanel">
										<!-- 메인탭 내용 -->
                                    </div>
                                    <div class="tab-pane" id="dev-b1" role="tabpanel">
                                        <!-- 개발탭 내용 -->
                                    </div>
                                    <div class="tab-pane active show" id="task-b1" role="tabpanel">
                                        
                                    </div>
                                    <div class="tab-pane" id="meet-b1" role="tabpanel">
                                        <!-- 회의탭 내용 -->
                                    </div>
                                    <div class="tab-pane" id="schedule-b1" role="tabpanel">
                                        <!-- 일정탭 내용 -->
                                    </div>
                                    <div class="tab-pane" id="file-b1" role="tabpanel">
                                        <!-- 파일탭 내용 -->
                                    </div>
                                </div>

                            </div> <!-- end card-body -->
                        </div> <!-- end card-->
                </div>
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
	
   	<script>
		$(function() {
		    // 첫 탭(업무) 자동 로드
		    loadTabData($("#task-b1"), "/project/${project.projectId}/task");
		    loadTabData($("#main-b1"), "/project/${project.projectId}/main");
		    
		    // 탭 클릭할 때만 AJAX 호출
		    $('a[data-bs-toggle="tab"]').on('shown.bs.tab', function(e) {
		        const targetId = $(e.target).attr("href");  // ex: #meet-b1
		        const url = $(e.target).data("url");        // ex: /project/{id}/meetings
		
		        if (url && $(targetId).is(':empty')) {
		        	loadTabData($(targetId), url + `?projectId=${project.projectId}`);
		        }
		    });
		
		    function loadTabData($container, url) {
		        $container.html("불러오는 중...");
		        $container.load(url, function(response, status, xhr) {
		            if (status === "error") {
		                $container.html("불러오기 실패");
		            }
		        });
		    }
		});
	</script>
</body>
</html>