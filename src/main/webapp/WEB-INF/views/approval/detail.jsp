<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
<h3>문서 상세 (#${d.approvalDocumentId})</h3>
<p><strong>${d.title}</strong> [${d.documentType}] - 상태: <b>${d.status}</b></p>
<p>작성자: ${d.writerEmpId} / 작성일: ${d.createdAt} / 완료일: ${d.completeAt}</p>
<p>사유: ${d.reason}</p>

<c:if test="${d.documentType eq 'VACATION'}">
  <h4>휴가 상세</h4>
  <p>구분: ${d.vacation.vacation_title}</p>
  <p>기간: ${d.vacation.start_date} ~ ${d.vacation.end_date} (${d.vacation.total_days}일)</p>
</c:if>

<c:if test="${d.documentType eq 'EXPENSE'}">
  <h4>지출 상세</h4>
  <p>구분: ${d.expense.expense_title}</p>
  <p>금액: ${d.expense.request_amount} / 사용일자: ${d.expense.expense_date}</p>
</c:if>

<h4>결재선</h4>
<table class="table">
  <tr><th>단계</th><th>결재자</th><th>상태</th><th>일시</th></tr>
  <c:forEach var="l" items="${d.lines}">
    <tr>
      <td>${l.step}</td>
      <td>${l.approverEmpId}</td>
      <td>${l.status}</td>
      <td>${l.approveAt}</td>
    </tr>
  </c:forEach>
</table>

<!-- TODO: 전자서명 API 영역(결재자용 마우스 서명 위젯 삽입 위치) -->

<c:if test="${d.status eq 'IN_PROGRESS'}">
  <!-- 승인/반려 버튼은 서버에서 라인 권한체크 수행 -->
  <form method="post" action="<c:url value='/approval/line/${param.lineId}/approve'/>">
    <!-- param.lineId는 라인 상세 페이지에서 개별로 넘기는 방식 or 서버에서 내 PENDING라인 자동 탐색해서 버튼 노출하는 로직으로 전환 가능 -->
    <button type="submit" class="btn btn-success">승인</button>
  </form>

  <form method="post" action="<c:url value='/approval/line/${param.lineId}/reject'/>">
    <input type="text" name="reason" placeholder="반려 사유" required/>
    <button type="submit" class="btn btn-danger">반려</button>
  </form>
</c:if>

<p>
  <a class="btn btn-outline-secondary" href="<c:url value='/approval/doc/${d.approvalDocumentId}/download'/>">PDF 다운로드</a>
</p>
</body>
</html>