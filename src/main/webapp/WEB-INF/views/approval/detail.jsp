<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <jsp:include page ="../../views/nav/head-css.jsp"></jsp:include>
  <meta charset="UTF-8"/>
  <title>결재문서 상세</title>

  <style>
    :root{
      --app-header-h: 72px;   /* JS가 실제 헤더 높이로 덮어씀 */
      --paper:#fff; --bg:#f5f7fb; --ink:#111827; --muted:#6b7280; --line:#e5e7eb; --title:#0f172a; --brand:#111827;
    }

    body{ margin:0; background:var(--bg);
      font-family:system-ui,-apple-system,Segoe UI,Roboto,Apple SD Gothic Neo,Noto Sans KR,sans-serif; }

    /* 문서 컨테이너 */
    @page { size: A4; margin: 15mm; }
    .page { margin: calc(12px + var(--app-header-h)) auto 48px; max-width:980px;
            background:#fff; border-radius:12px; box-shadow:0 10px 30px rgba(0,0,0,.06); }
    .doc  { padding:24px; }

    /* 액션바(이제 고정 아님, 문서 상단에 자연스럽게 위치) */
    .doc-actions{
      display:flex; gap:8px; align-items:center;
      padding:0 0 14px 0; margin-bottom:14px;
      border-bottom:1px solid var(--line);
    }
    .doc-actions .spacer{ margin-right:auto; color:#6b7280; font-size:14px; }

    .btn{
      display:inline-flex; align-items:center; gap:6px; padding:9px 14px; border-radius:10px;
      border:1px solid var(--line); background:#fff; color:#111827; text-decoration:none; cursor:pointer; font-size:14px;
    }
    .btn.primary{ background:var(--brand); color:#fff; border-color:var(--brand); }
    .btn.danger{ background:#fee2e2; color:#991b1b; border-color:#fecaca; }
    .btn.success{ background:#e8fff3; color:#05603a; border-color:#bbf7d0; }

    /* 상단 타이틀 + 우측 결재패널 — 같은 높이로 정렬 */
    .title-row {
      display:grid;
      grid-template-columns:1fr 360px;
      gap:16px;
      align-items: stretch;    /* 좌/우 동일 높이 */
    }
    .brand-title,
    .approval-panel{ height:100%; }

    .brand-title { border:2px solid #111827; border-radius:10px; padding:14px 16px; }
    .brand-title .company { font-weight:700; font-size:18px; letter-spacing:.3px; }
    .brand-title .docname { font-size:22px; font-weight:800; margin-top:4px; }
    .brand-title .meta   { margin-top:8px; color:#6b7280; font-size:12px; line-height:1.6; }

    .approval-panel { border:1.5px solid #111827; border-radius:10px; overflow:hidden; }
    .approval-panel table { width:100%; border-collapse:collapse; table-layout:fixed; height:100%; }
    .approval-panel th, .approval-panel td {
      border:1px solid #111827; padding:8px; text-align:center; font-size:13px;
    }
    .approval-panel thead th { background:#f3f4f6; font-weight:700; }
    .sign-space { height:90px; }
    .small { color:#6b7280; font-size:12px; }

    /* 본문 섹션 */
    .form-section { margin-top:18px; border:1px solid var(--line); border-radius:12px; overflow:hidden; }
    .form-section .h { background:#f8fafc; padding:10px 12px; font-weight:700; border-bottom:1px solid var(--line); }
    .form-section .b { padding:12px; }
    .kv-row { display:grid; grid-template-columns:160px 1fr; gap:10px; align-items:center; padding:8px 0; }
    .kv-key { color:#6b7280; font-size:13px; }
    .kv-val { font-size:14px; border-bottom:1px dashed #cbd5e1; padding-bottom:2px; white-space:pre-wrap; }

    /* 지출 라인아이템 */
    .table-wrap{ overflow:auto; border:1px solid var(--line); border-radius:12px; }
    table{ width:100%; border-collapse:collapse; font-size:14px; }
    th, td{ border-bottom:1px solid var(--line); padding:10px; text-align:left; }
    thead th{ background:#f3f4f6; font-weight:600; }
    tfoot td{ background:#fafafa; font-weight:600; }
    .right{ text-align:right; }

    @media print{
      .wrapper > .sidebar, .wrapper > .header, .no-print{ display:none !important; }
      .page{ margin:0; border-radius:0; box-shadow:none; }
      .doc{ padding:0; }
      .doc-actions{ display:none; }
    }
  </style>
</head>
<body>
<div class="wrapper">

  <jsp:include page ="../../views/nav/sidenav.jsp"></jsp:include>
  <jsp:include page ="../../views/nav/header.jsp"></jsp:include>

  <!-- 헤더 실제 높이에 맞춰 상단 여백 보정 -->
  <script>
    (function(){
      const header = document.querySelector('.app-header, .header, header, .topbar, .navbar');
      function updateH(){
        if (header) {
          const h = Math.ceil(header.getBoundingClientRect().height || 72);
          document.documentElement.style.setProperty('--app-header-h', h + 'px');
        }
      }
      updateH();
      window.addEventListener('resize', updateH);
      setTimeout(updateH, 0);
      setTimeout(updateH, 250);
    })();
  </script>

  <div class="page">
    <div class="doc">

      <!-- 액션 영역 (이제 고정 아님, 문서 상단 자연 배치) -->
      <div class="doc-actions">
        <div class="spacer">문서번호 #<c:out value="${doc.approvalDocumentId}"/></div>

        <c:if test="${canEdit}">
          <c:choose>
            <c:when test="${doc.documentType == 'VACATION'}">
              <a class="btn" href="<c:url value='/approval/vacations/${doc.approvalDocumentId}/edit'/>">수정</a>
            </c:when>
            <c:otherwise>
              <a class="btn" href="<c:url value='/approval/expenses/${doc.approvalDocumentId}/edit'/>">수정</a>
            </c:otherwise>
          </c:choose>

          <form method="post" action="<c:url value='/approval/doc/${doc.approvalDocumentId}/delete'/>"
                onsubmit="return confirm('정말 삭제할까요? 삭제 후 복구할 수 없습니다.');" style="display:inline;">
            <c:if test="${not empty _csrf}">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>
            <button type="submit" class="btn danger">삭제</button>
          </form>
        </c:if>

        <a class="btn" href="<c:url value='/approval/doc/${doc.approvalDocumentId}/download'/>">PDF 다운로드</a>

        <c:if test="${not empty myLine}">
          <form method="post" action="<c:url value='/approval/line/${myLine.approvalLineId}/approve'/>" style="display:inline;">
            <c:if test="${not empty _csrf}">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>
            <button class="btn success">승인</button>
          </form>
          <form method="post" action="<c:url value='/approval/line/${myLine.approvalLineId}/reject'/>" style="display:inline;">
            <c:if test="${not empty _csrf}">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>
            <input type="text" name="reason" placeholder="반려 사유" required
                   style="border:1px solid var(--line); border-radius:8px; padding:8px 10px; margin-right:6px;">
            <button class="btn danger">반려</button>
          </form>
        </c:if>
      </div>

      <!-- 결재선에서 1차/2차 정보 추출 -->
      <c:set var="step1Name" value=""/>
      <c:set var="step1EmpId" value=""/>
      <c:set var="step1Status" value=""/>
      <c:set var="step1DecidedAt" value=""/>
      <c:set var="step2Name" value=""/>
      <c:set var="step2EmpId" value=""/>
      <c:set var="step2Status" value=""/>
      <c:set var="step2DecidedAt" value=""/>

      <c:forEach var="l" items="${doc.lines}">
        <c:if test="${l.step == 1}">
          <c:set var="step1Name" value="${l.approverName}"/>
          <c:set var="step1EmpId" value="${l.approverEmpId}"/>
          <c:set var="step1Status" value="${l.status}"/>
          <c:set var="step1DecidedAt" value="${l.decidedAt}"/>
        </c:if>
        <c:if test="${l.step == 2}">
          <c:set var="step2Name" value="${l.approverName}"/>
          <c:set var="step2EmpId" value="${l.approverEmpId}"/>
          <c:set var="step2Status" value="${l.status}"/>
          <c:set var="step2DecidedAt" value="${l.decidedAt}"/>
        </c:if>
      </c:forEach>

      <!-- 부서/팀: 값이 없어도 반드시 출력 -->
      <c:set var="deptName"
             value="${not empty doc.writerDeptName ? doc.writerDeptName :
                     (not empty doc.deptName ? doc.deptName :
                     (not empty org.deptName ? org.deptName : '부서 미지정'))}"/>
      <c:set var="teamName"
             value="${not empty doc.writerTeamName ? doc.writerTeamName :
                     (not empty doc.teamName ? doc.teamName :
                     (not empty org.teamName ? org.teamName : '팀 미지정'))}"/>

      <!-- 상단 타이틀 / 결재 패널 -->
      <div class="title-row">
        <div class="brand-title">
          <div class="company">COMMA Inc.</div>
          <div class="docname">
            <c:choose>
              <c:when test="${doc.documentType == 'VACATION'}">휴가신청서</c:when>
              <c:otherwise>지출결의서</c:otherwise>
            </c:choose>
          </div>
          <div class="meta">
            문서번호: #<c:out value="${doc.approvalDocumentId}"/><br/>
            상태: <c:out value="${doc.status}"/> ·
            작성자: <c:out value="${doc.writerName}"/> (#<c:out value="${doc.writerEmpId}"/>)<br/>
            작성일: <c:out value="${doc.createdAt}"/> ·
            완료일: <c:out value="${empty doc.completeAt ? '-' : doc.completeAt}"/>
          </div>
        </div>

        <div class="approval-panel">
          <table>
            <colgroup>
              <col style="width:25%"><col style="width:37.5%"><col style="width:37.5%">
            </colgroup>
            <thead>
              <tr>
                <th>구분</th>
                <th>1차 결재자</th>
                <th>2차 결재자</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <th>성명</th>
                <td>
                  <c:out value="${empty step1Name ? '-' : step1Name}"/>
                  <c:if test="${not empty step1EmpId}"> (#<c:out value="${step1EmpId}"/>)</c:if>
                </td>
                <td>
                  <c:out value="${empty step2Name ? '-' : step2Name}"/>
                  <c:if test="${not empty step2EmpId}"> (#<c:out value="${step2EmpId}"/>)</c:if>
                </td>
              </tr>
              <tr>
                <th>결재</th>
                <td class="sign-space"><span class="small">서명(도장) 영역</span></td>
                <td class="sign-space"><span class="small">서명(도장) 영역</span></td>
              </tr>
              <tr>
                <th>일시</th>
                <td><c:out value="${empty step1DecidedAt ? '-' : step1DecidedAt}"/></td>
                <td><c:out value="${empty step2DecidedAt ? '-' : step2DecidedAt}"/></td>
              </tr>
              <tr>
                <th>상태</th>
                <td><c:out value="${empty step1Status ? '-' : step1Status}"/></td>
                <td><c:out value="${empty step2Status ? '-' : step2Status}"/></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <c:choose>
        <c:when test="${doc.documentType == 'VACATION'}">
          <div class="form-section">
            <div class="h">신청자 정보</div>
            <div class="b">
              <div class="kv-row"><div class="kv-key">사번</div><div class="kv-val">#<c:out value="${doc.writerEmpId}"/></div></div>
              <div class="kv-row"><div class="kv-key">부서/팀</div>
                <div class="kv-val"><c:out value="${deptName}"/> / <c:out value="${teamName}"/></div>
              </div>
            </div>
          </div>

          <div class="form-section">
            <div class="h">휴가 정보</div>
            <div class="b">
              <div class="kv-row"><div class="kv-key">구분</div><div class="kv-val"><strong><c:out value="${doc.vacation.vacationTitle}"/></strong></div></div>
              <div class="kv-row"><div class="kv-key">사용일수</div><div class="kv-val"><c:out value="${doc.vacation.totalDays}"/> 일</div></div>
              <div class="kv-row"><div class="kv-key">시작일</div><div class="kv-val"><c:out value="${doc.vacation.startDate}"/></div></div>
              <div class="kv-row"><div class="kv-key">종료일</div><div class="kv-val"><c:out value="${doc.vacation.endDate}"/></div></div>
              <div class="kv-row"><div class="kv-key">비상연락처</div><div class="kv-val"><c:out value="${empty doc.vacation.emergencyContact ? '-' : doc.vacation.emergencyContact}"/></div></div>
              <div class="kv-row"><div class="kv-key">인수인계</div><div class="kv-val"><c:out value="${empty doc.vacation.handover ? '-' : doc.vacation.handover}"/></div></div>
              <div class="kv-row"><div class="kv-key">사유</div><div class="kv-val"><c:out value="${empty doc.vacation.vacationReason ? '-' : doc.vacation.vacationReason}"/></div></div>
            </div>
          </div>
        </c:when>

        <c:otherwise>
          <div class="form-section">
            <div class="h">신청자 정보</div>
            <div class="b">
              <div class="kv-row"><div class="kv-key">사번</div><div class="kv-val">#<c:out value="${doc.writerEmpId}"/></div></div>
              <div class="kv-row"><div class="kv-key">부서/팀</div>
                <div class="kv-val"><c:out value="${deptName}"/> / <c:out value="${teamName}"/></div>
              </div>
            </div>
          </div>

          <div class="form-section">
            <div class="h">지출 기본 정보</div>
            <div class="b">
              <div class="kv-row"><div class="kv-key">카테고리</div><div class="kv-val"><strong><c:out value="${doc.expense.expenseTitle}"/></strong></div></div>
              <div class="kv-row"><div class="kv-key">지급방법</div><div class="kv-val"><c:out value="${doc.expense.payMethod}"/></div></div>
              <div class="kv-row"><div class="kv-key">거래처</div><div class="kv-val"><c:out value="${empty doc.expense.vendor ? '-' : doc.expense.vendor}"/></div></div>
              <div class="kv-row"><div class="kv-key">계좌정보</div><div class="kv-val"><c:out value="${empty doc.expense.bankInfo ? '-' : doc.expense.bankInfo}"/></div></div>
              <div class="kv-row"><div class="kv-key">대표 지출일</div><div class="kv-val"><c:out value="${doc.expense.expenseDate}"/></div></div>
              <div class="kv-row"><div class="kv-key">총 금액</div><div class="kv-val"><fmt:formatNumber value="${doc.expense.totalAmount}" type="number"/> 원</div></div>
              <div class="kv-row"><div class="kv-key">사용목적</div><div class="kv-val"><c:out value="${empty doc.expense.expenseReason ? '-' : doc.expense.expenseReason}"/></div></div>
            </div>
          </div>

          <c:if test="${not empty doc.expenseItems}">
            <div class="form-section">
<c:if test="${doc.documentType == 'EXPENSE' && not empty doc.expenseItems}">
  <h3 style="margin-top:18px;">지출 세부내역</h3>
  <table>
    <thead>
      <tr>
        <th style="width:120px">사용일자</th>
        <th>내역(설명)</th>
        <th style="width:90px">과세</th>
        <th class="right" style="width:130px">공급가</th>
        <th class="right" style="width:120px">부가세</th>
        <th class="right" style="width:140px">합계</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="it" items="${doc.expenseItems}">
        <tr>
          <td>${it.useDate}</td>
          <td><c:out value="${it.memo}"/></td>
          <td><c:out value="${it.taxable == 1 ? '과세' : '면세'}"/></td>
          <td class="right"><fmt:formatNumber value="${it.supply}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${it.vat}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${it.total}" type="number"/></td>
        </tr>
      </c:forEach>
    </tbody>
    <tfoot>
      <tr>
        <td colspan="3" class="right">소계</td>
        <td class="right"><fmt:formatNumber value="${doc.sumSupply}" type="number"/></td>
        <td class="right"><fmt:formatNumber value="${doc.sumVat}" type="number"/></td>
        <td class="right"><fmt:formatNumber value="${doc.expense.totalAmount}" type="number"/></td>
      </tr>
    </tfoot>
  </table>
</c:if>
          </c:if>
        </c:otherwise>
      </c:choose>

      <div class="form-section">
        <div class="h">첨부파일</div>
        <div class="b">
          <c:if test="${not empty doc.files}">
            <ul style="margin:0; padding-left:18px;">
              <c:forEach var="f" items="${doc.files}">
                <li style="margin-bottom:4px;">
                  <a href="<c:url value='/approval/file/${f.fileId}/download'/>">
                    <c:out value="${f.originName}"/>
                  </a>
                  <span style="color:var(--muted); font-size:12px;">
                    (<fmt:formatNumber value='${f.size/1024}' maxFractionDigits='0'/> KB)
                  </span>
                </li>
              </c:forEach>
            </ul>
          </c:if>
          <c:if test="${empty doc.files}">
            <div style="color:var(--muted)">첨부 없음</div>
          </c:if>
        </div>
      </div>

      <div style="margin-top:14px; color:var(--muted); font-size:12px;">
        ※ 본 문서는 전자결재 시스템에서 작성·보관됩니다. 인쇄 시 서명란에 자필 서명/도장으로 대체할 수 있습니다.
      </div>
       	<a class="btn" href="/approval">홈으로</a>
    </div>
  </div>
  <jsp:include page ="../../views/nav/footer.jsp"></jsp:include>
</div>

<jsp:include page ="../../views/nav/javascript.jsp"></jsp:include>
</body>
</html>