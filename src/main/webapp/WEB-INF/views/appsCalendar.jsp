<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>캘린더</title>

  <%@ include file="/WEB-INF/views/partials/head-css.jsp" %>

  <!-- FullCalendar Core -->
  <script src="<c:url value='/HTML/Admin/dist/assets/vendor/fullcalendar/index.global.min.js'/>"></script>

  <style>
    /* 캘린더 스타일 */
    #calendar .fc a { color:#111 !important; text-decoration:none !important; }
    
    /* 일정 타입별 색상 */
    .cat-company { background-color: #e5e7eb !important; color: #111 !important; }
    .cat-department { background-color: #dcfce7 !important; color: #111 !important; }
    .cat-project { background-color: #e9d5ff !important; color: #111 !important; }
    .cat-vacation { background-color: #d1fae5 !important; color: #111 !important; }
    .cat-personal { background-color: #dbeafe !important; color: #111 !important; }
    
    .fc-day-today {
      background-color: #fef3c7 !important;
    }
    
    .filter-container {
      display: flex;
      gap: 1rem;
      margin-bottom: 1rem;
      padding: 0.5rem;
      background: #f9fafb;
      border-radius: 0.5rem;
    }
    
    .filter-item {
      display: flex;
      align-items: center;
      gap: 0.25rem;
    }
    
    .filter-dot {
      width: 12px;
      height: 12px;
      border-radius: 50%;
      display: inline-block;
    }
    
    #today-panel {
      position: fixed;
      top: 20px;
      right: 20px;
      width: 300px;
      z-index: 1000;
    }
    
    .fc-event {
      cursor: pointer;
    }
    
    .fc-event:hover {
      opacity: 0.8;
    }
    
    /* 상태 알림 */
    .status-alert {
      position: fixed;
      top: 10px;
      left: 50%;
      transform: translateX(-50%);
      z-index: 2000;
      padding: 0.5rem 1rem;
      border-radius: 0.25rem;
      font-size: 0.875rem;
    }
    
    .status-error { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }
    .status-success { background: #f0fdf4; color: #16a34a; border: 1px solid #bbf7d0; }
    .status-info { background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe; }
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

        <!-- 상태 알림 -->
        <div id="status-alert" class="status-alert d-none"></div>

        <!-- 필터 및 권한 버튼 -->
        <div class="col-12 mb-3">
          <div class="card">
            <div class="card-body">
              <div class="filter-container">
                <div class="filter-item">
                  <input type="checkbox" id="filter-company" value="company" checked>
                  <label for="filter-company"><span class="filter-dot" style="background:#e5e7eb"></span> 회사</label>
                </div>
                <div class="filter-item">
                  <input type="checkbox" id="filter-department" value="department" checked>
                  <label for="filter-department"><span class="filter-dot" style="background:#dcfce7"></span> 부서</label>
                </div>
                <div class="filter-item">
                  <input type="checkbox" id="filter-project" value="project" checked>
                  <label for="filter-project"><span class="filter-dot" style="background:#e9d5ff"></span> 프로젝트</label>
                </div>
                <div class="filter-item">
                  <input type="checkbox" id="filter-vacation" value="vacation" checked>
                  <label for="filter-vacation"><span class="filter-dot" style="background:#d1fae5"></span> 휴가</label>
                </div>
                <div class="filter-item">
                  <input type="checkbox" id="filter-personal" value="personal" checked>
                  <label for="filter-personal"><span class="filter-dot" style="background:#dbeafe"></span> 개인</label>
                </div>
              </div>
              
              <div class="d-flex gap-2 mt-2">
                <button class="btn btn-primary btn-sm" id="btn-add-personal">
                  <i class="bi bi-plus-circle"></i> 개인 일정 추가
                </button>
                
                <c:if test="${isManagementSupportManager}">
                  <button class="btn btn-secondary btn-sm" id="btn-add-company">
                    <i class="bi bi-building"></i> 회사 일정 추가
                  </button>
                </c:if>
                
                <c:if test="${isDepartmentManager}">
                  <button class="btn btn-success btn-sm" id="btn-add-department">
                    <i class="bi bi-people"></i> 부서 일정 추가
                  </button>
                </c:if>
                
                <c:if test="${isProjectManager}">
                  <button class="btn btn-info btn-sm" id="btn-add-project">
                    <i class="bi bi-diagram-3"></i> 프로젝트 일정 추가
                  </button>
                </c:if>
                
                <button class="btn btn-outline-primary btn-sm ms-auto" id="btn-today-schedule">
                  <i class="bi bi-calendar-day"></i> 오늘의 일정
                </button>
                
                <button class="btn btn-outline-success btn-sm" onclick="location.href='/calendar/vacation'">
                  <i class="bi bi-calendar-week"></i> 휴가 현황
                </button>
                
                <c:if test="${isManagementSupportManager || isDepartmentManager || isProjectManager}">
                  <button class="btn btn-outline-dark btn-sm" onclick="location.href='/calendar/management'">
                    <i class="bi bi-gear"></i> 일정 관리
                  </button>
                </c:if>
              </div>
            </div>
          </div>
        </div>

        <div class="col-12">
          <div class="card calendar-card">
            <div class="card-body">
              <div id="calendar" aria-label="메인 캘린더"></div>
            </div>
          </div>
        </div>

        <div id="today-panel" class="d-none">
          <div class="card">
            <div class="card-header">
              <h5><i class="bi bi-calendar-day"></i> 오늘의 일정</h5>
              <button type="button" class="btn-close float-end" id="btn-close-today"></button>
            </div>
            <div class="card-body" id="today-schedule-list"></div>
          </div>
        </div>

      </div>
      <jsp:include page="/WEB-INF/views/partials/footer.jsp" />
    </div>
  </div>

  <!-- 일정 등록/수정 모달 -->
  <div class="modal fade" id="event-modal" tabindex="-1">
    <div class="modal-dialog">
      <div class="modal-content">
        <form class="needs-validation" id="forms-event" novalidate>
          <div class="modal-header">
            <h5 class="modal-title" id="event-modal-title">새 일정 추가</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <input type="hidden" id="event-id" />
            <div class="mb-3">
              <label class="form-label">일정 종류</label>
              <select class="form-select" id="event-type" required>
                <option value="personal">개인 일정</option>
                <c:if test="${isManagementSupportManager}">
                  <option value="company">회사 일정</option>
                </c:if>
                <c:if test="${isDepartmentManager}">
                  <option value="department">부서 일정</option>
                </c:if>
                <c:if test="${isProjectManager}">
                  <option value="project">프로젝트 일정</option>
                </c:if>
              </select>
            </div>
            <div class="mb-3 d-none" id="dept-select-container">
              <label class="form-label">부서 선택</label>
              <select class="form-select" id="event-department">
                <c:forEach items="${departments}" var="dept">
                  <option value="${dept.deptId}">${dept.dateName}</option>
                </c:forEach>
              </select>
            </div>
            <div class="mb-3">
              <label class="form-label" for="event-title">일정 제목</label>
              <input class="form-control" id="event-title" required />
            </div>
            <div class="row">
              <div class="col-md-6 mb-3">
                <label class="form-label" for="event-start">시작</label>
                <input class="form-control" id="event-start" type="datetime-local" required />
              </div>
              <div class="col-md-6 mb-3">
                <label class="form-label" for="event-end">종료</label>
                <input class="form-control" id="event-end" type="datetime-local" />
              </div>
            </div>
            <div class="mb-2">
              <label class="form-label" for="event-memo">설명</label>
              <textarea class="form-control" id="event-memo"></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-outline-danger d-none" id="btn-delete">삭제</button>
            <button type="submit" class="btn btn-primary" id="btn-save-event">저장</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- 일정 상세 보기 모달 -->
  <div class="modal fade" id="detail-modal" tabindex="-1">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">일정 상세</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body" id="detail-content"></div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
// COLOR_MAP 정의
var COLOR_MAP = {
  'company': '#e5e7eb',
  'department': '#dcfce7', 
  'project': '#e9d5ff',
  'vacation': '#d1fae5',
  'personal': '#dbeafe'
};

// CSRF 토큰 가져오기
var csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content') || '';
var csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content') || 'X-Requested-With';

var calendar;

// 상태 메시지 표시 함수
function showStatus(message, type, duration) {
  type = type || 'info';
  duration = duration || 3000;
  
  var statusAlert = document.getElementById('status-alert');
  statusAlert.textContent = message;
  statusAlert.className = 'status-alert status-' + type;
  statusAlert.classList.remove('d-none');
  
  setTimeout(function() {
    statusAlert.classList.add('d-none');
  }, duration);
}

document.addEventListener('DOMContentLoaded', function() {
  var calendarEl = document.getElementById('calendar');
  
  calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: 'dayGridMonth',
    locale: 'ko',
    headerToolbar: {
      left: 'prev,next today',
      center: 'title',
      right: 'dayGridMonth,timeGridWeek,timeGridDay'
    },
    height: 'auto',
    
    // 이벤트 소스 설정
    events: function(fetchInfo, successCallback, failureCallback) {
      console.log('캘린더 이벤트 로드 시작');
      
      // 체크된 필터 타입들 수집
      var checkedTypes = [];
      document.querySelectorAll('[id^="filter-"]:checked').forEach(function(checkbox) {
        checkedTypes.push(checkbox.value);
      });
      
      // 실제 DB 데이터 조회
      var headers = {
        'Content-Type': 'application/json'
      };
      
      // CSRF 헤더 추가
      if (csrfHeader && csrfToken) {
        headers[csrfHeader] = csrfToken;
      }
      
      fetch('/api/calendar/events/range', {
        method: 'POST',
        headers: headers,
        body: JSON.stringify({
          start: fetchInfo.startStr,
          end: fetchInfo.endStr,
          types: checkedTypes
        })
      })
      .then(function(response) {
        console.log('API 응답 상태:', response.status);
        if (!response.ok) {
          throw new Error('HTTP ' + response.status);
        }
        return response.json();
      })
      .then(function(events) {
        console.log('DB에서 가져온 이벤트들:', events);
        
        var fullCalendarEvents = events.map(function(event) {
          return {
            id: event.id,
            title: event.title,
            start: event.start,
            end: event.end,
            allDay: event.allDay,
            backgroundColor: COLOR_MAP[event.type] || '#dbeafe',
            borderColor: COLOR_MAP[event.type] || '#dbeafe',
            textColor: '#111',
            classNames: ['cat-' + event.type],
            extendedProps: {
              type: event.type,
              memo: event.memo,
              creator: event.creator,
              creatorName: event.creatorName,
              canModify: event.canModify || false
            }
          };
        });
        
        console.log('FullCalendar 형식으로 변환된 이벤트들:', fullCalendarEvents);
        successCallback(fullCalendarEvents);
      })
      .catch(function(error) {
        console.error('이벤트 로드 실패:', error);
        showStatus('일정을 불러오는데 실패했습니다.', 'error');
        
        // 에러 시 빈 배열 반환
        successCallback([]);
      });
    },
    
    // 이벤트 클릭
    eventClick: function(info) {
      showEventDetail(info.event);
    },
    
    // 날짜 클릭 (새 일정 추가)
    dateClick: function(info) {
      openEventModal('add', info.dateStr);
    },
    
    editable: false
  });
  
  calendar.render();
  
  // 필터 체크박스 이벤트
  document.querySelectorAll('[id^="filter-"]').forEach(function(checkbox) {
    checkbox.addEventListener('change', function() {
      calendar.refetchEvents();
    });
  });
  
  // 버튼 이벤트 리스너
  setupButtonEvents();
});

// 버튼 이벤트 설정
function setupButtonEvents() {
  // 개인 일정 추가
  var btnAddPersonal = document.getElementById('btn-add-personal');
  if (btnAddPersonal) {
    btnAddPersonal.addEventListener('click', function() {
      openEventModal('add', null, 'personal');
    });
  }
  
  // 회사 일정 추가
  var btnAddCompany = document.getElementById('btn-add-company');
  if (btnAddCompany) {
    btnAddCompany.addEventListener('click', function() {
      openEventModal('add', null, 'company');
    });
  }
  
  // 부서 일정 추가
  var btnAddDepartment = document.getElementById('btn-add-department');
  if (btnAddDepartment) {
    btnAddDepartment.addEventListener('click', function() {
      openEventModal('add', null, 'department');
    });
  }
  
  // 프로젝트 일정 추가
  var btnAddProject = document.getElementById('btn-add-project');
  if (btnAddProject) {
    btnAddProject.addEventListener('click', function() {
      openEventModal('add', null, 'project');
    });
  }
  
  // 오늘의 일정
  var btnTodaySchedule = document.getElementById('btn-today-schedule');
  if (btnTodaySchedule) {
    btnTodaySchedule.addEventListener('click', function() {
      showTodaySchedule();
    });
  }
  
  // 오늘 일정 패널 닫기
  var btnCloseToday = document.getElementById('btn-close-today');
  if (btnCloseToday) {
    btnCloseToday.addEventListener('click', function() {
      document.getElementById('today-panel').classList.add('d-none');
    });
  }
  
  // 이벤트 타입 변경시 부서 선택 표시/숨김
  var eventType = document.getElementById('event-type');
  if (eventType) {
    eventType.addEventListener('change', function() {
      var deptContainer = document.getElementById('dept-select-container');
      if (this.value === 'department') {
        deptContainer.classList.remove('d-none');
      } else {
        deptContainer.classList.add('d-none');
      }
    });
  }
  
  // 폼 제출
  var formsEvent = document.getElementById('forms-event');
  if (formsEvent) {
    formsEvent.addEventListener('submit', function(e) {
      e.preventDefault();
      saveEvent();
    });
  }
  
  // 삭제 버튼
  var btnDelete = document.getElementById('btn-delete');
  if (btnDelete) {
    btnDelete.addEventListener('click', function() {
      deleteEvent();
    });
  }
}

// 이벤트 모달 열기
function openEventModal(mode, date, type) {
  var modal = new bootstrap.Modal(document.getElementById('event-modal'));
  var form = document.getElementById('forms-event');
  
  // 폼 초기화
  form.reset();
  document.getElementById('event-id').value = '';
  
  if (mode === 'add') {
    document.getElementById('event-modal-title').textContent = '새 일정 추가';
    document.getElementById('btn-delete').classList.add('d-none');
    
    if (date) {
      document.getElementById('event-start').value = date + 'T09:00';
      document.getElementById('event-end').value = date + 'T10:00';
    }
    
    if (type) {
      document.getElementById('event-type').value = type;
      if (type === 'department') {
        document.getElementById('dept-select-container').classList.remove('d-none');
      }
    }
  }
  
  modal.show();
}

// 이벤트 수정 모달 열기
function editEvent(eventId) {
  fetch('/api/calendar/events/' + eventId, {
    headers: {
      [csrfHeader]: csrfToken
    }
  })
  .then(function(response) {
    if (!response.ok) {
      throw new Error('HTTP ' + response.status);
    }
    return response.json();
  })
  .then(function(data) {
    // 권한 체크
    if (!data.canModify) {
      showStatus('이 일정을 수정할 권한이 없습니다.', 'error');
      return;
    }
    
    document.getElementById('event-modal-title').textContent = '일정 수정';
    document.getElementById('event-id').value = data.id;
    document.getElementById('event-type').value = data.type;
    document.getElementById('event-title').value = data.title;
    document.getElementById('event-start').value = data.start.substring(0, 16);
    document.getElementById('event-end').value = data.end ? data.end.substring(0, 16) : '';
    document.getElementById('event-memo').value = data.memo || '';
    
    if (data.type === 'department') {
      document.getElementById('dept-select-container').classList.remove('d-none');
      if (data.departmentId) {
        document.getElementById('event-department').value = data.departmentId;
      }
    }
    
    document.getElementById('btn-delete').classList.remove('d-none');
    
    // 상세 모달 닫기
    var detailModal = bootstrap.Modal.getInstance(document.getElementById('detail-modal'));
    if (detailModal) detailModal.hide();
    
    // 편집 모달 열기
    new bootstrap.Modal(document.getElementById('event-modal')).show();
  })
  .catch(function(error) {
    console.error('이벤트 로드 실패:', error);
    showStatus('일정을 불러올 수 없습니다.', 'error');
  });
}

// 이벤트 저장
function saveEvent() {
  var eventId = document.getElementById('event-id').value;
  var isEdit = eventId !== '';
  
  var eventData = {
		  type: document.getElementById('event-type').value,
		  title: document.getElementById('event-title').value.trim(),
		  start: document.getElementById('event-start').value,
		  end: document.getElementById('event-end').value,
		  memo: document.getElementById('event-memo').value.trim()
		};

		// 부서 일정일 경우에만 departmentId 추가
		if (eventData.type === 'department') {
		  eventData.departmentId = document.getElementById('event-department').value;
		}
  
  // 유효성 검사
  if (!eventData.title) {
    showStatus('일정 제목을 입력해주세요.', 'error');
    return;
  }
  
  if (eventData.end && eventData.start > eventData.end) {
    showStatus('종료 시간이 시작 시간보다 빠를 수 없습니다.', 'error');
    return;
  }
  
  var url = isEdit ? '/api/calendar/events/' + eventId : '/api/calendar/events';
  var method = isEdit ? 'PUT' : 'POST';
  
  fetch(url, {
    method: method,
    headers: {
      'Content-Type': 'application/json',
      [csrfHeader]: csrfToken
    },
    body: JSON.stringify(eventData)
  })
  .then(function(response) {
    if (response.ok) {
      return response.json();
    }
    throw new Error('저장 실패');
  })
  .then(function(data) {
    calendar.refetchEvents();
    bootstrap.Modal.getInstance(document.getElementById('event-modal')).hide();
    showStatus(isEdit ? '일정이 수정되었습니다.' : '일정이 추가되었습니다.', 'success');
  })
  .catch(function(error) {
    console.error('저장 실패:', error);
    showStatus('일정 저장에 실패했습니다.', 'error');
  });
}

// 이벤트 삭제
function deleteEvent() {
  var eventId = document.getElementById('event-id').value;
  
  if (confirm('정말로 이 일정을 삭제하시겠습니까?')) {
    fetch('/api/calendar/events/' + eventId, {
      method: 'DELETE',
      headers: {
        [csrfHeader]: csrfToken
      }
    })
    .then(function(response) {
      if (response.ok) {
        calendar.refetchEvents();
        bootstrap.Modal.getInstance(document.getElementById('event-modal')).hide();
        showStatus('일정이 삭제되었습니다.', 'success');
      } else {
        throw new Error('삭제 실패');
      }
    })
    .catch(function(error) {
      console.error('삭제 실패:', error);
      showStatus('일정 삭제에 실패했습니다.', 'error');
    });
  }
}

// 이벤트 상세 보기 - 개선된 버전
function showEventDetail(event) {
  fetch('/api/calendar/events/' + event.id, {
    headers: {
      [csrfHeader]: csrfToken
    }
  })
  .then(function(response) {
    if (!response.ok) {
      throw new Error('HTTP ' + response.status);
    }
    return response.json();
  })
  .then(function(data) {
    var content = '<div class="mb-3">';
    content += '<span class="badge" style="background:' + COLOR_MAP[data.type] + ';color:#111">';
    content += getTypeName(data.type);
    content += '</span>';
    if (data.canModify) {
      content += '<span class="badge bg-warning text-dark ms-1">수정 가능</span>';
    }
    content += '</div>';
    content += '<h5>' + data.title + '</h5>';
    content += '<p class="text-muted"><i class="bi bi-calendar"></i> ';
    content += data.allDay ? '종일' : formatDateTime(data.start) + ' ~ ' + formatDateTime(data.end);
    content += '</p>';
    if (data.memo) {
      content += '<p>' + data.memo + '</p>';
    }
    if (data.department) {
      content += '<p><i class="bi bi-people"></i> ' + data.department + '</p>';
    }
    content += '<hr>';
    content += '<small>등록자: ' + (data.creatorName || '알 수 없음') + '</small>';
    content += '<div class="mt-3">';
    if (data.canModify) {
      content += '<button class="btn btn-primary btn-sm me-2" onclick="editEvent(' + data.id + ')">수정</button>';
    }
    content += '<button class="btn btn-secondary btn-sm" data-bs-dismiss="modal">닫기</button>';
    content += '</div>';
    
    document.getElementById('detail-content').innerHTML = content;
    new bootstrap.Modal(document.getElementById('detail-modal')).show();
  })
  .catch(function(error) {
    console.error('상세 정보 로드 실패:', error);
    showStatus('상세 정보를 불러올 수 없습니다.', 'error');
  });
}

// 오늘의 일정 표시
function showTodaySchedule() {
  fetch('/api/calendar/events/today', {
    headers: {
      [csrfHeader]: csrfToken
    }
  })
  .then(function(response) {
    if (!response.ok) {
      throw new Error('HTTP ' + response.status);
    }
    return response.json();
  })
  .then(function(events) {
    var scheduleList = document.getElementById('today-schedule-list');
    
    if (events.length === 0) {
      scheduleList.innerHTML = '<p class="text-muted">오늘 일정이 없습니다.</p>';
    } else {
      var eventHtml = '';
      events.forEach(function(event) {
        eventHtml += '<div class="border-bottom pb-2 mb-2">';
        eventHtml += '<div class="d-flex justify-content-between align-items-start">';
        eventHtml += '<div>';
        eventHtml += '<span class="badge" style="background:' + COLOR_MAP[event.type] + ';color:#111">';
        eventHtml += getTypeName(event.type);
        eventHtml += '</span>';
        eventHtml += '<h6 class="mt-1">' + event.title + '</h6>';
        eventHtml += '<small class="text-muted">';
        eventHtml += event.allDay ? '종일' : formatDateTime(event.start) + ' ~ ' + formatDateTime(event.end);
        eventHtml += '</small>';
        if (event.creatorName) {
          eventHtml += '<br><small class="text-muted">등록자: ' + event.creatorName + '</small>';
        }
        eventHtml += '</div>';
        eventHtml += '</div>';
        eventHtml += '</div>';
      });
      scheduleList.innerHTML = eventHtml;
    }
    
    document.getElementById('today-panel').classList.remove('d-none');
  })
  .catch(function(error) {
    console.error('오늘 일정 로드 실패:', error);
    showStatus('오늘 일정을 불러올 수 없습니다.', 'error');
    // 에러 시에도 패널은 열어서 빈 상태 표시
    document.getElementById('today-schedule-list').innerHTML = '<p class="text-muted">오늘 일정을 불러올 수 없습니다.</p>';
    document.getElementById('today-panel').classList.remove('d-none');
  });
}

// 타입 이름 변환
function getTypeName(type) {
  var map = { 
    company: '회사', 
    department: '부서', 
    project: '프로젝트', 
    vacation: '휴가', 
    personal: '개인' 
  };
  return map[type] || type;
}

// 날짜시간 포맷팅
function formatDateTime(dateTimeStr) {
  if (!dateTimeStr) return '';
  var date = new Date(dateTimeStr);
  return date.toLocaleString('ko-KR', {
    month: 'numeric',
    day: 'numeric',
    hour: 'numeric',
    minute: '2-digit',
    hour12: false
  });
}
</script>
</body>
</html>