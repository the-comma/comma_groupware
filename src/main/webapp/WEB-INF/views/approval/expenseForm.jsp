<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
  <style>
    :root{
      --line:#e5e7eb; --muted:#6b7280; --title:#111827; --accent:#111827;
      --paper:#ffffff; --bg:#f8fafc;
    }
    body{ margin:0; background:var(--bg); font-family:system-ui,-apple-system,Segoe UI,Roboto,Apple SD Gothic Neo,Noto Sans KR,sans-serif; color:#111;}
    .page{ max-width:980px; margin:24px auto; background:var(--paper); box-shadow:0 10px 30px rgba(0,0,0,.06); border-radius:14px; overflow:hidden; }
    .hdr{ padding:24px 28px; border-bottom:1px solid var(--line); display:flex; align-items:center; justify-content:space-between; background:#fff; }
    .hdr h1{ margin:0; font-size:22px; letter-spacing:.3px;}
    .meta{ font-size:13px; color:var(--muted); text-align:right; }
    .section{ padding:20px 28px; border-bottom:1px solid var(--line); }
    .grid{ display:grid; grid-template-columns:1fr 1fr; gap:14px 18px; }
    .grid-3{ display:grid; grid-template-columns:1fr 1fr 1fr; gap:12px 16px; }
    label{ font-size:12px; color:var(--muted); display:block; margin:0 0 6px; }
    input[type="text"], input[type="date"], input[type="number"], select, textarea{
      width:100%; box-sizing:border-box; border:1px solid var(--line); border-radius:8px; padding:10px 12px; font-size:14px; outline:none;
    }
    textarea{ min-height:84px; resize:vertical; }
    .table-wrap{ overflow:auto; border:1px solid var(--line); border-radius:12px; }
    table{ width:100%; border-collapse:collapse; font-size:14px; }
    th, td{ border-bottom:1px solid var(--line); padding:10px; text-align:left; }
    thead th{ background:#f3f4f6; font-weight:600; }
    tfoot td{ background:#fafafa; font-weight:600; }
    .row-actions{ white-space:nowrap; }
    .btn{ display:inline-block; padding:10px 14px; border-radius:10px; border:1px solid var(--line); background:#fff; cursor:pointer; font-size:14px; }
    .btn.primary{ background:#111827; color:#fff; border-color:#111827; }
    .btn.ghost{ background:transparent; }
    .btn.destructive{ background:#fee2e2; border-color:#fecaca; color:#991b1b; }
    .toolbar{ display:flex; gap:8px; align-items:center; }
    .hint{ color:var(--muted); font-size:12px; }
    .badget{ display:inline-block; padding:2px 8px; background:#eef2ff; color:#3730a3; border-radius:999px; font-size:12px; margin-left:6px;}
    .sigpad{ padding:12px; border:1px dashed #cbd5e1; border-radius:10px; background:#f8fafc; color:#475569; font-size:13px; }
    .files{ font-size:13px; color:var(--muted); }
    .right{ text-align:right; }
    .money{ font-variant-numeric: tabular-nums; text-align:right; }
    @media print{
      body{ background:#fff; }
      .page{ box-shadow:none; border:0; border-radius:0; }
      .no-print{ display:none !important; }
    }
  </style>
</head>
<body>

<form method="post" action="<c:url value='/approval/expenses/new'/>" enctype="multipart/form-data" id="expenseForm">
  <div class="page">

    <!-- 헤더 -->
    <div class="hdr">
      <h1>지출결의서 <span class="badget">Expense Report</span></h1>
      <div class="meta">
        <div>작성일: <span id="metaDate"></span></div>
        <div>문서번호: (자동)</div>
      </div>
    </div>

    <!-- 신청자 정보 -->
    <div class="section">
      <div class="grid-3">
        <div>
          <label>부서</label>
          <input type="text" id="dept" placeholder="예: 개발팀">
        </div>
        <div>
          <label>사번</label>
          <input type="text" id="empNo" placeholder="예: 2025-001">
        </div>
        <div>
          <label>성명</label>
          <input type="text" id="empName" placeholder="예: 홍길동">
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
              <c:set var="codeId">
                <c:choose>
                  <c:when test="${not empty c.expenseId}">${c.expenseId}</c:when>
                  <c:when test="${not empty c.id}">${c.id}</c:when>
                  <c:otherwise>${c[0]}</c:otherwise>
                </c:choose>
              </c:set>
              <c:set var="codeTitle">
                <c:choose>
                  <c:when test="${not empty c.expenseTitle}">${c.expenseTitle}</c:when>
                  <c:when test="${not empty c.title}">${c.title}</c:when>
                  <c:otherwise>${c[1]}</c:otherwise>
                </c:choose>
              </c:set>
              <option value="${fn:trim(codeId)}">${fn:trim(codeTitle)}</option>
            </c:forEach>
          </select>
          <div class="hint">예: 복리후생/출장비/소모품비/회식비</div>
        </div>
        <div>
          <label>거래처명</label>
          <input type="text" id="vendor" placeholder="예: (주)샘플상사">
        </div>
      </div>
      <div class="grid">
        <div>
          <label>지급방법</label>
          <select id="payMethod">
            <option>법인카드</option>
            <option>개인카드</option>
            <option>계좌이체</option>
            <option>현금</option>
          </select>
        </div>
        <div>
          <label>계좌정보(필요 시)</label>
          <input type="text" id="bankInfo" placeholder="예: 우리 1002-***-**** (홍길동)">
        </div>
      </div>
    </div>

    <!-- 지출 상세(라인 아이템) -->
    <div class="section">
      <div class="toolbar no-print" style="justify-content:space-between;">
        <div class="hint">* 라인별 과세 여부를 설정하면 부가세 자동 계산 (10%)</div>
        <div>
          <button type="button" class="btn" id="addRowBtn">+ 행 추가</button>
          <button type="button" class="btn ghost" id="clearRowsBtn">행 모두 삭제</button>
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
          <tbody>
          </tbody>
          <tfoot>
            <tr>
              <td colspan="3" class="right">소계</td>
              <td class="money" id="sumSupply">0</td>
              <td class="money" id="sumVat">0</td>
              <td class="money" id="sumTotal">0</td>
              <td class="no-print"></td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>

    <!-- 첨부/서명 -->
    <div class="section">
      <div class="grid">
        <div>
          <label>증빙 첨부 (영수증/세금계산서 등)</label>
          <input type="file" name="files" id="files" multiple accept=".pdf,.jpg,.jpeg,.png,.heic,.heif,.webp,.xlsx,.xls,.hwp,.hwpx">
          <div class="files" id="fileList"></div>
        </div>
        <div>
          <label>전자결재 서명</label>
          <div class="sigpad no-print">
            TODO: 전자서명 위젯(API) 삽입 위치<br/>
            - 도장 이미지 업로드 또는 마우스 서명 캔버스<br/>
            - 제출 전 파일로 업로드하여 문서에 첨부
          </div>
        </div>
      </div>
    </div>

    <!-- 제출 버튼 -->
    <div class="section" style="display:flex; gap:8px; justify-content:flex-end;">
      <button type="button" class="btn" onclick="window.print()">인쇄/미리보기</button>
      <button type="submit" class="btn primary">제출</button>
    </div>
  </div>

  <!-- 서버 요구 파라미터(숨김) -->
  <input type="hidden" name="title"  id="hiddenTitle">
  <input type="hidden" name="reason" id="hiddenReason">
  <input type="hidden" name="amount" id="hiddenAmount">
  <input type="hidden" name="expenseDate" id="hiddenExpenseDate">

  <!-- CSRF -->
  <c:if test="${not empty _csrf}">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
  </c:if>
</form>

<script>
  const KRW = n => (Number(n||0)).toLocaleString('ko-KR');
  const unKRW = s => Number(String(s||'0').replace(/[^\d.-]/g,''))||0;

  const tblBody = document.querySelector('#itemTable tbody');
  const sumSupplyEl = document.querySelector('#sumSupply');
  const sumVatEl    = document.querySelector('#sumVat');
  const sumTotalEl  = document.querySelector('#sumTotal');
  const fileInput   = document.querySelector('#files');
  const fileList    = document.querySelector('#fileList');
  const metaDate    = document.querySelector('#metaDate');

  metaDate.textContent = new Date().toISOString().slice(0,10);

  function addRow(date='', desc='', taxable=true, supply=0){
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td><input type="date" class="i-date" value="\${date}"></td>
      <td><input type="text" class="i-desc" placeholder="예: 팀 회식(10명) / 노트북 어댑터 구매 등" value="\${desc}"></td>
      <td>
        <select class="i-tax">
          <option \${taxable ? 'selected' : ''}>과세</option>
          <option \${!taxable ? 'selected' : ''}>면세</option>
        </select>
      </td>
      <td class="right"><input type="text" class="i-supply" value="\${supply ? KRW(supply) : ''}" placeholder="0"></td>
      <td class="money i-vat">0</td>
      <td class="money i-total">0</td>
      <td class="row-actions no-print"><button type="button" class="btn destructive btn-del">삭제</button></td>
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

  // 이벤트 바인딩
  document.getElementById('addRowBtn').addEventListener('click', ()=> addRow());
  document.getElementById('clearRowsBtn').addEventListener('click', ()=>{
    tblBody.innerHTML=''; recalc();
  });
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
    if (e.target.classList.contains('btn-del')) {
      e.target.closest('tr').remove(); recalc();
    }
  });

  // 파일 리스트 표시
  fileInput.addEventListener('change', ()=>{
    if (!fileInput.files?.length){ fileList.textContent=''; return; }
    fileList.innerHTML = Array.from(fileInput.files).map(f=>`• \${f.name} (\${Math.round(f.size/1024)} KB)`).join('<br>');
  });

  // 제출 전 필수 파라미터 구성
  document.getElementById('expenseForm').addEventListener('submit', (e)=>{
    if (!document.getElementById('expenseCategory').value){
      alert('지출 카테고리를 선택하세요.'); e.preventDefault(); return;
    }
    if (!tblBody.querySelector('tr')){
      alert('지출 내역을 1건 이상 입력하세요.'); e.preventDefault(); return;
    }

    let total = unKRW(sumTotalEl.textContent);
    let firstDate = '';
    const lines = [];
    tblBody.querySelectorAll('tr').forEach((tr, idx)=>{
      const d = tr.querySelector('.i-date').value;
      const desc = tr.querySelector('.i-desc').value.trim();
      const tax = tr.querySelector('.i-tax').value;
      const supply = unKRW(tr.querySelector('.i-supply').value);
      const vat = unKRW(tr.querySelector('.i-vat').textContent);
      const sum = unKRW(tr.querySelector('.i-total').textContent);
      if (!firstDate && d) firstDate = d;
      lines.push(`#\${idx+1} [\${d}] \${desc} / \${tax} / 공급가 \${supply.toLocaleString()} / VAT \${vat.toLocaleString()} / 합계 \${sum.toLocaleString()}원`);
    });

    const catSel = document.getElementById('expenseCategory');
    const catText = catSel.options[catSel.selectedIndex]?.text || '지출';
    const vendor  = (document.getElementById('vendor').value || '').trim();
    const title = `[\${catText}] \${vendor?vendor+' ':''}\${firstDate || ''} 지출결의`;
    const reason = [
      `• 부서: \${document.getElementById('dept').value||'-'} / 사번: \${document.getElementById('empNo').value||'-'} / 성명: \${document.getElementById('empName').value||'-'}`,
      `• 카테고리: \${catText} / 거래처: \${vendor||'-'} / 지급방법: \${document.getElementById('payMethod').value} / 계좌: \${document.getElementById('bankInfo').value||'-'}`,
      `• 총 금액: \${total.toLocaleString()}원 (공급가 \${unKRW(sumSupplyEl.textContent).toLocaleString()}, VAT \${unKRW(sumVatEl.textContent).toLocaleString()})`,
      `• 세부 내역:`,
      ...lines
    ].join('\n');

    document.getElementById('hiddenTitle').value = title;
    document.getElementById('hiddenReason').value = reason;
    document.getElementById('hiddenAmount').value = total;
    document.getElementById('hiddenExpenseDate').value = firstDate || new Date().toISOString().slice(0,10);
  });
</script>

</body>
</html>