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
  <title>지출결의서</title>
    <link rel="stylesheet" href="<c:url value='/static/css/approval.expense.css'/>">
	<link rel="stylesheet" href="<c:url value='/static/css/approval.expense.print.css'/>" media="print">
  <style>
    :root{ --line:#e5e7eb; --muted:#6b7280; --title:#111827; --paper:#fff; --bg:#f8fafc; }
    body{ margin:0; background:var(--bg); font-family:system-ui,-apple-system,Segoe UI,Roboto,Apple SD Gothic Neo,Noto Sans KR,sans-serif; }
    .page{ max-width:980px; margin:24px auto; background:var(--paper); box-shadow:0 10px 30px rgba(0,0,0,.06); border-radius:14px; overflow:hidden; }
    .hdr{ padding:24px 28px; border-bottom:1px solid var(--line); display:flex; align-items:center; justify-content:space-between; }
    .hdr h1{ margin:0; font-size:22px; }
    .meta{ font-size:13px; color:var(--muted); text-align:right; }
    .section{ padding:20px 28px; border-bottom:1px solid var(--line); }
    .grid{ display:grid; grid-template-columns:1fr 1fr; gap:14px 18px; }
    .grid-3{ display:grid; grid-template-columns:1fr 1fr 1fr; gap:12px 16px; }
    label{ font-size:12px; color:var(--muted); display:block; margin-bottom:6px; }
    input[type="text"], input[type="date"], select{ width:100%; box-sizing:border-box; border:1px solid var(--line); border-radius:8px; padding:10px 12px; font-size:14px; }
    .table-wrap{ overflow:auto; border:1px solid var(--line); border-radius:12px; }
    table{ width:100%; border-collapse:collapse; font-size:14px; }
    th, td{ border-bottom:1px solid var(--line); padding:10px; text-align:left; }
    thead th{ background:#f3f4f6; font-weight:600; }
    tfoot td{ background:#fafafa; font-weight:600; }
    .right{ text-align:right; }
    .btn{ display:inline-block; padding:10px 14px; border-radius:10px; border:1px solid var(--line); background:#fff; cursor:pointer; font-size:14px; }
    .btn.primary{ background:#111827; color:#fff; border-color:#111827; }
    .btn.destructive{ background:#fee2e2; border-color:#fecaca; color:#991b1b; }
    .hint{ color:#6b7280; font-size:12px; }
    @media print{ .no-print{ display:none !important; } .page{ box-shadow:none; border-radius:0; } body{ background:#fff; } }
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
                                <h4 class="header-title">지출결의서</h4>
                            </div>
						        <div class="ms-auto pe-2">작성일: <span id="metaDate"></span></div>
                                <div class="hdr">
						    </div>
                            <div class="card-body">
                                <p class="text-muted">
	                            	<!-- 부가 설명 -->
                                </p>
                                <div class="row">
                                    <div class="col-lg-12">
<c:choose>
  <c:when test="${editing}">
    <c:url var="formAction" value="/approval/expenses/${doc.approvalDocumentId}/edit"/>
  </c:when>
  <c:otherwise>
    <c:url var="formAction" value="/approval/expenses/new"/>
  </c:otherwise>
</c:choose>
 <form method="post" action="${formAction}"
      enctype="multipart/form-data"
      id="expenseForm"
      data-edit="${editing}"
      data-prev-date="${fn:escapeXml(JS_PREV_DATE)}"
      data-prev-amt="${JS_PREV_AMT}">
  <div class="page">


    <!-- 신청자 정보 -->
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
    </div>

    <!-- 지출 기본 정보 -->
    <div class="section">
      <div class="grid">
        <div>
          <label>지출 카테고리</label>
          <select id="expenseCategory" name="expenseId" required>
            <option value="">-- 선택 --</option>
            <c:forEach var="c" items="${codes}">
              <option value="${c.expenseId}"
                <c:if test="${editing and doc.expense.expenseId == c.expenseId}">selected</c:if>>
                <c:out value="${c.expenseTitle}"/>
              </option>
            </c:forEach>
          </select>
          <div class="hint">예: 복리후생/출장비/소모품비/회식비</div>
        </div>
        <div>
          <label>거래처명</label>
          <input type="text" id="vendor" name="vendor" placeholder="예: (주)샘플상사"
                 value="<c:out value='${editing ? doc.expense.vendor : ""}'/>">
        </div>
      </div>

      <div class="grid">
        <div>
          <label>지급방법</label>
          <select id="payMethod" name="payMethod">
            <c:set var="pm" value="${editing ? doc.expense.payMethod : ''}"/>
            <option value="CORP_CARD"     <c:if test="${pm=='CORP_CARD'}">selected</c:if>>법인카드</option>
            <option value="PERSONAL_CARD" <c:if test="${pm=='PERSONAL_CARD'}">selected</c:if>>개인카드</option>
            <option value="TRANSFER"      <c:if test="${pm=='TRANSFER'}">selected</c:if>>계좌이체</option>
            <option value="CASH"          <c:if test="${pm=='CASH'}">selected</c:if>>현금</option>
          </select>
        </div>
        <div>
          <label>계좌정보(필요 시)</label>
          <input type="text" id="bankInfo" name="bankInfo" placeholder="예: 우리 1002-***-**** (홍길동)"
                 value="<c:out value='${editing ? doc.expense.bankInfo : ""}'/>">
        </div>
      </div>
    </div>

    <div class="section">
      <div class="grid">
        <div>
          <label>사용목적</label>
          <input type="text" id="expenseReason" name="expenseReason" placeholder="사용목적을 적어주세요."
                 value="<c:out value='${editing ? doc.expense.expenseReason : ""}'/>">
        </div>
      </div>
    </div>

    <!-- 지출 상세(라인 입력) -->
    <div class="section">
      <div class="no-print" style="display:flex; justify-content:space-between; align-items:center;">
        <div class="hint">* 과세 10% 자동 계산 (저장은 총액/대표일만 전송)</div>
        <div>
          <button type="button" class="btn" id="addRowBtn">+ 행 추가</button>
          <button type="button" class="btn destructive" id="clearRowsBtn">행 모두 삭제</button>
        </div>
      </div>

      <div class="table-wrap" style="margin-top:10px;">
        <table id="itemTable">
          <thead>
            <tr>
              <th style="width:120px">사용일자</th>
              <th>내역(설명)</th>
              <th style="width:90px">과세</th>
              <th style="width:130px" class="right">공급가</th>
              <th style="width:120px" class="right">부가세</th>
              <th style="width:140px" class="right">합계</th>
              <th style="width:90px" class="no-print">삭제</th>
            </tr>
          </thead>
          <tbody></tbody>
          <tfoot>
            <tr>
              <td colspan="3" class="right">소계</td>
              <td class="right" id="sumSupply">0</td>
              <td class="right" id="sumVat">0</td>
              <td class="right" id="sumTotal">0</td>
              <td class="no-print"></td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>

    <!-- 첨부 / 서명 -->
    <div class="section">
      <div class="grid">
        <div>
          <label>증빙 첨부 (영수증/세금계산서 등)</label>
          <c:choose>
            <c:when test="${editing}">
              <c:if test="${not empty doc.files}">
                <div class="hint" style="margin-bottom:6px;">기존 첨부 파일</div>
                <c:forEach var="f" items="${doc.files}">
                  <div style="margin-bottom:6px;">
                    <label>
                      <input type="checkbox" name="deleteFileIds" value="${f.fileId}">
                      삭제
                    </label>
                    <a href="<c:url value='/approval/file/${f.fileId}/download'/>">
                      <c:out value="${f.originName}"/>
                    </a>
                    <span class="hint">(<fmt:formatNumber value='${f.size/1024}' maxFractionDigits='0'/> KB)</span>
                  </div>
                </c:forEach>
              </c:if>
              <!-- 추가 업로드 -->
              <input type="file" name="addFiles" id="fileInput" multiple
                     accept=".pdf,.jpg,.jpeg,.png,.heic,.heif,.webp,.xlsx,.xls,.hwp,.hwpx">
              <div class="hint" id="fileList"></div>
            </c:when>
            <c:otherwise>
              <input type="file" name="files" id="fileInput" multiple
                     accept=".pdf,.jpg,.jpeg,.png,.heic,.heif,.webp,.xlsx,.xls,.hwp,.hwpx">
              <div class="hint" id="fileList"></div>
            </c:otherwise>
          </c:choose>
        </div>
        <div>
          <label>전자결재 서명</label>
          <div class="hint no-print">← 전자서명 컴포넌트(API) 들어갈 자리</div>
        </div>
      </div>
    </div>

    <!-- 제출 -->
    <div class="section" style="display:flex; gap:8px; justify-content:flex-end;">
      <button type="button" class="btn" onclick="window.print()">인쇄/미리보기</button>
      <button type="submit" class="btn primary">제출</button>
    </div>
  </div>

  <!-- 서버 전송용 hidden -->
  <input type="hidden" name="title"        id="hiddenTitle">
  <input type="hidden" name="amount"       id="hiddenAmount">
  <input type="hidden" name="expenseDate"  id="hiddenExpenseDate">

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
   <script src="<c:url value='/js/expense.form.js'/>" defer></script>
</body>
</html>