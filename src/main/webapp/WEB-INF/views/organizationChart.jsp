<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>조직도</title>
<!-- JQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
    body {
        font-family: Arial, sans-serif;
    }
    .container {
        display: flex;          /* 좌우 분할 */
        gap: 20px;              /* 사이 간격 */
        align-items: flex-start;/* 위쪽 맞춤 */
    }
    .org-tree {
        width: 30%;             /* 왼쪽 영역 */
        border: 1px solid #ccc;
        padding: 10px;
    }
    .emp-table {
        flex: 1;                /* 오른쪽 영역 (남는 공간 전부 차지) */
        border: 1px solid #ccc;
        padding: 10px;
    }
    .emp-table table {
        width: 100%;
        border-collapse: collapse;
    }
    .emp-table th, .emp-table td {
        border: 1px solid #ccc;
        padding: 6px;
        text-align: center;
    }
    .emp-table th {
        background-color: #f5f5f5;
    }
</style>
</head>
<body>
    <h1>조직도</h1>

    <div class="container">
        <!-- 왼쪽: 부서/팀 -->
        <div class="org-tree">
            <c:if test="${deptTeam == null}">
                부서/팀이 없습니다.
            </c:if>
            <c:if test="${deptTeam != null}">
                콤마컴퍼니<br>
                <c:forEach items="${deptTeam}" var="dept">
                    &nbsp;&nbsp;&nbsp;ㄴ${dept.key}
                    <c:forEach items="${dept.value}" var="team">
                        <br>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ㄴ${team}
                    </c:forEach>
                    <br>
                </c:forEach>
            </c:if>
        </div>

        <!-- 오른쪽: 사원 리스트 -->
        <div class="emp-table">
            <div style="margin-bottom:10px;">
            	<form action="organizationChart" method="get">
	                <input type="text" class="name" name="name" placeholder="이름으로 검색.." value="${name != null ? name : ''}">
	                <button type="submit">검색</button>
                </form>
            </div>
            <c:if test="${organiList == null}">
                사원이 없습니다.
            </c:if>
            <c:if test="${organiList != null}">
                <table>
                    <thead>
                        <tr>
                            <th>이름</th><th>이메일</th><th>직급</th><th>부서</th><th>팀</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${organiList}" var="e">
                        <tr>
                            <td>${e.empName}</td>
                            <td>${e.empEmail}</td>
                            <td>${e.rankName}</td>
                            <td>${e.deptName}</td>
                            <td>${e.teamName}</td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            ${page.currentPage + 1} / ${page.lastPage + 1} 
        </div>
    </div>
</body>
</html>
