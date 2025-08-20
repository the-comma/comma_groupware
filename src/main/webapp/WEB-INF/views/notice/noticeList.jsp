<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
   	 	<link rel="stylesheet" href="https://cdn.datatables.net/v/bs4/dt-1.11.3/datatables.min.css"/>
   	 	
  	<script src="/HTML/Admin/dist/assets/vendor/jquery/jquery.min.js"></script>
   	<script src="/HTML/Admin/dist/assets/vendor/bootstrap/bootstrap.bundle.min.js"></script>
   	<script type="text/javascript" src="https://cdn.datatables.net/v/bs4/dt-1.11.3/datatables.min.js"></script>
</head>
<body>
<div class="page-content">
  <div class="page-container">

    <div class="row">
      <div class="col-12">
        <div class="card">

          <!-- 카드 헤더: 제목 + 글쓰기 버튼 (템플릿 클래스 유지) -->
          <div class="card-header border-bottom justify-content-between d-flex flex-wrap align-items-center gap-2">
            <h4 class="mb-0">
        	    <a href="<c:url value='/notice/list'/>" class="text-reset text-decoration-none">
    				공지사항
  				</a>
  			</h4>
                <c:if test="${canWrite}">
            <a href="<c:url value='/notice/add'/>" class="btn btn-primary">
                	<i class="ti ti-plus me-1"></i>글쓰기
            </a>
                </c:if>
          </div>

          <!-- 검색바 (템플릿의 검색 인풋 스타일 차용) -->
          <div class="card-body pb-0">
            <form method="get" action="<c:url value='/notice/list'/>" class="d-flex gap-2">
              <div class="position-relative" style="max-width:320px;">
                <input type="text" name="keyword" value="${keyword}" class="form-control bg-light bg-opacity-50 border-0 ps-4" placeholder="제목/내용 검색">
                <i class="ti ti-search position-absolute top-50 translate-middle-y start-0 ms-2"></i>
              </div>
              <button type="submit" class="btn btn-outline-secondary">검색</button>
            </form>
          </div>

          <!-- 테이블 (템플릿 클래스/구조 유지) -->
          <div class="table-responsive">
            <table class="table table-hover text-nowrap mb-0">
              <thead class="bg-light-subtle">
              <tr>
                <th class="ps-3 py-1" style="width:70px;">긴급</th>
                <th class="fs-12 text-uppercase text-muted py-1">제목</th>
                <th class="fs-12 text-uppercase text-muted py-1" style="width:120px;">첨부</th>
                <th class="fs-12 text-uppercase text-muted py-1" style="width:100px;">조회수</th>
                <th class="fs-12 text-uppercase text-muted py-1" style="width:140px;">작성일</th>
              </tr>
              </thead>

              <tbody>
              <c:forEach var="n" items="${data.list}">
                <tr>
                  <td class="ps-3">
                    <c:if test="${n.isPin == 1}">
                      <span class="badge bg-danger-subtle text-danger">PIN</span>
                    </c:if>
                  </td>

                  <td>
                    <span class="fw-semibold">
                      <a href="<c:url value='/notice/one'/>?noticeId=${n.noticeId}" class="text-reset">
                        <c:out value="${n.noticeTitle}"/>
                      </a>
                    </span>
                  </td>

                  <td>
                    <c:choose>
                      <c:when test="${n.isFile == 1}">
                        <a href="<c:url value='/notice/file/download-all'/>?noticeId=${n.noticeId}">📦 전체</a>
                        <c:if test="${n.fileCount > 0}">(${n.fileCount})</c:if>
                      </c:when>
                      <c:otherwise>-</c:otherwise>
                    </c:choose>
                  </td>

                  <td>${n.noticeViewCount}</td>
                  <td><span class="text-muted">${n.createdAt}</span></td>

                </tr>
              </c:forEach>

              <c:if test="${empty data.list}">
                <tr>
                  <td colspan="6" class="text-center text-muted py-4">등록된 공지사항이 없습니다.</td>
                </tr>
              </c:if>
              </tbody>
            </table>
          </div>

          <!-- 페이지네이션 (템플릿 pagination 스타일 유지) -->
          <c:if test="${data.totalPages > 1}">
            <div class="card-footer">
              <div class="d-flex justify-content-end">
                <ul class="pagination mb-0 justify-content-center">
                  <li class="page-item ${data.page == 1 ? 'disabled' : ''}">
                    <a class="page-link"
                       href="<c:url value='/notice/list'/>?page=${data.page-1}&pageSize=${data.pageSize}&keyword=${keyword}">
                      <i class="ti ti-chevrons-left"></i>
                    </a>
                  </li>

                  <c:forEach begin="1" end="${data.totalPages}" var="i">
                    <li class="page-item ${i == data.page ? 'active' : ''}">
                      <a class="page-link"
                         href="<c:url value='/notice/list'/>?page=${i}&pageSize=${data.pageSize}&keyword=${keyword}">${i}</a>
                    </li>
                  </c:forEach>

                  <li class="page-item ${data.page == data.totalPages ? 'disabled' : ''}">
                    <a class="page-link"
                       href="<c:url value='/notice/list'/>?page=${data.page+1}&pageSize=${data.pageSize}&keyword=${keyword}">
                      <i class="ti ti-chevrons-right"></i>
                    </a>
                  </li>
                </ul>
              </div>
            </div>
          </c:if>

        </div><!-- end card -->
      </div>
    </div>

  </div><!-- end page-container -->
</div><!-- end page-content -->
</body>
</html>