<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>캘린더</title>
  <%@ include file="/WEB-INF/views/partials/head-css.jsp" %>
  <link rel="stylesheet" href="<c:url value='/assets/css/custom.css?v=20250819'/>">
</head>
<body>
  <div class="wrapper">
    <jsp:include page="/WEB-INF/views/partials/menu.jsp">
      <jsp:param name="title" value="캘린더"/>
    </jsp:include>

    <div class="page-content">
      <div class="page-container container-fluid">

        <!-- 캘린더 카드 -->
        <div class="row">
          <div class="col-12">
            <div class="card calendar-card">
              <div class="card-body">
                <div id="calendar" aria-label="메인 캘린더"></div>
              </div>
            </div>
          </div>
        </div>

        <!-- 📦 외부 이벤트 패널(부서장용, 초기 숨김 / 툴바 아래로 이동) -->
        <div id="external-panel" class="cal-ext d-none" aria-hidden="true">
          <div class="cal-ext__head">외부 이벤트 (드래그해서 캘린더에 추가)</div>
          <div id="external-events" class="cal-side__list">
            <div class="evt-chip fc-event" data-class="bg-success-subtle" title="드래그해서 캘린더에 놓기">
              <span class="chip-dot chip--green"></span><span class="chip-label">팀 회의</span>
            </div>
            <div class="evt-chip fc-event" data-class="bg-warning-subtle" title="드래그해서 캘린더에 놓기">
              <span class="chip-dot chip--yellow"></span><span class="chip-label">리마인더</span>
            </div>
          </div>
        </div>

      </div><!-- /.page-container -->
      <jsp:include page="/WEB-INF/views/partials/footer.jsp" />
    </div><!-- /.page-content -->
  </div><!-- /.wrapper -->

  <jsp:include page="/WEB-INF/views/partials/customizer.jsp" />
  <jsp:include page="/WEB-INF/views/partials/footer-scripts.jsp" />
  <%-- 필수: fullcalendar/index.global.min.js + interaction.global.min.js + bootstrap.bundle.min.js --%>

  <!-- 📌 일정/메모 모달 -->
  <div class="modal fade" id="event-modal" tabindex="-1" aria-labelledby="event-modal-title" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <form class="needs-validation" id="forms-event" novalidate>
          <div class="modal-header">
            <h5 class="modal-title" id="event-modal-title">새 항목 추가</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
          </div>

          <div class="modal-body">
            <input type="hidden" id="event-visibility" name="visibility" value="PERSONAL"/><!-- 기본: 개인 -->

            <div class="mb-3">
              <label class="form-label" for="event-title">제목</label>
              <input class="form-control" id="event-title" name="title" type="text" placeholder="예: 팀 회의 / 개인 메모" required />
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

            <!-- 색상 -->
            <div class="mb-3">
              <label class="form-label d-block mb-1">색상</label>
              <div class="color-swatches">
                <label class="swatch"><input type="radio" name="category" value="bg-primary" checked /><span class="blob blob--blue"></span> 파랑</label>
                <label class="swatch"><input type="radio" name="category" value="bg-success" /><span class="blob blob--green"></span> 초록</label>
                <label class="swatch"><input type="radio" name="category" value="bg-warning" /><span class="blob blob--yellow"></span> 노랑</label>
                <label class="swatch"><input type="radio" name="category" value="bg-danger" /><span class="blob blob--red"></span> 빨강</label>
              </div>
            </div>

            <!-- 🔐 부서장만 보이는 가시범위 -->
            <div id="visibility-group" class="mb-3 d-none">
              <label class="form-label d-block mb-1">가시 범위</label>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="vscope" id="vis-company" value="COMPANY">
                <label class="form-check-label" for="vis-company">회사 전체</label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="vscope" id="vis-dept" value="DEPT" checked>
                <label class="form-check-label" for="vis-dept">부서 공개</label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="vscope" id="vis-deptvac" value="DEPT_VACATION">
                <label class="form-check-label" for="vis-deptvac">휴가(부서)</label>
              </div>
            </div>

            <div class="mb-2">
              <label class="form-label" for="event-memo">설명</label>
              <textarea class="form-control" id="event-memo" name="memo" rows="3" placeholder="메모를 입력하세요"></textarea>
            </div>
          </div>

          <div class="modal-footer">
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">닫기</button>
            <button type="submit" class="btn btn-primary" id="btn-save-event">저장</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
  document.addEventListener('DOMContentLoaded', () => {
    /* ====== 현재 로그인 사용자 정보 (세션에서 바인딩) ====== */
    const CURRENT_USER = {
      id:    '<c:out value="${sessionScope.user.id}"/>',
      name:  '<c:out value="${sessionScope.user.name}"/>',
      role:  '<c:out value="${sessionScope.user.role}"/>',       // "DEPT_HEAD" | "USER" | "ADMIN"
      deptId:'<c:out value="${sessionScope.user.deptId}"/>'      // 부서 ID
    };
    const isDeptHead = (CURRENT_USER.role === 'DEPT_HEAD' || CURRENT_USER.role === 'ADMIN');

    /* ====== 모달 핸들러 ====== */
    const $modalEl   = document.getElementById('event-modal');
    const $form      = document.getElementById('forms-event');
    const $title     = document.getElementById('event-title');
    const $start     = document.getElementById('event-start');
    const $end       = document.getElementById('event-end');
    const $memo      = document.getElementById('event-memo');
    const $visHidden = document.getElementById('event-visibility'); // 실제 제출값
    const $visGroup  = document.getElementById('visibility-group'); // 라디오 그룹(부서장용)

    const openModal = (prefill) => {
      const modal = new bootstrap.Modal($modalEl);
      $form.classList.remove('was-validated');
      $title.value = '';
      $start.value = prefill?.start || '';
      $end.value   = '';
      $memo.value  = '';

      if (isDeptHead) {
        // 부서장: 가시범위 라디오 보이기, 기본 부서 공개
        $visGroup.classList.remove('d-none');
        document.getElementById('vis-dept').checked = true;
        $visHidden.value = 'DEPT';
      } else {
        // 일반: 개인 메모 고정
        $visGroup.classList.add('d-none');
        $visHidden.value = 'PERSONAL';
      }
      modal.show();
    };

    /* ====== 캘린더 ====== */
    const calendarEl = document.getElementById('calendar');
    const extPanel   = document.getElementById('external-panel');
    const extList    = document.getElementById('external-events');

    // 헤더 버튼 문자열(권한 따라 다름)
    const rightButtons = isDeptHead
      ? 'addEvent toggleExt dayGridMonth,timeGridWeek,timeGridDay,listWeek'
      : 'addEvent dayGridMonth,timeGridWeek,timeGridDay,listWeek';

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
      dayMaxEvents: 2,
      stickyHeaderDates: true,
      editable: isDeptHead,   // 부서장만 드래그/리사이즈 허용(원하면 세분화)
      droppable: isDeptHead,  // 외부 이벤트 드롭도 부서장만

      eventTimeFormat: { hour:'2-digit', minute:'2-digit', meridiem:false },

      /* 🎛 툴바 버튼 */
      customButtons: {
        addEvent: {
          text: isDeptHead ? '＋ 일정 추가' : '＋ 메모',
          click: () => openModal()
        },
        toggleExt: {
          text: '외부 이벤트',
          click: () => {
            if (!isDeptHead || !extPanel) return;
            extPanel.classList.toggle('d-none');
            const hidden = extPanel.classList.contains('d-none');
            extPanel.setAttribute('aria-hidden', hidden ? 'true' : 'false');
            cal.updateSize();
          }
        }
      },
      headerToolbar: {
        left:   'prev,next today',
        center: 'title',
        right:  rightButtons
      },

      /* 📥 서버에서 내 권한에 맞는 이벤트만 가져오기 */
      events: async (info, success, failure) => {
        try {
          const qs = new URLSearchParams({
            start: info.startStr,
            end:   info.endStr
          });
          const res = await fetch('<c:url value="/api/calendar/events"/>' + '?' + qs.toString(), {
            credentials: 'same-origin'
          });
          const data = await res.json(); // [{id,title,start,end,extendedProps:{visibility,deptId,ownerId,memo}, classNames:[]}, ...]

          // 안전망: 프론트에서도 한 번 더 필터
          const filtered = data.filter(ev => canView(ev, CURRENT_USER));
          success(filtered);
        } catch (e) {
          console.error(e);
          failure(e);
        }
      },

      /* 날짜 클릭 → 새로 추가 */
      dateClick(info) {
        const start = (info.dateStr.length === 10) ? info.dateStr + 'T09:00' : info.dateStr;
        openModal({ start });
      },

      /* 표시 직전 후처리(아이콘/배지 등 필요 시) */
      eventDidMount(arg) {
        const vis = arg.event.extendedProps?.visibility;
        if (vis === 'PERSONAL') {
          arg.el.setAttribute('title', '개인 메모');
        } else if (vis === 'DEPT_VACATION') {
          arg.el.setAttribute('title', '부서 휴가');
        }
      }
    });

    cal.render();

    // 툴바 아래로 외부 이벤트 패널 이동(부서장 전용)
    if (isDeptHead) {
      const toolbar = calendarEl.querySelector('.fc-header-toolbar');
      if (toolbar && extPanel) toolbar.insertAdjacentElement('afterend', extPanel);

      // 외부 이벤트 드래그 소스
      if (window.FullCalendar && FullCalendar.Draggable && extList) {
        new FullCalendar.Draggable(extList, {
          itemSelector: '.fc-event',
          eventData: (el) => {
            const cls = el.getAttribute('data-class') || '';
            const title = (el.querySelector('.chip-label')?.innerText || el.innerText || '').trim();
            return { title, classNames: cls ? [cls] : [] };
          }
        });
      }
    } else {
      // 일반 사용자면 외부 이벤트 패널 자체 숨김(보안은 서버에서 다시 체크)
      extPanel?.classList.add('d-none');
    }

    /* ====== 저장 → 서버 POST 후 캘린더 추가 ====== */
    $form.addEventListener('submit', async (e) => {
      e.preventDefault();
      $form.classList.add('was-validated');
      if (!$form.checkValidity()) return;

      const payload = {
        title: $title.value.trim(),
        start: $start.value,
        end:   $end.value || null,
        memo:  $memo.value,
        // 색상 클래스 (FullCalendar classNames 사용)
        classNames: [(document.querySelector('input[name="category"]:checked')?.value) || 'bg-primary'],
        // 가시성 & 메타
        visibility: isDeptHead ? (document.querySelector('input[name="vscope"]:checked')?.value || 'DEPT') : 'PERSONAL',
        deptId: CURRENT_USER.deptId,
        ownerId: CURRENT_USER.id
      };

      // 일반 사용자가 회사/부서/휴가 선택 못 하도록 이중보호
      if (!isDeptHead) payload.visibility = 'PERSONAL';

      try {
        // 서버 저장 (반드시 서버에서 권한/가시성 검증)
        const res = await fetch('<c:url value="/api/calendar/events"/>', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          credentials: 'same-origin',
          body: JSON.stringify(payload)
        });
        if (!res.ok) throw new Error('저장 실패');

        const saved = await res.json(); // 서버가 id/정규화된 필드로 응답
        // 즉시 렌더 반영
        cal.addEvent({
          id: saved.id,
          title: saved.title,
          start: saved.start,
          end:   saved.end,
          classNames: saved.classNames || payload.classNames,
          extendedProps: {
            memo: saved.memo ?? payload.memo,
            visibility: saved.visibility ?? payload.visibility,
            deptId: saved.deptId ?? payload.deptId,
            ownerId: saved.ownerId ?? payload.ownerId
          }
        });

        bootstrap.Modal.getInstance($modalEl).hide();
        $form.reset();
        $form.classList.remove('was-validated');
      } catch (err) {
        console.error(err);
        alert('저장 중 오류가 발생했습니다.');
      }
    });

    /* ====== 프론트 가시성 필터 ====== */
    function canView(ev, user) {
      const vis   = ev.extendedProps?.visibility || ev.visibility;
      const dept  = ev.extendedProps?.deptId     || ev.deptId;
      const owner = ev.extendedProps?.ownerId    || ev.ownerId;

      switch (vis) {
        case 'COMPANY':         return true;                              // 모두
        case 'DEPT':            return dept && user.deptId && dept === user.deptId;
        case 'DEPT_VACATION':   return dept && user.deptId && dept === user.deptId;
        case 'PERSONAL':        return owner && user.id && owner == user.id; // 본인만
        default:                return false; // 정의되지 않은 건 숨김
      }
    }

    // 리사이즈 보정
    const fixSize = () => cal.updateSize();
    window.addEventListener('resize', fixSize);
    setTimeout(fixSize, 0);
  });
  </script>
</body>
</html>
