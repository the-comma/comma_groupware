<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
    <title>인사관리</title>
   <link href= "<c:url value='/HTML/Admin/dist/assets/css/vendor.min.css'/>" rel="stylesheet" type="text/css" />
   <link href= "<c:url value='/HTML/Admin/dist/assets/css/app.min.css'/>"  rel="stylesheet" type="text/css" id="app-style" />
   <link href= "<c:url value='/HTML/Admin/dist/assets/css/icons.min.css'/>" rel="stylesheet" type="text/css" />

   <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/bs4/dt-1.11.3/datatables.min.css"/>
    
   <script src="/HTML/Admin/dist/assets/vendor/jquery/jquery.min.js"></script>
   <script src="/HTML/Admin/dist/assets/vendor/bootstrap/bootstrap.bundle.min.js"></script>
   <script type="text/javascript" src="https://cdn.datatables.net/v/bs4/dt-1.11.3/datatables.min.js"></script>
  
    <style>

        .page-title {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div id="wrapper">
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-12">
                            <h2 class="page-title">인사관리 페이지</h2>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-body">
                            <table id="empTable" class="table table-striped table-bordered nowrap" style="width:100%">
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
                                        <td><fmt:formatNumber value="${e.salaryAmount}" pattern="#,###"/>원</td>
                                        <td>${e.rankName }</td>
                                        <td>${e.deptName }</td>
                                        <td>${e.teamName }</td>
                                        <td>
                                            <button onclick="fetchEmployeeDataAndOpenModal('${e.empId}')" class="btn btn-primary btn-sm">수정</button>
                                            <%-- <button onclick="deleteEmployee('${e.empId}')" class="btn btn-danger btn-sm">삭제</button> --%>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>

                            <%--
                            <div class="paging">
                                <ul class="pagination">
                                    <c:if test="${page.startPage > 1}">
                                        <li class="page-item"><a class="page-link" href="?currentPage=${page.startPage - 1}&searchWord=${page.searchWord}">이전</a></li>
                                    </c:if>

                                    <c:forEach begin="${page.startPage}" end="${page.endPage}" var="i">
                                        <li class="page-item ${page.currentPage == i ? 'active' : ''}"><a class="page-link" href="?currentPage=${i}&searchWord=${page.searchWord}">${i}</a></li>
                                    </c:forEach>

                                    <c:if test="${page.endPage < page.lastPage}">
                                        <li class="page-item"><a class="page-link" href="?currentPage=${page.endPage + 1}&searchWord=${page.searchWord}">다음</a></li>
                                    </c:if>
                                </ul>
                            </div>
                            --%>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="myModalLabel">직원 정보 수정</h5>
                </div>
                <div class="modal-body">
                    <h4 id="editEmpName" class="mb-3"></h4>
                    <form id="editForm">
                        <input type="hidden" id="editEmpId" name="empId">
                        <div class="form-group row">
                            <label for="editSalary" class="col-4 col-form-label">급여</label>
                            <div class="col-8">
                                <input type="number" id="editSalary" name="salaryAmount" class="form-control" oninput="displayKoreanAmount()">
                                <small class="form-text text-muted" id="koreanAmount"></small>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="editRank" class="col-4 col-form-label">직급</label>
                            <div class="col-8">
                                <select id="editRank" name="rankName" class="form-control"></select>
                            </div>
                        </div>
                         <div class="form-group row">
                            <label for="editRank" class="col-4 col-form-label">재직상태</label>
                            <div class="col-8">
                               <input type="text" id="empStatus" name="empStatus" class="form-control" value="empStatus">
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="editDept" class="col-4 col-form-label">부서</label>
                            <div class="col-8">
                                <select id="editDept" name="deptName" class="form-control"></select>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="editTeam" class="col-4 col-form-label">팀</label>
                            <div class="col-8">
                                <select id="editTeam" name="teamName" class="form-control"></select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary waves-effect" onclick="closeEditModal()">취소</button>
                    <button type="button" onclick="submitEditForm()" class="btn btn-primary waves-effect waves-light">저장</button>
                </div>
            </div>
        </div>
    </div>

    <script>
    function closeEditModal() {
        $('#editModal').modal('hide');
    }

    function fetchEmployeeDataAndOpenModal(empId) {
        Promise.all([
            fetch('/api/departments').then(res => res.json()),
            fetch('/api/ranks').then(res => res.json()),
            fetch('/hrm/employee/' + empId).then(res => res.json())
        ])
        .then(([deptList, rankList, employeeData]) => {
            const deptSelect = document.getElementById('editDept');
            deptSelect.innerHTML = '<option value="">선택</option>';
            deptList.forEach(dept => {
                const option = new Option(dept, dept);
                deptSelect.add(option);
            });

            const rankSelect = document.getElementById('editRank');
            rankSelect.innerHTML = '<option value="">선택</option>';
            rankList.forEach(rank => {
                const option = new Option(rank, rank);
                rankSelect.add(option);
            });

            // 🔹 사원 이름 표시
            document.getElementById('editEmpName').textContent = employeeData.empName;

            // 🔹 기존 데이터 세팅
            document.getElementById('editEmpId').value = employeeData.empId;
            document.getElementById('editSalary').value = employeeData.salaryAmount || "";
            document.getElementById('empStatus').value = employeeData.empStatus || "";

            if (employeeData.deptName) {
                deptSelect.value = employeeData.deptName;
            }
            if (employeeData.rankName) {
                rankSelect.value = employeeData.rankName;
            }

            if (employeeData.deptName) {
                fetchAndSetTeams(employeeData.deptName, employeeData.teamName);
            }

            // 모달 열기
            $('#editModal').modal('show');
        })
        .catch(error => {
            console.error('Error fetching data:', error);
            alert('데이터를 불러오는 데 실패했습니다.');
        });
    }


    // 부서 변경 시 팀 목록을 가져와서 셀렉트 박스를 업데이트
    document.getElementById('editDept').addEventListener('change', (event) => {
        const selectedDeptName = event.target.value;
        fetchAndSetTeams(selectedDeptName);
    });
    
    function fetchAndSetTeams(deptName, currentTeamName = null) {
        const teamSelect = document.getElementById('editTeam');
        teamSelect.innerHTML = '<option value="">선택</option>'; // 팀 목록 초기화

        if (!deptName) return;

        console.log("deptName" , deptName);
        const encodedDeptName = encodeURIComponent(deptName);
        console.log("encodedDeptName" ,  encodedDeptName);
        
        // 쉼표가 들어간다면, 쉼표를 제거하고 전송
        const processedDeptName = deptName.replace(/,/g, '');
        fetch('/api/teams?deptName=' + processedDeptName)
        .then(res => {
            if (!res.ok) {
                throw new Error('통신 에러');
            }
            console.log("성공");
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
            
            if (currentTeamName) {
                teamSelect.value = currentTeamName;
            }
        })
        .catch(error => {
            console.error('Error fetching teams:', error);
            alert('팀 목록을 불러오는 데 실패했습니다.');
        });
    }

    function submitEditForm() {
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
                location.reload();
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
    
    function toKoreanNumber(number) {
        if (number === "" || isNaN(number)) {
            return "";
        }
        
        let numStr = String(number);
        if (numStr.length > 16) {
            return "너무 큰 금액입니다.";
        }
        
        const units = ["", "만", "억", "조"];
        const numToKorean = ["", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"];
        const smallUnits = ["", "십", "백", "천"];
        
        let result = "";
        let unitIndex = 0;
        
        while (numStr.length > 0) {
            let chunk = "";
            let chunkStr = "";
            
            if (numStr.length > 4) {
                chunk = numStr.slice(-4);
                numStr = numStr.slice(0, -4);
            } else {
                chunk = numStr;
                numStr = "";
            }
            
            const chunkArr = chunk.split("").reverse();
            
            for (let i = 0; i < chunkArr.length; i++) {
                const digit = parseInt(chunkArr[i]);
                if (digit > 0) {
                    chunkStr = numToKorean[digit] + smallUnits[i] + chunkStr;
                }
            }
            
            if (chunkStr !== "") {
                result = chunkStr + units[unitIndex] + result;
            }
            unitIndex++;
        }
        
        result = result.replace(/^일만/, "만").replace(/^일십만/, "십만");

        if (result === "") {
            return "영원";
        }
        
        return result + "원";
    }

    function displayKoreanAmount() {
        const salaryInput = document.getElementById('editSalary');
        const koreanAmountSpan = document.getElementById('koreanAmount');
        const value = salaryInput.value;
        koreanAmountSpan.textContent = toKoreanNumber(value);
    }

    // 모달이 열릴 때 기존 값으로 한글 금액 표시
    $('#editModal').on('shown.bs.modal', function () {
        displayKoreanAmount();
    });

    // DataTables 초기화
    $(document).ready(function() {
        $('#empTable').DataTable({
            "pageLength": 10,
            "order": [[ 0, "asc" ]], // 사번(0번째 열)을 기준으로 오름차순 정렬
            "language": {
                "lengthMenu": "페이지당 _MENU_개씩 보기",
                "zeroRecords": "검색 결과가 없습니다.",
                "info": "총 _PAGES_ 페이지 중 _PAGE_ 페이지",
                "infoEmpty": "데이터가 없습니다.",
                "infoFiltered": "(전체 _MAX_개 중 검색 결과)",
                "search": "검색:",
                "paginate": {
                    "first": "처음",
                    "last": "마지막",
                    "next": "다음",
                    "previous": "이전"
                }
            }
        });
    });
    </script>
</body>
</html>