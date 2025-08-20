<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 공통 CSS -->
<link rel="stylesheet" href="<c:url value='/HTML/Admin/dist/assets/css/core.css'/>">
<link rel="stylesheet" href="<c:url value='/HTML/Admin/dist/assets/css/apps-calendar.css'/>">

<!-- FullCalendar: 검증은 CDN으로 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/main.min.css">
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.js"></script>

<!-- Bootstrap & Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<!-- Custom CSS: 반드시 맨 마지막 -->
<link rel="stylesheet" href="<c:url value='/HTML/Admin/dist/assets/css/custom.css'/>?v=<%=System.currentTimeMillis()%>">

