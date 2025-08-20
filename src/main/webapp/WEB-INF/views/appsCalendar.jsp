<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>캘린더</title>

  <%@ include file="/WEB-INF/views/partials/head-css.jsp" %>

  <!-- FullCalendar CSS -->
  <link rel="stylesheet" href="<c:url value='/HTML/Admin/dist/assets/vendor/fullcalendar/index.global.min.css'/>">

  <!-- Bootstrap + 아이콘 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

  <!-- 앱 공통 CSS -->
  <link rel="stylesheet" href="/HTML/Admin/dist/assets/css/core.css">
  <link rel="stylesheet" href="<c:url value='/HTML/Admin/dist/assets/css/apps-calendar.css'/>">

  <!-- custom.css (있으면 사용, 없으면 패스) -->
  <link rel="stylesheet" href="<c:url value='/assets/css/custom.css?ver=20250820-7'/>">

  <style>
    /* 보이는 파란 링크 제거(날짜, more 링크) — 안전패치 */
    #calendar .fc a { color:#111 !important; text-decoration:none !important; }
  </style>
  
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
</head>
<body>
  <div class="wrapper">
    <jsp:include page="/WEB-INF/views/partials/menu.jsp">
      <jsp:param name="title" value="캘린더"/>
    </jsp:include>

    <div class="page-content">
      <div class="page-container container-fluid">

        <!-- 캘린더 -->
        <div class="col-12">
          <div class="card calendar-card">
            <div class="card-body">
              <div id="calendar" aria-label="메인 캘린더"></div>
            </div>
          </div>
        </div>

        <!-- 외부 이벤트 패널 -->
        <div id="external-panel" class="cal-ext d-none" aria-hidden="true">
          <div class="cal-ext__head">외부 이벤트 (드래그해서 캘린더에 추가)</div>
          <div id="external-events" class="cal-side__list">
            <div class="evt-chip fc-event" data-class="cat-department" data-type="department" title="드래그해서 캘린더에 놓기">
              <span class="chip-dot chip--green"></span><span class="chip-label">신규 일정</span>
            </div>
            <div class="evt-chip fc-event" data-class="cat-meeting" data-type="meeting" title="드래그해서 캘린더에 놓기">
              <span class="chip-dot chip--cyan"></span><span class="chip-label">회의</span>
            </div>
            <div class="evt-chip fc-event" data-class="cat-report" data-type="report" title="드래그해서 캘린더에 놓기">
              <span class="chip-dot chip--yellow"></span><span class="chip-label">보고서 작성</span>
            </div>
            <div class="evt-chip fc-event" data-class="cat-theme" data-type="theme" title="드래그해서 캘린더에 놓기">
              <span class="chip-dot chip--red"></span><span class="chip-label">신규 테마 제작</span>
            </div>
          </div>

          <div id="cal-legend" class="cal-legend mt-2">
            <span><i class="dot dot--blue"></i> 회사</span>
            <span><i class="dot dot--green"></i> 부서</span>
            <span><i class="dot dot--purple"></i> 프로젝트</span>
            <span><i class="dot dot--teal"></i> 휴가</span>
          </div>
        </div>

      </div>
      <jsp:include page="/WEB-INF/views/partials/footer.jsp" />
    </div>
  </div>

  <jsp:include page="/WEB-INF/views/partials/customizer.jsp" />
  <jsp:include page="/WEB-INF/views/partials/footer-scripts.jsp" />

  <!-- 일정 모달 -->
  <div class="modal fade" id="event-modal" tabindex="-1" aria-labelledby="event-modal-title" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <form class="needs-validation" id="forms-event" novalidate>
          <div class="modal-header">
            <h5 class="modal-title" id="event-modal-title">새 일정 추가</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
          </div>
          <div class="modal-body">
            <!-- 🔒 수정/삭제용 id -->
            <input type="hidden" id="event-id" />
            <div class="mb-3">
              <label class="form-label" for="event-title">일정 제목</label>
              <input class="form-control" id="event-title" name="title" type="text" placeholder="예: 팀 회의" required />
              <div class="invalid-feedback">제목을 입력하세요</div>
            </div>
            <div class="row">
              <div class="col-md-6 mb-3">
                <label class="form-label" for="event-start">시작</label>
                <input class="form-control" id="event-start" name="start" type="datetime-local" required />
                <div class="invalid-feedback">시작 일시를 입력하세요</div>
              </div>
              <div class="col-md-6 mb-3">
                <label class="form-label" for="event-end">종료 (선택)</label>
                <input class="form-control" id="event-end" name="end" type="datetime-local" />
              </div>
            </div>
            <div class="mb-3">
              <label class="form-label d-block mb-1">카테고리</label>
              <div class="color-swatches">
                <label class="swatch"><input type="radio" name="category" value="cat-company" checked /><span class="blob blob--blue"></span> 회사</label>
                <label class="swatch"><input type="radio" name="category" value="cat-department" /><span class="blob blob--green"></span> 부서</label>
                <label class="swatch"><input type="radio" name="category" value="cat-project" /><span class="blob blob--cyan"></span> 프로젝트</label>
                <label class="swatch"><input type="radio" name="category" value="cat-vacation" /><span class="blob blob--yellow"></span> 휴가</label>
                <label class="swatch"><input type="radio" name="category" value="cat-etc" /><span class="blob blob--red"></span> 기타</label>
              </div>
            </div>
            <div class="mb-2">
              <label class="form-label" for="event-memo">설명</label>
              <textarea class="form-control" id="event-memo" name="memo" rows="3" placeholder="메모를 입력하세요"></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-outline-danger d-none" id="btn-delete">삭제</button>
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button>
            <button type="submit" class="btn btn-primary" id="btn-save-event">저장</button>
          </div>
        </form>
      </div>
    </div>
  </div>

<script>
document.addEventListener('DOMContentLoaded', () => {
  const modalEl   = document.getElementById('event-modal');
  const btnDelete = document.getElementById('btn-delete');
  const btnSave   = document.getElementById('btn-save-event');

  const openModal = (prefill) => {
    // 신규모드 초기화
    document.getElementById('event-id').value = '';
    btnSave.textContent = '저장';
    btnDelete.classList.add('d-none');

    const modal = new bootstrap.Modal(modalEl);
    document.getElementById('event-title').value = '';
    document.getElementById('event-start').value = (prefill && prefill.start) ? prefill.start : '';
    document.getElementById('event-end').value   = (prefill && prefill.end)   ? prefill.end   : '';
    document.getElementById('event-memo').value  = '';
    var def = document.querySelector('input[name="category"][value="cat-company"]');
    if (def) def.checked = true;
    modal.show();
  };

  const calendarEl = document.getElementById('calendar');
  const extPanel   = document.getElementById('external-panel');
  const extList    = document.getElementById('external-events');

  // 색상 매핑
  const COLOR_MAP = {
    'cat-company':    '#dbeafe',
    'cat-department': '#dcfce7',
    'cat-project':    '#e0f2fe',
    'cat-vacation':   '#fef3c7',
    'cat-etc':        '#fee2e2',
    'cat-theme':      '#fee2e2',
    'cat-meeting':    '#fee2e2',
    'cat-report':     '#fee2e2',
  };

  // 렌더 시점 스타일 적용
  const paintEvent = (info, bg) => {
    if (!bg) return;
    const main = info.el.querySelector('.fc-event-main') || info.el;
    Object.assign(main.style, {
      backgroundColor: bg,
      color: '#111',
      border: '0',
      borderRadius: '8px',
      boxShadow: '0 1px 3px rgba(0,0,0,.06)',
    });

    const hMain = info.el.querySelector('.fc-event-title-container');
    if (hMain) Object.assign(hMain.style, {
      backgroundColor: bg, color: '#111', border: '0', borderRadius: '8px',
    });

    const listTitle = info.el.querySelector('.fc-list-event-title');
    if (listTitle) {
      listTitle.style.color = '#111';
      const row = info.el.closest('.fc-list-event');
      if (row) row.style.backgroundColor = bg;
    }
  };

  // 시간 문자열 헬퍼 (백틱 제거)
  const toLocalInput = (dateObj) => {
    if (!dateObj) return '';
    // yyyy-MM-ddTHH:mm
    const pad = function(n){ return String(n).padStart(2,'0'); };
    const y = dateObj.getFullYear();
    const m = pad(dateObj.getMonth()+1);
    const d = pad(dateObj.getDate());
    const H = pad(dateObj.getHours());
    const M = pad(dateObj.getMinutes());
    return y + '-' + m + '-' + d + 'T' + H + ':' + M;
  };
  const toIsoSec = (local) => local ? (local.length===16 ? local + ':00' : local) : null;

  const cal = new FullCalendar.Calendar(calendarEl, {
    locale: 'ko',
    initialView: 'dayGridMonth',
    height: 'parent',
    contentHeight: '80vh',
    expandRows: true,
    firstDay: 0,
    nowIndicator: true,
    navLinks: true,
    selectable: true,
    selectMirror: true,
    slotMinTime: '08:00:00',
    slotMaxTime: '20:00:00',
    slotDuration: '00:30:00',
    dayMaxEvents: 2,
    stickyHeaderDates: true,
    editable: true,
    droppable: true,
    timeZone: 'local',
    eventTimeFormat: { hour: '2-digit', minute: '2-digit', meridiem: false },

    customButtons: {
      addEvent: {
        text: '＋ 일정 추가',
        click: () => {
          const today = new Date();
          cal.changeView('timeGridDay', today); // 시간표 보면서 입력
          const start = toLocalInput(today);
          openModal({ start: start });
        }
      },
      toggleExt: {
        text: '외부 이벤트',
        click: () => {
          extPanel.classList.toggle('d-none');
          extPanel.setAttribute('aria-hidden', extPanel.classList.contains('d-none') ? 'true' : 'false');
        }
      }
    },
    headerToolbar: {
      left: 'prev,next today',
      center: 'title',
      right: 'addEvent toggleExt dayGridMonth,timeGridWeek,timeGridDay,listWeek'
    },

    // ✅ DB에서만 로드
    events: "<c:url value='/api/calendar/events'/>",

    // 월뷰 날짜 클릭 시 → 데일리 타임그리드로 전환 후 모달
    dateClick(info) {
      if (cal.view.type === 'dayGridMonth') {
        cal.changeView('timeGridDay', info.date);
      }
      const start = (info.dateStr.length === 10) ? info.dateStr + 'T09:00' : info.dateStr;
      openModal({ start: start });
    },

    // 시간 슬롯 드래그 선택 → 시작/종료 프리필
    select(info){
      const start = toLocalInput(info.start);
      const end   = toLocalInput(info.end);
      openModal({ start: start, end: end });
    },

    // 이벤트 클릭 → 상세보기/수정 모달
    eventClick(arg){
      const ev = arg.event;
      document.getElementById('event-id').value    = (ev.id != null ? String(ev.id) : '');
      document.getElementById('event-title').value = ev.title || '';
      document.getElementById('event-start').value = toLocalInput(ev.start);
      document.getElementById('event-end').value   = toLocalInput(ev.end);
      document.getElementById('event-memo').value  = (ev.extendedProps && ev.extendedProps.memo) ? ev.extendedProps.memo : '';

      const cat = (ev.classNames && ev.classNames.length ? ev.classNames[0] : 'cat-company');
      const r = document.querySelector('input[name="category"][value="' + cat + '"]');
      if (r) r.checked = true;

      btnSave.textContent = '수정';
      btnDelete.classList.remove('d-none');

      const modal = new bootstrap.Modal(modalEl);
      modal.show();
    },

    // 드래그/리사이즈 즉시 저장
    eventDrop: onQuickUpdate,
    eventResize: onQuickUpdate,

    eventMouseEnter(info){ info.el.classList.add('is-hover'); },
    eventMouseLeave(info){ info.el.classList.remove('is-hover'); },

    eventDidMount(info) {
      const cat = (info.event.classNames || []).find(c => COLOR_MAP[c]);
      paintEvent(info, COLOR_MAP[cat]);
    }
  });

  cal.render();

  // 툴바 아래로 외부 패널
  const toolbar = calendarEl.querySelector('.fc-header-toolbar');
  if (toolbar && extPanel) toolbar.insertAdjacentElement('afterend', extPanel);

  // 외부 이벤트 드래그
  if (window.FullCalendar && FullCalendar.Draggable && extList) {
    new FullCalendar.Draggable(extList, {
      itemSelector: '.fc-event',
      eventData: (el) => {
        const cls = el.getAttribute('data-class') || '';
        const title = (el.querySelector('.chip-label') ? el.querySelector('.chip-label').innerText : (el.innerText || '')).trim();
        return { title: title, classNames: cls ? [cls] : [] };
      }
    });
  }

  // 저장/수정 제출
  document.getElementById('forms-event').addEventListener('submit', async (e) => {
    e.preventDefault();
    const f = e.currentTarget;
    f.classList.add('was-validated');
    if (!f.checkValidity()) return;

    const id    = document.getElementById('event-id').value;
    const title = document.getElementById('event-title').value.trim();
    const start = toIsoSec(document.getElementById('event-start').value);
    const end   = toIsoSec(document.getElementById('event-end').value) || null;
    const cat   = (document.querySelector('input[name="category"]:checked') ? document.querySelector('input[name="category"]:checked').value : 'cat-company');
    const memo  = document.getElementById('event-memo').value;

    const csrfToken  = document.querySelector('meta[name="_csrf"]') ? document.querySelector('meta[name="_csrf"]').content : null;
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]') ? document.querySelector('meta[name="_csrf_header"]').content : null;
    const headers = Object.assign({'Content-Type':'application/json'}, (csrfToken && csrfHeader) ? (function(o){ o[csrfHeader]=csrfToken; return o; })({}) : {});

    const base = "<c:url value='/api/calendar/events'/>";
    const url  = id ? (base + '/' + encodeURIComponent(id)) : base;
    const method = id ? 'PUT' : 'POST';

    const res = await fetch(url, { method: method, headers: headers, body: JSON.stringify({ title: title, start: start, end: end, category: cat, memo: memo }) });
    if(!res.ok){ alert(id ? '수정 실패' : '저장 실패'); return; }

    await res.json();
    cal.refetchEvents();

    bootstrap.Modal.getInstance(modalEl).hide();
    f.reset(); f.classList.remove('was-validated');
    // 초기화
    document.getElementById('event-id').value='';
    btnSave.textContent = '저장';
    btnDelete.classList.add('d-none');
  });

  // 삭제
  btnDelete.addEventListener('click', async ()=>{
    const rawId = document.getElementById('event-id').value;
    const id = (rawId == null ? '' : String(rawId)).trim();
    if(!id){ alert('이벤트 ID 없음'); return; }
    if(!confirm('삭제할까요?')) return;

    const csrfToken  = document.querySelector('meta[name="_csrf"]') ? document.querySelector('meta[name="_csrf"]').content : null;
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]') ? document.querySelector('meta[name="_csrf_header"]').content : null;
    const headers = (csrfToken && csrfHeader) ? (function(o){ o[csrfHeader]=csrfToken; return o; })({}) : {};

    const base = "<c:url value='/api/calendar/events'/>";
    const url  = base + '/' + encodeURIComponent(id);

    const res = await fetch(url, { method:'DELETE', headers: headers });
    if(!res.ok){ alert('삭제 실패'); return; }

    cal.refetchEvents();
    bootstrap.Modal.getInstance(modalEl).hide();
  });

  // 드래그/리사이즈 빠른 업데이트
  async function onQuickUpdate(info){
    const ev = info.event;
    if (!ev.id) { console.warn('no id on event', ev); info.revert(); return; }

    const payload = {
      start: ev.start ? ev.start.toISOString().slice(0,19) : null,
      end:   ev.end   ? ev.end.toISOString().slice(0,19)   : null
    };

    const csrfToken  = document.querySelector('meta[name="_csrf"]') ? document.querySelector('meta[name="_csrf"]').content : null;
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]') ? document.querySelector('meta[name="_csrf_header"]').content : null;
    const headers = Object.assign({'Content-Type':'application/json'}, (csrfToken && csrfHeader) ? (function(o){ o[csrfHeader]=csrfToken; return o; })({}) : {});

    const base = "<c:url value='/api/calendar/events'/>";
    const url  = base + '/' + encodeURIComponent(ev.id);

    const res = await fetch(url, { method:'PUT', headers: headers, body: JSON.stringify(payload) });
    if(!res.ok){
      alert('시간 변경 저장 실패');
      info.revert();
      return;
    }
    cal.refetchEvents();
  }

  // 리사이즈 보정
  const fix = () => cal.updateSize();
  window.addEventListener('resize', fix);
  setTimeout(fix, 0);
});
</script>

</body>
</html>
