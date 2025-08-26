<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
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
  </style>
</head>
<body>

<form method="post" action="<c:url value='/approval/vacations/new'/>" enctype="multipart/form-data" id="vacationForm">
  <div class="page">

    <!-- 헤더 -->
    <div class="hdr">
      <h1>휴가신청서 <span class="badge">Vacation Request</span></h1>
      <div class="meta">
        <div>작성일: <span id="metaDate"></span></div>
        <div>문서번호: (자동)</div>
      </div>
    </div>

    <!-- 신청자 / 잔여연차 (성명 제거) -->
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
              <option value="${fn:trim(codeId)}">${fn:trim(codeTitle)}</option>
            </c:forEach>
          </select>
          <div class="hint">예: 예비군/경조사/질병/연차/반차</div>
        </div>
	    <div>
	      <label>비상연락처</label>
	      <input type="text" id="emergency" name="emergencyContact" placeholder="예: 010-1234-5678">
	    </div>
      </div>

      <div class="grid">
        <div>
          <label>시작일</label>
          <div class="inline">
            <input type="date" name="startDate" id="startDate" required>
          </div>
        </div>
        <div>
          <label>종료일</label>
          <div class="inline">
            <input type="date" name="endDate" id="endDate" required>
            <label class="inline"><input type="checkbox"> 구현되지않은 반차</label> 
          </div>
        </div>
      </div>

      <div class="grid">
	    <div>
	      <label>업무 인수인계(담당자/범위)</label>
	      <input type="text" id="handover" name="handover" placeholder="예: 김PM에게 개발작업 진행 인수"> 
	    </div>
      </div>

      <div>
        <label>사유(요약)</label>
        <textarea id="reasonText" name="vacationReason" placeholder="예: 가족 경조사 참석 / 건강검진 등"></textarea>
      </div>
    </div>

    <!-- 첨부/서명 -->
    <div class="section">
      <div class="grid">
        <div>
          <label>첨부 (진단서/청첩장/소명자료 등)</label>
          <input type="file" name="files" id="files" multiple accept=".pdf,.jpg,.jpeg,.png,.heic,.heif,.webp">
          <div class="hint" id="fileList"></div>
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

  <!-- CSRF -->
  <c:if test="${not empty _csrf}">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
  </c:if>
</form>

<script>
  const metaDate = document.getElementById('metaDate');
  metaDate.textContent = new Date().toISOString().slice(0,10);

  const startDate = document.getElementById('startDate');
  const endDate   = document.getElementById('endDate');
  const startHalf = document.getElementById('startHalf');
  const endHalf   = document.getElementById('endHalf');
  const calcDays  = document.getElementById('calcDays');
  const fileInput = document.getElementById('files');
  const fileList  = document.getElementById('fileList');

  function businessDaysInclusive(s, e){
	    if (!s || !e) return 0;
	    const sd = new Date(s), ed = new Date(e);
	    if (ed < sd) return 0;
	    let days = 0;
	    for (let d = new Date(sd); d <= ed; d.setDate(d.getDate()+1)){
	      const w = d.getDay();
	      if (w !== 0 && w !== 6) days++;
	    }
	    return days;
	  }

  function recalc(){
    const s = startDate.value, e = endDate.value;
    let days = businessDaysInclusive(s, e);
    if (s && e && days > 0){
      let minus = 0;
      if (startHalf.checked) minus += 0.5;
      if (endHalf.checked)   minus += 0.5;
      if (s === e){
        days = 1 - (startHalf.checked && endHalf.checked ? 0 : (startHalf.checked || endHalf.checked ? 0.5 : 0));
      }else{
        days = days - minus;
      }
      if (days < 0) days = 0;
    }
    calcDays.textContent = days;
    document.getElementById('hiddenTotalDays').value = days;
  }
  [startDate, endDate, startHalf, endHalf].forEach(el=> el.addEventListener('change', recalc));
  recalc();

  fileInput.addEventListener('change', ()=>{
    if (!fileInput.files?.length){ fileList.textContent=''; return; }
    fileList.innerHTML = Array.from(fileInput.files).map(f=>`• ${f.name} (${Math.round(f.size/1024)} KB)`).join('<br>');
  });

  document.getElementById('vacationForm').addEventListener('submit', (e)=>{
	    if (!document.getElementById('vacationCategory').value){
	      alert('휴가 구분을 선택하세요.'); e.preventDefault(); return;
	    }
	    if (!document.getElementById('startDate').value || !document.getElementById('endDate').value){
	      alert('시작일과 종료일을 입력하세요.'); e.preventDefault(); return;
	    }
	    const days = Number(document.getElementById('hiddenTotalDays').value || 0);
	    if (days <= 0){
	      alert('사용일수를 확인하세요.'); e.preventDefault(); return;
	    }

	    const catSel = document.getElementById('vacationCategory');
	    const catText = catSel.options[catSel.selectedIndex]?.text || '휴가';
	    const s = document.getElementById('startDate').value;
	    const e2 = document.getElementById('endDate').value;
	    const title = `[${catText}] ${s} ~ ${e2} 휴가신청`;   // [CHANGED]
	    document.getElementById('hiddenTitle').value = title;
	  });
</script>
</body>
</html>