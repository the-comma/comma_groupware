<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<!-- Vendor css -->
    <link href= "<c:url value='/HTML/Admin/dist/assets/css/vendor.min.css'/>" rel="stylesheet" type="text/css" />

    <!-- App css -->
    <link href= "<c:url value='/HTML/Admin/dist/assets/css/app.min.css'/>"  rel="stylesheet" type="text/css" id="app-style" />

    <!-- Icons css -->
    <link href= "<c:url value='/HTML/Admin/dist/assets/css/icons.min.css'/>" rel="stylesheet" type="text/css" />

   	<!-- App favicon -->
	<link rel="shortcut icon" href="/HTML/Admin/dist/assets/images/favicon.ico">

	<!-- config -->
	<link href= "<c:url value='/HTML/Admin/dist/assets/js/config.js'/>" rel="stylesheet" type="text/css" />
	
<meta charset="UTF-8">
<title>타이틀</title>
</head>
<body>
	    <!-- Begin page -->
    <div class="wrapper">

	<!-- Menu -->
	<%@ include file="/HTML/Admin/src/partials/sidenav.html" %>
	
	<c:choose>
	  <c:when test="${not empty title}">
	    <jsp:include page="/HTML/Admin/src/partials/topbar.html">
	      <jsp:param name="topbarTitle" value="${title}" />
	    </jsp:include>
	  </c:when>
	  <c:otherwise>
	    <%@ include file="/HTML/Admin/src/partials/topbar.html" %>
	  </c:otherwise>
	</c:choose>
	
        <div class="page-content">

            <div class="page-container">
            
            	<div class="container">
            
            
            	</div>
            	
            	<%@ include file="/HTML/Admin/src/partials/footer.html" %>
            </div>
       	</div>
       	
   	<%@ include file="/HTML/Admin/src/partials/customizer.html" %>
    <%@ include file="/HTML/Admin/src/partials/footer-scripts.html" %>
</body>
</html>