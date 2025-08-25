<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <style>
    body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Noto Sans KR, sans-serif; margin: 20px; }
    .btn { display:inline-block; padding:8px 12px; border:1px solid #e5e7eb; border-radius:8px; text-decoration:none; color:#111; background:#fff; margin-right:6px; }
    .btn.primary { background:#111827; color:#fff; border-color:#111827; }
    .btn.danger  { background:#fee2e2; color:#991b1b; border-color:#fecaca; }
    table { border-collapse:collapse; width:100%; }
    th, td { border:1px solid #e5e7eb; padding:8px; text-align:left; }
    th { background:#f9fafb; }
    .toolbar { margin-bottom:14px; }
    form { display:inline-block; }
  </style>
</head>
<body>

<h2>${doc.title}</h2>
<div style="color:#6b7280;margin-bottom:10px;">
  문서번호: ${doc.approvalDocumentId} /
  유형: ${doc.documentType} /
  상태: ${doc.status} /
  작성자: ${doc.writerName} (#${doc.writerEmpId}) /
  작성일: ${doc.createdAt} /
  완료일: <c:out value="${empty doc.completeAt ? '-' : doc.completeAt}"/>
</div>

<div class="toolbar">
  <!-- [ADDED] 수정/삭제 버튼: 작성자 + 결재 진행 전 -->
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
          onsubmit="return confirm('정말 삭제할까요? 삭제 후 복구할 수 없습니다.');">
      <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
      </c:if>
      <button type="submit" class="btn danger">삭제</button>
    </form>
  </c:if>

  <!-- PDF -->
  <a class="btn" href="<c:url value='/approval/doc/${doc.approvalDocumentId}/download'/>">PDF 다운로드</a>
</div>

<c:choose>
  <c:when test="${doc.documentType == 'VACATION'}">
    <h3>휴가 상세</h3>
    <div>구분: <strong>${doc.vacation.vacationTitle}</strong></div>
    <div>기간: ${doc.vacation.startDate} ~ ${doc.vacation.endDate}
        (사용일수: ${doc.vacation.totalDays})</div>
    <div>비상연락처: <c:out value="${empty doc.vacation.emergencyContact ? '-' : doc.vacation.emergencyContact}"/></div>
    <div>인수인계:   <c:out value="${empty doc.vacation.handover ? '-' : doc.vacation.handover}"/></div>
    <div>사유:       <c:out value="${empty doc.vacation.vacationReason ? '-' : doc.vacation.vacationReason}"/></div>
  </c:when>

  <c:otherwise>
    <h3>지출 상세</h3>
    <div>구분: <strong>${doc.expense.expenseTitle}</strong></div>
    <div>거래처: <c:out value="${empty doc.expense.vendor ? '-' : doc.expense.vendor}"/>
        / 지급방법: ${doc.expense.payMethod}
        / 계좌: <c:out value="${empty doc.expense.bankInfo ? '-' : doc.expense.bankInfo}"/></div>
    <div>금액: <fmt:formatNumber value="${doc.expense.totalAmount}" type="number"/>원
        / 지출일: ${doc.expense.expenseDate}</div>
    <div>사유: <c:out value="${empty doc.expense.expenseReason ? '-' : doc.expense.expenseReason}"/></div>
  </c:otherwise>
</c:choose>

<h3 style="margin-top:18px;">결재선</h3>
<table>
  <tr><th>단계</th><th>결재자</th><th>상태</th><th>일시</th></tr>
  <c:forEach var="l" items="${doc.lines}">
    <tr>
      <td>${l.step}</td>
      <td>${l.approverName} (#${l.approverEmpId})</td>
      <td>${l.status}</td>
      <td><c:out value="${empty l.decidedAt ? '-' : l.decidedAt}"/></td>
    </tr>
  </c:forEach>
</table>

<h3 style="margin-top:18px;">첨부파일</h3>
<c:if test="${not empty doc.files}">
  <ul>
    <c:forEach var="f" items="${doc.files}">
      <li>
        <a href="<c:url value='/approval/file/${f.fileId}/download'/>">
          ${f.originName} (${f.size} bytes)
        </a>
      </li>
    </c:forEach>
  </ul>
</c:if>
<c:if test="${empty doc.files}">
  <div style="color:#6b7280">첨부 없음</div>
</c:if>

<c:if test="${canEdit}">
  <a class="btn" href="<c:url value='/approval/${doc.documentType eq "VACATION" ? "vacations" : "expenses"}/${doc.approvalDocumentId}/edit'/>">수정</a>
  <form method="post" action="<c:url value='/approval/doc/${doc.approvalDocumentId}/delete'/>" style="display:inline">
    <button class="btn btn-danger" onclick="return confirm('삭제할까요?')">삭제</button>
  </form>
</c:if>

<c:if test="${not empty myLine}">
  <!-- 내 차례일 때만 승인/반려 -->
  <form method="post" action="<c:url value='/approval/line/${myLine.approvalLineId}/approve'/>" style="display:inline">
    <button class="btn btn-success">승인</button>
  </form>
  <form method="post" action="<c:url value='/approval/line/${myLine.approvalLineId}/reject'/>" style="display:inline">
    <input type="text" name="reason" placeholder="반려 사유" required/>
    <button class="btn btn-danger">반려</button>
  </form>
</c:if>

</body>
</html>