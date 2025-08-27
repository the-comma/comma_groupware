<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>지출결의서</title>
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

<form method="post" action="<c:url value='/approval/expenses/new'/>" enctype="multipart/form-data" id="expenseForm">
  <div class="page">

    <!-- 헤더 -->
    <div class="hdr">
      <h1>지출결의서</h1>
      <div class="meta">
        <div>작성일: <span id="metaDate"></span></div>
        <div>문서번호: (자동)</div>
      </div>
    </div>

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
			    <option value="${c.expenseId}">${c.expenseTitle}</option>
			  </c:forEach>
			</select>
          <div class="hint">예: 복리후생/출장비/소모품비/회식비</div>
        </div>
        <div>
          <label>거래처명</label>
          <input type="text" id="vendor" name="vendor" placeholder="예: (주)샘플상사"> <!-- [CHANGED] name 지정 -->
        </div>
      </div>

      <div class="grid">
        <div>
          <label>지급방법</label>
          <select id="payMethod" name="payMethod"> <!-- [CHANGED] enum 값으로 제출 -->
            <option value="CORP_CARD">법인카드</option>
            <option value="PERSONAL_CARD">개인카드</option>
            <option value="TRANSFER">계좌이체</option>
            <option value="CASH">현금</option>
          </select>
        </div>
        <div>
          <label>계좌정보(필요 시)</label>
          <input type="text" id="bankInfo" name="bankInfo" placeholder="예: 우리 1002-***-**** (홍길동)">
        </div>
      </div>
    </div>
        <div class="section">
      	 <div class="grid">
      	  <div>
         	 <label>사용목적</label>
        	  <input type="text" id="expenseReason" name="expenseReason" placeholder="사용목적을 적어주세요.">
        	</div>
       	 </div>
        </div>

    <!-- 지출 상세(라인 입력 → 합계 계산만, 저장은 총액/대표일만) -->
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
          <input type="file" name="files" id="files" multiple accept=".pdf,.jpg,.jpeg,.png,.heic,.heif,.webp,.xlsx,.xls,.hwp,.hwpx">
          <div class="hint" id="fileList"></div>
        </div>
        <div>
          <label>전자결재 서명</label>
          <div class="hint no-print">
            ← 전자서명 컴포넌트(API) 들어갈 자리 (도장 이미지/마우스 서명)
          </div>
        </div>
      </div>
    </div>

    <!-- 제출 -->
    <div class="section" style="display:flex; gap:8px; justify-content:flex-end;">
      <button type="button" class="btn" onclick="window.print()">인쇄/미리보기</button>
      <button type="submit" class="btn primary">제출</button>
    </div>
  </div>

  <!-- [KEEP] 서버 전송용 hidden (제목/총액/대표일자) -->
  <input type="hidden" name="title"        id="hiddenTitle">
  <input type="hidden" name="amount"       id="hiddenAmount">
  <input type="hidden" name="expenseDate"  id="hiddenExpenseDate">

  <!-- CSRF -->
  <c:if test="${not empty _csrf}">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
  </c:if>
</form>

<script>
  const KRW = n => (Number(n||0)).toLocaleString('ko-KR');
  const unKRW = s => Number(String(s||'0').replace(/[^\d.-]/g,''))||0;
  const metaDate = document.getElementById('metaDate');
  metaDate.textContent = new Date().toISOString().slice(0,10);

  const tblBody = document.querySelector('#itemTable tbody');
  const sumSupplyEl = document.getElementById('sumSupply');
  const sumVatEl    = document.getElementById('sumVat');
  const sumTotalEl  = document.getElementById('sumTotal');
  const fileInput   = document.getElementById('files');
  const fileList    = document.getElementById('fileList');

  function addRow(date='', desc='', taxable=true, supply=0){
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td><input type="date" class="i-date" value="${date}"></td>
      <td><input type="text" class="i-desc" placeholder="예: 팀 회식(10명) / 소모품 구매" value="${desc}"></td>
      <td>
        <select class="i-tax">
          <option ${taxable ? 'selected' : ''}>과세</option>
          <option ${!taxable ? 'selected' : ''}>면세</option>
        </select>
      </td>
      <td class="right"><input type="text" class="i-supply" value="${supply?KRW(supply):''}" placeholder="0"></td>
      <td class="right i-vat">0</td>
      <td class="right i-total">0</td>
      <td class="no-print"><button type="button" class="btn destructive btn-del">삭제</button></td>
    `;
    tblBody.appendChild(tr);
    recalc();
  }

  function recalc(){
    let sumSupply=0, sumVat=0, sumTotal=0;
    tblBody.querySelectorAll('tr').forEach(tr=>{
      const taxable = tr.querySelector('.i-tax').value === '과세';
      const supply  = unKRW(tr.querySelector('.i-supply').value);
      const vat     = taxable ? Math.round(supply*0.1) : 0;
      const total   = supply + vat;
      sumSupply += supply; sumVat += vat; sumTotal += total;
      tr.querySelector('.i-vat').textContent   = KRW(vat);
      tr.querySelector('.i-total').textContent = KRW(total);
    });
    sumSupplyEl.textContent = KRW(sumSupply);
    sumVatEl.textContent    = KRW(sumVat);
    sumTotalEl.textContent  = KRW(sumTotal);
  }

  // 초기 1행
  addRow(new Date().toISOString().slice(0,10), '', true, 0);

  document.getElementById('addRowBtn').addEventListener('click', ()=> addRow());
  document.getElementById('clearRowsBtn').addEventListener('click', ()=>{ tblBody.innerHTML=''; recalc(); });
  tblBody.addEventListener('input', e=>{
    if (e.target.classList.contains('i-supply')) {
      const n = unKRW(e.target.value);
      e.target.value = n ? KRW(n) : '';
      recalc();
    }
  });
  tblBody.addEventListener('change', e=>{
    if (e.target.classList.contains('i-tax') || e.target.classList.contains('i-date')) recalc();
  });
  tblBody.addEventListener('click', e=>{
    if (e.target.classList.contains('btn-del')) { e.target.closest('tr').remove(); recalc(); }
  });

  // 파일 리스트 표시
  fileInput.addEventListener('change', ()=>{
    if (!fileInput.files?.length){ fileList.textContent=''; return; }
    fileList.innerHTML = Array.from(fileInput.files).map(f=>`• ${f.name} (${Math.round(f.size/1024)} KB)`).join('<br>');
  });

  // 제출 전 파라미터 구성
  document.getElementById('expenseForm').addEventListener('submit', (e)=>{
    if (!document.getElementById('expenseCategory').value){
      alert('지출 카테고리를 선택하세요.'); e.preventDefault(); return;
    }
    if (!tblBody.querySelector('tr')){
      alert('지출 내역을 1건 이상 입력하세요.'); e.preventDefault(); return;
    }

    // 합계 / 대표일자
    let total = unKRW(sumTotalEl.textContent);
    let firstDate = '';
    tblBody.querySelectorAll('tr').forEach(tr=>{
      const d = tr.querySelector('.i-date').value;
      if (!firstDate && d) firstDate = d;
    });

    // [CHANGED] 제목에 날짜 제거 (작성일은 우측 meta에 따로 표시)
    const catSel = document.getElementById('expenseCategory');
    const catText = catSel.options[catSel.selectedIndex]?.text || '지출';
    const vendor  = (document.getElementById('vendor').value || '').trim();
    const title = `[${catText}] ${vendor ? vendor+' ' : ''}지출결의`;  // [CHANGED] 날짜 X

    document.getElementById('hiddenTitle').value = title;
    document.getElementById('hiddenAmount').value = total;
    document.getElementById('hiddenExpenseDate').value = firstDate || new Date().toISOString().slice(0,10);
  });
</script>
</body>
</html>