<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <title>인사관리</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        th {
            background: #f2f2f2;
        }
        .paging {
            margin-top: 20px;
            text-align: center;
        }
        .paging a {
            margin: 0 5px;
            text-decoration: none;
        }
        .search-box {
            margin-top: 10px;
            text-align: right;
        }
    </style>
</head>
<body>
    <h2>인사관리 페이지</h2>

    <!-- 검색창 -->
    <div class="search-box">
        <form method="get" action="${pageContext.request.contextPath}/hrm">
            <input type="text" name="searchWord" value="${page.searchWord}" placeholder="사원명/아이디 검색">
            <button type="submit">검색</button>
        </form>
    </div>

    <!-- 사원 목록 -->
    <table>
        <thead>
        <tr>
            <th>사번</th>
            <th>이름</th>
            <th>이메일</th>
            <th>전화번호</th>
            <th>경력</th>
            <th>상태</th>
      
        </tr>
        </thead>
        <tbody>
        <c:forEach var="e" items="${empList}">
            <tr>
                <td>${e.empId}</td>
                <td>${e.empName}</td>
                <td>${e.empEmail}</td>
                <td>${e.empPhone}</td>
                <td>${e.empExp}년</td>
                <td>${e.empStatus}</td>
           
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <!-- 페이징 -->
    <div class="paging">
        <c:if test="${page.startPage > 1}">
            <a href="?currentPage=${page.startPage - 1}&searchWord=${page.searchWord}">[이전]</a>
        </c:if>

        <c:forEach begin="${page.startPage}" end="${page.endPage}" var="i">
            <a href="?currentPage=${i}&searchWord=${page.searchWord}"
               style="${page.currentPage == i ? 'font-weight:bold;color:red;' : ''}">[${i}]</a>
        </c:forEach>

        <c:if test="${page.endPage < page.lastPage}">
            <a href="?currentPage=${page.endPage + 1}&searchWord=${page.searchWord}">[다음]</a>
        </c:if>
    </div>
</body>
</html>
