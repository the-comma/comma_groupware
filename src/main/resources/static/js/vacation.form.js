(() => {
  'use strict';

  const $ = (id) => document.getElementById(id);

  window.addEventListener('DOMContentLoaded', () => {
    // 엘리먼트 참조
    const metaDate  = $('metaDate');
    const startDate = $('startDate');
    const endDate   = $('endDate');
    const halfDay   = $('halfDay');       // 당일 반차
    const rangeHalfs= $('rangeHalfs');    // 기간 반차 컨테이너
    const startHalf = $('startHalf');     // 시작 반차
    const endHalf   = $('endHalf');       // 종료 반차
    const calcDays  = $('calcDays');
    const hiddenTD  = $('hiddenTotalDays');
    const catSel    = $('vacationCategory');
    const fileInput = $('uploadInput') || $('files'); // id가 다를 수 있어 둘 다 대응
    const fileList  = $('fileList');
    const form      = $('vacationForm');

    if (metaDate) metaDate.textContent = new Date().toISOString().slice(0, 10);

    // ===== 유틸 =====
    function todayStr() {
      const now = new Date();
      const y = now.getFullYear();
      const m = String(now.getMonth() + 1).padStart(2, '0');
      const d = String(now.getDate()).padStart(2, '0');
      return `${y}-${m}-${d}`;
    }
    function toLocalDate(dstr) { return dstr ? new Date(`${dstr}T00:00:00`) : null; }
    function isWeekend(d) { const w = d.getDay(); return w === 0 || w === 6; }

    function applyMinToday() {
      const t = todayStr();
      if (startDate) {
        startDate.min = t;
        if (startDate.value && startDate.value < t) startDate.value = t;
      }
      if (endDate) {
        endDate.min = t;
        if (endDate.value && endDate.value < t) endDate.value = t;
      }
    }

    function businessDaysInclusive(s, e) {
      if (!s || !e) return 0;
      const sd = toLocalDate(s), ed = toLocalDate(e);
      if (!sd || !ed || ed < sd) return 0;
      let days = 0;
      for (let d = new Date(sd); d <= ed; d.setDate(d.getDate() + 1)) {
        if (!isWeekend(d)) days++;
      }
      return days;
    }

    // 당일/기간에 따라 반차 UI 활성화 제어
    function syncHalfDayAvailability() {
      const s = startDate?.value, e = endDate?.value;
      const same = s && e && s === e;

      if (!rangeHalfs) return;

      if (same) {
        rangeHalfs.style.display = 'none';
        if (startHalf) { startHalf.checked = false; startHalf.disabled = true; }
        if (endHalf)   { endHalf.checked   = false; endHalf.disabled   = true; }

        if (halfDay) {
          halfDay.disabled = true;
          const d = toLocalDate(s);
          if (d && !isWeekend(d)) halfDay.disabled = false;
          if (halfDay.disabled) halfDay.checked = false;
        }
      } else {
        if (halfDay) { halfDay.checked = false; halfDay.disabled = true; }

        rangeHalfs.style.display = 'inline-block';
        let startOk = false, endOk = false;
        if (s) { const sd = toLocalDate(s); startOk = !!(sd && !isWeekend(sd)); }
        if (e) { const ed = toLocalDate(e); endOk   = !!(ed && !isWeekend(ed)); }

        if (startHalf) { startHalf.disabled = !startOk; if (!startOk) startHalf.checked = false; }
        if (endHalf)   { endHalf.disabled   = !endOk;   if (!endOk)   endHalf.checked   = false; }
      }
    }

    function recalc() {
      applyMinToday();
      const s = startDate?.value, e = endDate?.value;
      syncHalfDayAvailability();

      let days = businessDaysInclusive(s, e);

      if (s && e && days > 0) {
        if (s === e) {
          const d = toLocalDate(s);
          days = (d && !isWeekend(d)) ? ((halfDay && halfDay.checked) ? 0.5 : 1) : 0;
        } else {
          let minus = 0;
          const sd = toLocalDate(s), ed = toLocalDate(e);
          if (startHalf && startHalf.checked && sd && !isWeekend(sd)) minus += 0.5;
          if (endHalf   && endHalf.checked   && ed && !isWeekend(ed)) minus += 0.5;
          days = Math.max(0, days - minus);
        }
      }

      if (calcDays) calcDays.textContent = String(days);
      if (hiddenTD) hiddenTD.value = String(days);
    }

    // ===== 초기화 & 바인딩 =====
    recalc();
    if (startDate) startDate.addEventListener('change', recalc);
    if (endDate)   endDate.addEventListener('change', recalc);
    if (halfDay)   halfDay.addEventListener('change', recalc);
    if (startHalf) startHalf.addEventListener('change', recalc);
    if (endHalf)   endHalf.addEventListener('change', recalc);

    if (fileInput && fileList) {
      fileInput.addEventListener('change', () => {
        if (!fileInput.files?.length) { fileList.textContent = ''; return; }
        fileList.innerHTML = Array.from(fileInput.files)
          .map(f => `• ${f.name} (${Math.round(f.size / 1024)} KB)`).join('<br>');
      });
    }

    if (form) {
      form.addEventListener('submit', (e) => {
        recalc(); // 마지막 방어

        if (!catSel || !catSel.value) { alert('휴가 구분을 선택하세요.'); e.preventDefault(); return; }
        if (!startDate?.value || !endDate?.value) { alert('시작일과 종료일을 입력하세요.'); e.preventDefault(); return; }
        const days = Number(hiddenTD?.value || 0);
        if (Number.isNaN(days) || days <= 0) { alert('사용일수를 확인하세요.'); e.preventDefault(); return; }

        const catText = catSel.options[catSel.selectedIndex]?.text || '휴가';
        const s = startDate.value;
        const e2 = endDate.value;
        let halfMark = '';
        if (s === e2 && halfDay?.checked) {
          halfMark = ' (반차)';
        } else {
          const marks = [];
          if (startHalf?.checked) marks.push('시작 반차');
          if (endHalf?.checked)   marks.push('종료 반차');
          if (marks.length) halfMark = ` (${marks.join(', ')})`;
        }
        const hiddenTitle = $('hiddenTitle');
        if (hiddenTitle) hiddenTitle.value = `[${catText}${halfMark}] ${s} ~ ${e2} 휴가신청`;
      });
    }
  });
})();