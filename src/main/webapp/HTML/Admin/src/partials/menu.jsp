<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Menu -->
<%@ include file="sidenav.html" %>

<c:choose>
  <c:when test="${not empty title}">
    <jsp:include page="topbar.html">
      <jsp:param name="topbarTitle" value="${title}" />
    </jsp:include>
  </c:when>
  <c:otherwise>
    <%@ include file="topbar.html" %>
  </c:otherwise>
</c:choose>

<%-- 필요하면 수평 네비게이션 활성화
<%@ include file="/WEB-INF/views/partials/horizontal-nav.jsp" %>
--%>
