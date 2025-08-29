<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<!-- CSS -->
	<jsp:include page ="../../views/nav/head-css.jsp"></jsp:include>	
  <meta charset="UTF-8">
  <title>휴가신청서</title>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <style>
    :root{ --line:#e5e7eb; --muted:#6b7280; --paper:#fff; --bg:#f8fafc; }
    body{ margin:0; background:var(--bg); font-family:system-ui,-apple-system,Segoe UI,Roboto,Apple SD Gothic Neo,Noto Sans KR,sans-serif; }
    .page{ max-width:980px; margin:24px auto; background:var(--paper); box-shadow:0 10px 30px rgba(0,0,0,.06); border-radius:14px; overflow:hidden; }
    .hdr{ padding:24px 28px; border-bottom:1px solid var(--line); display:flex; align-items:center; justify-content:space-between; }
    .hdr h1{ margin:0; font-size:22px; }
    .meta{ font-size:13px; color:var(--muted); text-align:right; }
    .section{ padding:20px 28px; border-bottom:1px solid var(--line); }
    .grid{ display:grid; grid-template-columns:1fr 1fr; gap:14px 18px; }
    .grid-3{ display:grid; grid-template-columns:1fr 1fr 1fr; gap:12px 16px; }
    label{ font-size:12px; color:var(--muted); display:block; margin:0 0 6px; }
    input[type="text"], input[type="date"], select, textarea{
      width:100%; box-sizing:border-box; border:1px solid var(--line); border-radius:8px; padding:10px 12px; font-size:14px; outline:none;
    }
    .inline{ display:flex; gap:10px; align-items:center; }
    .badge{ display:inline-block; padding:2px 8px; background:#ecfeff; color:#155e75; border:1px solid #a5f3fc; border-radius:999px; font-size:12px; }
    .hint{ color:var(--muted); font-size:12px; }
    .sigpad{ padding:12px; border:1px dashed #cbd5e1; border-radius:10px; background:#f8fafc; color:#475569; font-size:13px; }
    .btn{ display:inline-block; padding:10px 14px; border-radius:10px; border:1px solid var(--line); background:#fff; cursor:pointer; font-size:14px; }
    .btn.primary{ background:#111827; color:#fff; border-color:#111827; }
    @media print{ .no-print{ display:none !important; } .page{ box-shadow:none; border-radius:0; } body{ background:#fff; } }
    .grid-3-eq{
	  display:grid; grid-template-columns:1fr 1fr 1fr; gap:14px 18px; align-items:end;
	}
	.toggle-group{ display:flex; gap:10px; align-items:center; flex-wrap:wrap; }
	.chk{
	  display:inline-flex; gap:6px; align-items:center;
	  padding:6px 10px; border:1px solid var(--line); border-radius:8px; background:#fff; font-size:14px;
	}
	.chk input{ width:16px; height:16px; }
	.half-row{ display:flex; gap:12px; align-items:center; margin-top:8px; }
	.toggle-group{ display:flex; gap:10px; align-items:center; flex-wrap:wrap; }
	.chk{
	  display:inline-flex; gap:6px; align-items:center;
	  padding:6px 10px; border:1px solid var(--line);
	  border-radius:8px; background:#fff; font-size:14px;
	}
	.chk input{ width:16px; height:16px; }
  </style>
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
                                <h4 class="header-title">휴가신청서</h4>
                            </div>
                                <div class="ms-auto pe-2">작성일: <span id="metaDate"></span></div>
                            <div class="card-body">
                                <p class="text-muted">
	                            	<!-- 부가 설명 -->
                                </p>
                                <div class="row">
                                    <div class="col-lg-12">
<c:choose>
  <c:when test="${editing}">
    <c:url var="formAction" value="/approval/vacations/${doc.approvalDocumentId}/edit"/>
  </c:when>
  <c:otherwise>
    <c:url var="formAction" value="/approval/vacations/new"/>
  </c:otherwise>
</c:choose>

<form method="post" action="${formAction}" enctype="multipart/form-data" id="vacationForm">
<!--  
<form method="post" action="<c:url value='/approval/vacations/new'/>" enctype="multipart/form-data" id="vacationForm">
-->
  <div class="page">
    <!-- 신청자 / 잔여연차 -->
    <div class="section">
      <div class="grid-3">
        <div>
          <label>사번</label>
          <input type="text" value="${empId}" disabled />
        </div>
        <div>
          <label>부서</label>
          <input type="text" value="<c:out value='${empty org.deptName ? "-" : org.deptName}'/>" disabled />
        </div>
        <div>
          <label>팀</label>
          <input type="text" value="<c:out value='${empty org.teamName ? "-" : org.teamName}'/>" disabled />
        </div>
      </div>
      <div class="hint" style="margin-top:8px;">
        잔여연차: <strong><c:out value="${annualLeave}"/> 일</strong>
      </div>
    </div>

    <!-- 휴가 기본 정보 -->
    <div class="section">
      <div class="grid">
        <div>
          <label>휴가 구분</label>
          <select name="vacationId" id="vacationCategory" required>
            <option value="">-- 선택 --</option>
            <c:forEach var="c" items="${codes}">
              <c:set var="codeId">
                <c:choose>
                  <c:when test="${not empty c.vacationId}">${c.vacationId}</c:when>
                  <c:when test="${not empty c.id}">${c.id}</c:when>
                  <c:otherwise>${c[0]}</c:otherwise>
                </c:choose>
              </c:set>
              <c:set var="codeTitle">
                <c:choose>
                  <c:when test="${not empty c.vacationTitle}">${c.vacationTitle}</c:when>
                  <c:when test="${not empty c.title}">${c.title}</c:when>
                  <c:otherwise>${c[1]}</c:otherwise>
                </c:choose>
              </c:set>
				<c:set var="selId" value="${editing ? doc.vacation.vacationId : pre_vacationId}"/>
				<option value="${fn:trim(codeId)}"
				  <c:set var="codeIdInt" value="${codeId + 0}"/>
				  <c:if test="${selId == codeIdInt}">selected</c:if>>
				  ${fn:trim(codeTitle)}
				</option>
            </c:forEach>
          </select>
          <div class="hint">예: 예비군/경조사/질병/연차/반차</div>
        </div>
        <div>
          <label>비상연락처</label>
          <input type="text" id="emergency" name="emergencyContact" placeholder="예: 010-1234-5678" 
           value="<c:out value='${editing ? doc.vacation.emergencyContact : pre_emergencyContact}'/>">
        </div>
      </div>

		<div class="grid">
		  <div>
		    <label>시작일</label>
		    <div class="inline">
		      <input type="date" name="startDate" id="startDate" value="${editing ? doc.vacation.startDate : pre_startDate}" required>
		    </div>
		  </div>
		  <div>
		    <label>종료일</label>
		    <div class="inline">
		      <input type="date" name="endDate" id="endDate" value="${editing ? doc.vacation.endDate : pre_endDate}" required>
		    </div>
		  </div>
		</div>
		
		<!-- 날짜 선택 “아래”에 반차 옵션 한 줄 배치 -->
		<div class="half-row">
		  <!-- 같은 날일 때만 쓰는 반차 -->
		  <label class="chk" id="halfDayWrap">
		    <input type="checkbox" id="halfDay" disabled> 반차
		  </label>
		
		  <!-- 기간일 때 쓰는 시작/종료 반차 -->
		  <div class="toggle-group" id="rangeHalfs" style="display:none;">
		    <label class="chk"><input type="checkbox" id="startHalf" disabled> 시작 반차</label>
		    <label class="chk"><input type="checkbox" id="endHalf" disabled> 종료 반차</label>
		  </div>
		</div>

      <div class="grid">
        <div>
          <label>업무 인수인계(담당자/범위)</label>
          <input type="text" id="handover" name="handover" placeholder="예: 김PM에게 개발작업 진행 인수"
           value="<c:out value='${editing ? doc.vacation.handover : pre_handover}'/>">
        </div>
      </div>

      <div>
        <label>사유(요약)</label>
        <textarea id="reasonText" name="vacationReason" placeholder="예: 가족 경조사 참석 / 건강검진 등" >
        <c:out value="${editing ? doc.vacation.vacationReason : pre_vacationReason}"/></textarea>
      </div>
    </div>

    <!-- 첨부/서명 -->
    <div class="section">
      <div class="grid">
        <div>
          <label>첨부 (진단서/청첩장/소명자료 등)</label>
			<c:choose>
			  <c:when test="${editing}">
			    <c:if test="${not empty doc.files}">
			      <div class="hint" style="margin-bottom:6px;">기존 첨부 파일</div>
			      <c:forEach var="f" items="${doc.files}">
			        <div style="margin-bottom:6px;">
			          <label><input type="checkbox" name="deleteFileIds" value="${f.fileId}"> 삭제</label>
			          <a href="<c:url value='/approval/file/${f.fileId}/download'/>">
			            <c:out value="${f.originName}"/>
			          </a>
			          <span class="hint">(<fmt:formatNumber value='${f.size/1024}' maxFractionDigits='0'/> KB)</span>
			        </div>
			      </c:forEach>
			    </c:if>
			    <!-- 수정: 추가 업로드 -->
			    <input type="file" name="addFiles" id="uploadInput" multiple
			           accept=".pdf,.jpg,.jpeg,.png,.heic,.heif,.webp">
			    <div class="hint" id="fileList"></div>
			  </c:when>
			  <c:otherwise>
			    <!-- 신규 -->
			    <input type="file" name="files" id="uploadInput" multiple
			           accept=".pdf,.jpg,.jpeg,.png,.heic,.heif,.webp">
			    <div class="hint" id="fileList"></div>
			  </c:otherwise>
			</c:choose>
        </div>
        
        <div>
          <label>전자결재 서명</label>
          <div class="sigpad no-print">
            TODO: 전자서명 위젯(API) 삽입 위치<br/>
            - 도장 이미지 업로드 또는 마우스 서명 캔버스
          </div>
        </div>
      </div>
    </div>

    <!-- 제출 -->
    <div class="section" style="display:flex; gap:8px; justify-content:flex-end;">
      <div class="hint" style="margin-right:auto;">계산된 사용일수: <strong id="calcDays">0</strong> 일</div>
      <button type="button" class="btn" onclick="window.print()">인쇄/미리보기</button>
      <button type="submit" class="btn primary">제출</button>
    </div>
  </div>

  <!-- 서버 요구 파라미터(숨김) -->
  <input type="hidden" name="title"  id="hiddenTitle">
  <input type="hidden" name="reason" id="hiddenReason">
  <input type="hidden" name="totalDays" id="hiddenTotalDays">

  <c:if test="${not empty _csrf}">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
  </c:if>
</form>
       	<a class="btn" href="/approval">홈으로</a>
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
   <!-- 이 페이지 전용 -->
   <script src="<c:url value='/js/vacation.form.js'/>" defer></script>
</body>
</html>