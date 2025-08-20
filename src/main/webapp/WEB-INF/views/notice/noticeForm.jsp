<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
  	<title><c:out value="${mode=='edit' ? '공지 수정' : '공지 작성'}"/></title>
      <!-- Vendor css -->
    	<link href= "<c:url value='/HTML/Admin/dist/assets/css/vendor.min.css'/>" rel="stylesheet" type="text/css" />
    <!-- App css -->
   		<link href= "<c:url value='/HTML/Admin/dist/assets/css/app.min.css'/>"  rel="stylesheet" type="text/css" id="app-style" />
    <!-- Icons css -->
   	 	<link href= "<c:url value='/HTML/Admin/dist/assets/css/icons.min.css'/>" rel="stylesheet" type="text/css" />
   	 	
  	<script src="/HTML/Admin/dist/assets/vendor/jquery/jquery.min.js"></script>
   	<script src="/HTML/Admin/dist/assets/vendor/bootstrap/bootstrap.bundle.min.js"></script>
   	<script type="text/javascript" src="https://cdn.datatables.net/v/bs4/dt-1.11.3/datatables.min.js"></script>
   	
  <style>
    /* 제목/내용 간격, 내용 에디터 크게 */
    .editor-title  { max-width: 100%; }
    .editor-body   { min-height: 360px; resize: vertical; }  /* 필요 시 더 키워도 됨 */
    .label-col     { white-space: nowrap; }
  </style>
</head>
<body>

<div class="page-content">
  <div class="page-container">

    <div class="row">
      <div class="col-12">
        <div class="card position-relative">

          <!-- ========== 메인 저장 폼 (공지 작성/수정) ========== -->
          <form method="post" enctype="multipart/form-data"
                action="<c:url value='${mode == "edit" ? "/notice/edit" : "/notice/add"}'/>">

            <!-- 수정 모드일 때만 PK 전달 -->
            <c:if test="${mode == 'edit'}">
              <input type="hidden" name="noticeId" value="${notice.noticeId}"/>
            </c:if>

            <!-- CSRF -->
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="card-body">
              <!-- 상단 로고/제목 -->
              <div class="d-flex align-items-start justify-content-between mb-4">
                <div class="overflow-hidden position-relative border rounded d-flex align-items-center justify-content-start px-2"
                     style="height: 60px; width: 260px;">
                  <img id="preview" src="<c:url value='/HTML/Admin/dist/assets/images/logo-dark.png'/>" alt="logo" height="28">
                </div>
                
                <!-- 제목: 가로 넓게 -->
                <div class="col-12 col-lg-7">
                  <div class="row g-2 align-items-center">
                    <div class="col-auto label-col">
                      <label for="noticeTitle" class="col-form-label fs-16 fw-bold mb-0">제목</label>
                    </div>
                    <div class="col">
                      <input type="text" id="noticeTitle" name="noticeTitle"
                             class="form-control form-control-lg editor-title"
                             placeholder="제목을 입력하세요"
                             value="<c:out value='${notice.noticeTitle}'/>" required>
                    </div>
                  </div>
                </div>

                <div class="text-end">
                  <div class="mb-2">
                    <label class="form-label"></label>
                    <div class="form-check">
                      <input type="checkbox" class="form-check-input" id="pinCheck"
                             <c:if test="${notice.isPin == 1}">checked</c:if>>
                      <label class="form-check-label" for="pinCheck">긴급</label>
                      <input type="hidden" name="isPin" id="isPinHidden"
                             value="<c:out value='${notice.isPin==1 ? 1 : 0}'/>">
                    </div>
                  </div>
                
                </div>
              </div>


              <!-- 내용: 한 줄 전체로 크게 -->
              <div class="mb-4">
                <label class="form-label fw-bold">내용</label>
                <textarea name="noticeContent"
                          class="form-control editor-body"
                          placeholder="내용을 입력하세요"
                          required  
                          style="min-height:200px; font-size:15px; line-height:1.6;"><c:out value='${notice.noticeContent}'/></textarea>
              </div>

                <!-- 우: 조회수/수정일 -->
                <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6 mt-sm-0 mt-3">
                  <c:if test="${notice.updatedAt != null}">
                    <div class="mb-2">
                      <label class="form-label">수정일</label>
                    </div>
                  </c:if>
                </div>
              </div>

              <!-- 파일 업로드 (새 파일 첨부) -->
              <div class="mt-4">
                <div class="table-responsive">
                  <table class="table text-center table-nowrap align-middle mb-0">
                    <thead>
                      <tr class="bg-light bg-opacity-50">
                        <th scope="col" class="border-0" style="width:70px;">#</th>
                        <th scope="col" class="border-0 text-start">첨부파일</th>
                        <th scope="col" class="border-0" style="width:240px;">업로드</th>
                        <th scope="col" class="border-0" style="width:50px;">&nbsp;</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <th scope="row">01</th>
                        <td class="text-start">파일 선택(여러 개 가능)</td>
                        <td><input type="file" name="files" class="form-control" multiple></td>
                        <td></td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>

            <!-- 하단 버튼 -->
            <div class="mb-5">
              <div class="d-flex justify-content-center gap-2">
                <button type="submit" class="btn btn-success gap-1">
                  <i class="ti ti-device-floppy fs-16"></i> 저장
                </button>
                <a href="<c:url value='/notice/list'/>" class="btn btn-info gap-1">
                  <i class="ti ti-list fs-16"></i> 목록
                </a>
              </div>
            </div>
          </form>
          <!-- ========== 메인 저장 폼 끝 ========== -->

          <!-- ========== 기존 첨부 목록 (개별 삭제: 메인 폼 '밖') ========== -->
          <c:if test="${not empty files}">
            <div class="px-3 pb-4">
              <h5 class="fw-bold fs-14 mb-2">기존 첨부파일</h5>
              <div class="table-responsive">
                <table class="table table-sm table-borderless table-nowrap align-middle mb-0">
                  <tbody>
                  <c:forEach var="f" items="${files}" varStatus="st">
                    <tr>
                      <td class="fw-medium" style="width:60px;"><c:out value="${st.index+1}"/></td>
                      <td class="text-start">
                        <a href="<c:url value='/notice/file/download'/>/${f.fileId}">
                          <c:out value='${f.fileOriginName}'/>
                        </a>
                      </td>
                      <td class="text-end" style="width:120px;">
                        <!-- 독립 삭제 폼 (중첩 금지) -->
                        <form method="post" action="<c:url value='/notice/file/remove'/>" class="d-inline">
                          <input type="hidden" name="fileId" value="${f.fileId}"/>
                          <input type="hidden" name="noticeId" value="${notice.noticeId}"/>
                          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                          <button type="submit" class="btn btn-soft-danger btn-sm"
                                  onclick="return confirm('이 첨부파일을 삭제할까요?');">삭제</button>
                        </form>
                      </td>
                    </tr>
                  </c:forEach>
                  </tbody>
                </table>
              </div>
            </div>
          </c:if>
          <!-- ========== 기존 첨부 목록 끝 ========== -->

        </div><!-- /card -->
      </div>
    </div>

  </div><!-- /page-container -->
</div><!-- /page-content -->

<script>
  // PIN 체크 ↔ hidden 동기화
  (function(){
    var pin = document.getElementById('pinCheck');
    var hid = document.getElementById('isPinHidden');
    if(pin && hid){
      pin.addEventListener('change', function(){
        hid.value = pin.checked ? '1' : '0';
      });
    }
  })();
</script>

</body>
</html>