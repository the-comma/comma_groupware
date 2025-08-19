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

    <div class="search-box">
        <form method="get" action="${pageContext.request.contextPath}/hrm">
            <input type="text" name="searchWord" value="${page.searchWord}" placeholder="사원명/아이디 검색">
            <button type="submit">검색</button>
        </form>
    </div>

    <table>
        <thead>
        <tr>
            <th>사번</th>
            <th>이름</th>
            <th>이메일</th>
            <th>전화번호</th>
            <th>경력</th>
            <th>상태</th>
            <th>급여</th>
            <th>직급</th>
            <th>부서</th>
            <th>팀</th>
            <th>관리</th>
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
                <td>${e.salaryAmount }</td>
                <td>${e.rankName }</td>
                <td>${e.deptName }</td>
                <td>${e.teamName }</td>
 				<td>
  				    <button onclick="fetchEmployeeDataAndOpenModal('${e.empId}')">수정</button>
 				    <button onclick="deleteEmployee('${e.empId}')">삭제</button>
				</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

	<div id="editModal" style="display:none;">
        <h3>직원 정보 수정</h3>
        <form id="editForm">
            <input type="hidden" id="editEmpId" name="empId">
            급여: <input type="number" id="editSalary" name="salaryAmount"><br>

            직급: <select id="editRank" name="rankName"></select><br>
            부서: <select id="editDept" name="deptName"></select><br>
            팀: <select id="editTeam" name="teamName"></select><br>

            <button type="button" onclick="submitEditForm()">저장</button>
            <button type="button" onclick="closeEditModal()">취소</button>
        </form>
	</div>

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
<script>
    // 모달을 열기 전, 부서와 직급 목록을 먼저 가져옵니다.
    function fetchEmployeeDataAndOpenModal(empId) {
        // API 호출을 병렬로 처리하여 효율성을 높입니다.
        Promise.all([
            fetch('/api/departments').then(res => res.json()),
            fetch('/api/ranks').then(res => res.json()),
            fetch('/hrm/employee/' + empId).then(res => res.json())
        ])
        .then(([deptList, rankList, employeeData]) => {
            // 부서 셀렉트박스 채우기
            const deptSelect = document.getElementById('editDept');
            deptSelect.innerHTML = '<option value="">선택</option>';
            deptList.forEach(dept => {
                const option = new Option(dept, dept);
                deptSelect.add(option);
            });

            // 직급 셀렉트박스 채우기
            const rankSelect = document.getElementById('editRank');
            rankSelect.innerHTML = '<option value="">선택</option>';
            rankList.forEach(rank => {
                const option = new Option(rank, rank);
                rankSelect.add(option);
            });

            // 기존 직원 정보로 폼 채우기
            document.getElementById('editEmpId').value = employeeData.empId;
            document.getElementById('editSalary').value = employeeData.salaryAmount;

            // 기존 부서 및 직급 선택 상태로 설정
            if (employeeData.deptName) {
                deptSelect.value = employeeData.deptName;
            }
            if (employeeData.rankName) {
                rankSelect.value = employeeData.rankName;
            }

            // 부서 선택 후 팀 목록 가져오기 (비동기)
            if (employeeData.deptName) {
                fetchAndSetTeams(employeeData.deptName, employeeData.teamName);
            }

            // 모달 표시
            document.getElementById('editModal').style.display = 'block';
        })
        .catch(error => {
            console.error('Error fetching data:', error);
            alert('데이터를 불러오는 데 실패했습니다.');
        });
    }

    // 부서 변경 시 팀 목록을 가져와서 셀렉트 박스를 업데이트하는 함수
    document.getElementById('editDept').addEventListener('change', (event) => {
        const selectedDeptName = event.target.value;
        fetchAndSetTeams(selectedDeptName);
    });

    

    function fetchAndSetTeams(deptName, currentTeamName = null) {
        const teamSelect = document.getElementById('editTeam');
        teamSelect.innerHTML = '<option value="">선택</option>'; // 팀 목록 초기화

        if (!deptName) return;

        // deptName을 URL에 안전하게 전달하기 위해 인코딩합니다.
        const encodedDeptName = encodeURIComponent(deptName);
        
        // 인코딩된 변수를 URL에 사용합니다.
        console.log("encodedDeptName" ,  encodedDeptName);
        fetch(`/api/teams?deptName=${encodedDeptName}`)
        .then(res => {
            if (!res.ok) {
                throw new Error('네트워크 응답이 올바르지 않습니다.');
            }
            return res.json();
        })
        .then(teamList => {
            if (!Array.isArray(teamList)) {
                throw new Error('유효한 팀 목록 데이터가 아닙니다.');
            }
            teamList.forEach(team => {
                const option = new Option(team, team);
                teamSelect.add(option);
            });
            
            // 기존 팀 정보가 있으면 선택 상태로 설정
            if (currentTeamName) {
                teamSelect.value = currentTeamName;
            }
        })
        .catch(error => {
            console.error('Error fetching teams:', error);
            alert('팀 목록을 불러오는 데 실패했습니다.');
        });
    }
    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    function submitEditForm() {
        // 폼 데이터를 가져와서 서버로 전송
        const formData = new FormData(document.getElementById('editForm'));
        const data = Object.fromEntries(formData.entries());

        fetch('/hrm/edit', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(data)
        })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                alert('수정 성공!');
                location.reload(); // 페이지 새로고침
            } else {
                alert('수정 실패!');
            }
        });
    }

    function deleteEmployee(empId) {
        if (confirm('정말로 삭제하시겠습니까?')) {
            fetch('/hrm/delete/' + empId, {
                method: 'DELETE'
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert('삭제 성공!');
                    location.reload();
                } else {
                    alert('삭제 실패!');
                    console.log(empId);
                }
            });
        }
    }
</script>
</html>