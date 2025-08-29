(() => {
	(() => {
	  const form = document.getElementById('expenseForm');
	  if (!form) return;

	  const IS_EDIT     = String(form.dataset.edit).trim() === 'true';
	  const PREV_DATE   = form.dataset.prevDate || '';
	  const PREV_AMOUNT = Number(form.dataset.prevAmt || 0);

	  const KRW   = n => (Number(n||0)).toLocaleString('ko-KR');
	  const unKRW = s => Number(String(s||'0').replace(/[^\d.-]/g,''))||0;
	  const todayStr = () => new Date().toISOString().slice(0,10);

	  const metaDate = document.getElementById('metaDate');
	  if (metaDate) metaDate.textContent = todayStr();

// ===== 테이블/합계 =====
const tblBody = document.querySelector('#itemTable tbody');
const sumSupplyEl = document.getElementById('sumSupply');
const sumVatEl    = document.getElementById('sumVat');
const sumTotalEl  = document.getElementById('sumTotal');

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

function findSupplyForTaxableTotal(total){
    const approx = Math.floor(total / 1.1);
    for (let s = Math.max(0, approx - 200); s <= approx + 200; s++){
      const vat = Math.round(s * 0.1);
      if (s + vat === total) return s;
    }
    return null;
  }

  if (IS_EDIT) {
    const seedDate = PREV_DATE || new Date().toISOString().slice(0,10);
    const s = findSupplyForTaxableTotal(PREV_AMOUNT);
    if (s != null) addRow(seedDate, '', true,  s);   // 과세로 총액 정확 재현
    else           addRow(seedDate, '', false, PREV_AMOUNT); // 면세로 총액 그대로
  } else {
    addRow(new Date().toISOString().slice(0,10), '', true, 0);
  }
  
// 버튼/입력 바인딩
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

// 파일 리스트 표시 (신규: files / 수정: addFiles)
const fileInput = document.getElementById('fileInput');
const fileList  = document.getElementById('fileList');
fileInput.addEventListener('change', ()=>{
  if (!fileInput.files?.length){ fileList.textContent=''; return; }
  fileList.innerHTML = Array.from(fileInput.files)
    .map(f=>`• ${f.name} (${Math.round(f.size/1024)} KB)`).join('<br>');
});

// 제출 전 hidden 채우기
document.getElementById('expenseForm').addEventListener('submit', (e)=>{
  if (!document.getElementById('expenseCategory').value){
    alert('지출 카테고리를 선택하세요.'); e.preventDefault(); return;
  }
  if (!tblBody.querySelector('tr')){
    alert('지출 내역을 1건 이상 입력하세요.'); e.preventDefault(); return;
  }

  const total = unKRW(sumTotalEl.textContent);
  let firstDate = '';
  tblBody.querySelectorAll('tr').forEach(tr=>{
    const d = tr.querySelector('.i-date').value;
    if (!firstDate && d) firstDate = d;
  });

  // 제목(작성일은 헤더 meta에서 표시)
  const catSel = document.getElementById('expenseCategory');
  const catText = catSel.options[catSel.selectedIndex]?.text || '지출';
  const vendor  = (document.getElementById('vendor').value || '').trim();
  const title = `[${catText}] ${vendor ? vendor+' ' : ''}지출결의`;

  document.getElementById('hiddenTitle').value = title;
  document.getElementById('hiddenAmount').value = total;
  document.getElementById('hiddenExpenseDate').value = firstDate || todayStr();
});
})();