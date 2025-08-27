<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Core CSS -->
<link rel="stylesheet" href="<c:url value='/HTML/Admin/dist/assets/css/core.css'/>">
<link rel="stylesheet" href="<c:url value='/HTML/Admin/dist/assets/css/apps-calendar.css'/>">

<!-- FullCalendar CSS -->
<link rel="stylesheet" href="<c:url value='/HTML/Admin/dist/assets/vendor/fullcalendar/index.global.min.css'/>">

<!-- Bootstrap & Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<!-- Custom CSS (캐시버스터 안전하게) -->
<c:url var="customCssUrl" value="/HTML/Admin/dist/assets/css/custom.css">
  <c:param name="v" value="1.0"/>
</c:url>
<link rel="stylesheet" href="${customCssUrl}">
