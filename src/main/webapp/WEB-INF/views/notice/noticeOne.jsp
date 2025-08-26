<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
    <!-- Vendor css -->
    	<link href= "<c:url value='/HTML/Admin/dist/assets/css/vendor.min.css'/>" rel="stylesheet" type="text/css" />
    <!-- App css -->
   		<link href= "<c:url value='/HTML/Admin/dist/assets/css/app.min.css'/>"  rel="stylesheet" type="text/css" id="app-style" />
    <!-- Icons css -->
   	 	<link href= "<c:url value='/HTML/Admin/dist/assets/css/icons.min.css'/>" rel="stylesheet" type="text/css" />
   	 	
  	<script src="/HTML/Admin/dist/assets/vendor/jquery/jquery.min.js"></script>
   	<script src="/HTML/Admin/dist/assets/vendor/bootstrap/bootstrap.bundle.min.js"></script>
   	<script type="text/javascript" src="https://cdn.datatables.net/v/bs4/dt-1.11.3/datatables.min.js"></script>
   	
   	  <!-- ★ added: 첫/마지막 요소 기본 마진 제거 (본문 박스 안에서만) -->
  <style>
    .notice-body > *:first-child { margin-top: 0 !important; }
    .notice-body > *:last-child  { margin-bottom: 0 !important; }
  </style>
</head>
<body>
 
<div class="page-content">
  <div class="page-container">
    <div class="row">
      <div class="col-12">

        <div class="card">
          <div class="card-body">
            <!-- 상단: 로고/제목/상태 -->
            <div class="d-flex align-items-start justify-content-between mb-4">
              <div>
                <img src="<c:url value='/HTML/Admin/dist/assets/images/logo-dark.png'/>" alt="logo" height="24">
              </div>
			  <div>
                <h3 class="m-0 fw-bolder fs-20">
                  <c:out value="${notice.noticeTitle}"/>
                </h3>
			  </div>
              <div class="text-end">
                <c:if test="${notice.isPin == 1}">
                  <span class="badge bg-danger-subtle text-danger px-1 fs-12 mb-2">PIN</span>
                </c:if>
              </div>
            </div>

            <!-- 작성 정보 -->
            <div class="row">
              <div class="col-4">
                <div class="mb-3">
                  <h5 class="fw-bold pb-1 mb-2 fs-14">작성자</h5>
                  <h6 class="fs-14 mb-0"><c:out value="${notice.writerId}"/></h6>
                </div>
                <div>
                  <h5 class="fw-bold fs-14">작성일</h5>
                  <h6 class="fs-14 text-muted mb-0"><c:out value="${notice.createdAt}"/></h6>
                </div>
              </div>

              <div class="col-4">
                <div class="mb-3">
                  <h5 class="fw-bold pb-1 mb-2 fs-14">조회수</h5>
                  <h6 class="fs-14 text-muted mb-0"><c:out value="${notice.noticeViewCount}"/></h6>
                </div>
                <c:if test="${notice.updatedAt != null}">
                  <div>
                    <h5 class="fw-bold fs-14">수정일</h5>
                    <h6 class="fs-14 text-muted mb-0"><c:out value="${notice.updatedAt}"/></h6>
                  </div>
                </c:if>
              </div>

            </div>
          </div>

          <!-- 본문 내용 -->
          <div class="mt-3 px-3 pb-3">
            <div class="bg-body p-3 rounded-2 notice-body">
              <!-- ★ changed: pre-wrap → pre-line, trim + c:out -->
              <div class="fs-14" style="white-space: pre-line;">
                <c:out value="${fn:trim(notice.noticeContent)}"/>
              </div>
            </div>
          </div>

          <!-- 첨부파일 영역 (인보이스의 품목 테이블 자리에 매핑) -->
          <c:if test="${not empty files}">
            <div class="mt-3 px-3">
              <h5 class="fw-bold fs-14 mb-2">첨부파일</h5>
              <div class="table-responsive">
                <table class="table table-nowrap align-middle mb-0">
                  <thead>
                  <tr class="bg-light bg-opacity-50">
                    <th class="border-0" style="width:60px;">#</th>
                    <th class="text-start border-0">파일명</th>
                    <th class="text-end border-0" style="width:160px;">다운로드</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:forEach var="f" items="${files}" varStatus="st">
                    <tr>
                      <th scope="row"><c:out value="${st.index + 1}"/></th>
                      <td class="text-start">
                        <span class="fw-medium"><c:out value="${f.fileOriginName}"/></span>
                      </td>
                      <td class="text-end">
                        <a class="btn btn-soft-info btn-sm"
                           href="<c:url value='/notice/file/download'/>/${f.fileId}">
                          <i class="ti ti-download me-1"></i> 받기
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                  </tbody>
                </table>
              </div>
            </div>
          </c:if>

        </div>

        <!-- 하단 버튼 영역 (인쇄/수정/삭제/목록) -->
        <div class="d-print-none mb-5">
          <div class="d-flex justify-content-center gap-2">
            <a href="javascript:window.print()" class="btn btn-primary">
              <i class="ti ti-printer me-1"></i> PDF로 저장
            </a>
			<c:if test="${canManage}">
	            <a href="<c:url value='/notice/edit'/>?noticeId=${notice.noticeId}" class="btn btn-secondary">
	              <i class="ti ti-edit me-1"></i> 수정
	            </a>
	
	            <form method="post" action="<c:url value='/notice/remove'/>" class="d-inline">
	              <input type="hidden" name="noticeId" value="${notice.noticeId}"/>
	              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	              <button type="submit" class="btn btn-danger"
	                      onclick="return confirm('삭제하시겠습니까?');">
	                <i class="ti ti-trash me-1"></i> 삭제
	              </button>
	            </form>
			</c:if>
            <a href="<c:url value='/notice/list'/>" class="btn btn-info">
              <i class="ti ti-list me-1"></i> 목록
            </a>
          </div>
        </div>

      </div>
    </div>
  </div><!-- /page-container -->
</div><!-- /page-content -->
</body>
</html>