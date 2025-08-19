<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="<c:url value='/HTML/Admin/src/assets/css/core.css'/>">
<link rel="stylesheet" href="<c:url value='/HTML/Admin/src/assets/css/apps-calendar.css'/>">
<link rel="stylesheet" href="<c:url value='/HTML/Admin/src/assets/vendor/fullcalendar/fullcalendar.min.css'/>">

<style>
/* 메뉴 타이틀 */
.menu h3 {
  font-size: 1.5rem;
  font-weight: bold;
  color: #2c3e50;
  margin-bottom: 1rem;
}
/* 버튼 스타일 */
#btn-new-event {
  background-color: #007bff;
  border: none;
  font-weight: bold;
  transition: 0.3s;
}
#btn-new-event:hover { background-color: #0056b3; }
/* 이벤트 블록 */
.external-event {
  padding: 8px 12px;
  margin: 5px 0;
  border-radius: 6px;
  cursor: grab;
  font-weight: 500;
}
.external-event i { font-size: 12px; margin-right: 8px; }
</style>