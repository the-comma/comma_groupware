<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
<title>인사관리</title>
<link href="<c:url value='/HTML/Admin/dist/assets/css/vendor.min.css'/>"
	rel="stylesheet" type="text/css" />
<link href="<c:url value='/HTML/Admin/dist/assets/css/app.min.css'/>"
	rel="stylesheet" type="text/css" id="app-style" />
<link href="<c:url value='/HTML/Admin/dist/assets/css/icons.min.css'/>"
	rel="stylesheet" type="text/css" />

<link rel="stylesheet" type="text/css"
	href="https://cdn.datatables.net/v/bs4/dt-1.11.3/datatables.min.css" />

<script src="/HTML/Admin/dist/assets/vendor/jquery/jquery.min.js"></script>
<script
	src="/HTML/Admin/dist/assets/vendor/bootstrap/bootstrap.bundle.min.js"></script>
<script type="text/javascript"
	src="https://cdn.datatables.net/v/bs4/dt-1.11.3/datatables.min.js"></script>

<style>
.page-title {
	margin-bottom: 20px;
}
.modal-body .btn {
	margin-bottom: 5px;
}
</style>
</head>
<body>

	<div id="wrapper">
		<%--  <%@ include file="/HTML/Admin/src/partials/sidenav.html" %> --%>
		<div class="content-page">
			<div class="content">
				<div class="container-fluid">
					<div class="row align-items-center">
						<div class="col-6">
							<h2 class="page-title">인사관리 페이지</h2>
						</div>
						<div class="col-6 text-end">
							<!-- 부서/팀 관리 버튼 추가 -->
							<button class="btn btn-info me-2" onclick="openDeptManageModal()">부서 관리</button>
							<button class="btn btn-success me-2" onclick="openTeamManageModal()">팀 관리</button>
							<!-- 사원 등록 버튼 -->
							<button class="btn btn-primary" onclick="openRegisterModal()">사원 등록</button>
						</div>
					</div>

					<div class="card">
						<div class="card-body">
							<table id="empTable"
								class="table table-striped table-bordered nowrap"
								style="width: 100%">
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
											<td><fmt:formatNumber value="${e.salaryAmount}"
													pattern="#,###" />원</td>
											<td>${e.rankName }</td>
											<td>${e.deptName }</td>
											<td>${e.teamName }</td>
											<td>
												<button
													onclick="fetchEmployeeDataAndOpenModal('${e.empId}')"
													class="btn btn-primary btn-sm">수정</button> <%-- <button onclick="deleteEmployee('${e.empId}')" class="btn btn-danger btn-sm">삭제</button> --%>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>

							<%-- 페이징 부분은 주석 처리된 상태로 유지 --%>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 직원 정보 수정 모달 -->
	<div class="modal fade" id="editModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
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
							<label for="editSalaryDisplay" class="col-4 col-form-label">급여</label>
							<div class="col-8">
								<!-- 화면에 보이는 입력창 -->
								<input type="text" id="editSalaryDisplay" class="form-control"
									oninput="formatSalaryInput('editSalaryDisplay', 'editSalary', 'koreanAmount')">
								<!-- 실제 서버로 넘어가는 값 -->
								<input type="hidden" id="editSalary" name="salaryAmount">
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
							<label for="empStatus" class="col-4 col-form-label">재직상태</label>
							<div class="col-8">
								<!-- 재직 상태를 선택할 수 있는 셀렉트 박스로 변경 -->
								<select id="empStatus" name="empStatus" class="form-control">
									<option value="재직">재직</option>
									<option value="휴직">휴직</option>
								</select>
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
					<button type="button" class="btn btn-secondary waves-effect"
						onclick="closeEditModal()">취소</button>
					<button type="button" onclick="submitEditForm()"
						class="btn btn-primary waves-effect waves-light">저장</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 직원 등록 모달 -->
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog"
		aria-labelledby="registerModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="registerModalLabel">직원 등록</h5>
					<button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form id="registerForm">
						<div class="form-group row mb-2">
							<label for="regEmpName" class="col-4 col-form-label">이름</label>
							<div class="col-8">
								<!-- '이름' 필드에 required 속성 추가 -->
								<input type="text" id="regEmpName" name="empName" class="form-control" required>
							</div>
						</div>
						<div class="form-group row mb-2">
							<label for="regEmpEmail" class="col-4 col-form-label">이메일</label>
							<div class="col-8">
								<!-- '이메일' 필드에 required 속성 추가 -->
								<input type="email" id="regEmpEmail" name="empEmail" class="form-control" required>
							</div>
						</div>
						
					
						<div class="form-group row mb-2">
							<label for="regRole" class="col-4 col-form-label">권한</label>
							<div class="col-8">
								<!-- '권한' 필드에 required 속성 추가 -->
								<select id="regRole" name="role" class="form-control" required>
									<option value="" disabled selected>선택</option>
									<option value="USER">USER</option>
									<option value="MASTER">MASTER</option>
								</select>
							</div>
						</div>
				
						<div class="form-group row mb-2">
							<label for="regEmpPhone" class="col-4 col-form-label">전화번호</label>
							<div class="col-8">
								<!-- '전화번호' 필드에 required 속성 추가 -->
								<input type="tel" id="regEmpPhone" name="empPhone" class="form-control" required>
							</div>
						</div>
						<div class="form-group row mb-2">
							<label for="regEmpExp" class="col-4 col-form-label">경력(년)</label>
							<div class="col-8">
								<!-- '경력' 필드에 required 속성 추가 -->
								<input type="number" id="regEmpExp" name="empExp" class="form-control" required>
							</div>
						</div>
						<div class="form-group row mb-2">
							<label for="regSalaryDisplay" class="col-4 col-form-label">급여</label>
							<div class="col-8">
								<!-- '급여' 필드에 required 속성 추가 -->
								<input type="text" id="regSalaryDisplay" class="form-control" oninput="formatSalaryInput('regSalaryDisplay', 'regSalary', 'regKoreanAmount')" required>
								<input type="hidden" id="regSalary" name="salaryAmount" required>
								<small class="form-text text-muted" id="regKoreanAmount"></small>
							</div>
						</div>
						<div class="form-group row mb-2">
							<label for="regRank" class="col-4 col-form-label">직급</label>
							<div class="col-8">
								<!-- '직급' 필드에 required 속성 추가 -->
								<select id="regRank" name="rankName" class="form-control" required>
									<option value="" disabled selected>선택</option>
								</select>
							</div>
						</div>
						<div class="form-group row mb-2">
							<label for="regDept" class="col-4 col-form-label">부서</label>
							<div class="col-8">
								<!-- '부서' 필드에 required 속성 추가 -->
								<select id="regDept" name="deptName" class="form-control" required>
									<option value="" disabled selected>선택</option>
								</select>
							</div>
						</div>
						<div class="form-group row mb-2">
							<label for="regTeam" class="col-4 col-form-label">팀</label>
							<div class="col-8">
								<!-- '팀' 필드에 required 속성 추가 -->
								<select id="regTeam" name="teamName" class="form-control" required>
									<option value="" disabled selected>선택</option>
								</select>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary waves-effect" data-bs-dismiss="modal">취소</button>
					<button type="button" onclick="submitRegisterForm()"
						class="btn btn-primary waves-effect waves-light">등록</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 부서 관리 모달 -->
	<div class="modal fade" id="deptManageModal" tabindex="-1" role="dialog"
		aria-labelledby="deptManageModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="deptManageModalLabel">부서 관리</h5>
					<button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="mb-3">
						<label for="newDeptName" class="form-label">새 부서명</label>
						<div class="input-group">
							<input type="text" id="newDeptName" class="form-control">
							<button class="btn btn-success" type="button" onclick="submitNewDept()">등록</button>
						</div>
					</div>
					<hr>
					<h6 class="mb-2">기존 부서 수정/삭제</h6>
					<div id="deptList" class="list-group">
						<!-- 부서 목록이 여기에 동적으로 추가될 예정 -->
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 부서 수정 모달 -->
	<div class="modal fade" id="editDeptModal" tabindex="-1" role="dialog"
		aria-labelledby="editDeptModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="editDeptModalLabel">부서명 수정</h5>
					<button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<input type="hidden" id="editDeptId">
					<div class="mb-3">
						<label for="editDeptNameInput" class="form-label">새로운 부서명</label>
						<input type="text" id="editDeptNameInput" class="form-control">
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary" onclick="updateDept()">저장</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 팀 관리 모달 (추가) -->
	<div class="modal fade" id="teamManageModal" tabindex="-1" role="dialog"
		aria-labelledby="teamManageModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="teamManageModalLabel">팀 관리</h5>
					<button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<!-- 새 팀 등록 섹션 -->
					<div class="mb-3">
						<h6 class="mb-2">새 팀 등록</h6>
						<div class="input-group mb-2">
							<label for="newTeamDeptSelect" class="input-group-text">부서</label>
							<select id="newTeamDeptSelect" class="form-select"></select>
						</div>
						<div class="input-group">
							<label for="newTeamNameInput" class="input-group-text">팀명</label>
							<input type="text" id="newTeamNameInput" class="form-control">
							<button class="btn btn-success" type="button" onclick="submitNewTeam()">등록</button>
						</div>
					</div>
					<hr>
					<!-- 기존 팀 수정/삭제 섹션 -->
					<div class="mb-3">
						<h6 class="mb-2">기존 팀 수정</h6>
						<div class="input-group mb-2">
							<label for="manageTeamDeptSelect" class="input-group-text">부서 선택</label>
							<select id="manageTeamDeptSelect" class="form-select"></select>
						</div>
					</div>
					<div id="teamList" class="list-group">
						<!-- 팀 목록이 여기에 동적으로 추가될 예정 -->
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 팀 수정 모달 (추가) -->
	<div class="modal fade" id="editTeamModal" tabindex="-1" role="dialog"
		aria-labelledby="editTeamModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="editTeamModalLabel">팀 수정</h5>
					<button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<input type="hidden" id="editTeamId">
					<div class="mb-3">
						<label for="editTeamDeptSelect" class="form-label">부서</label>
						<select id="editTeamDeptSelect" class="form-select"></select>
					</div>
					<div class="mb-3">
						<label for="editTeamNameInput" class="form-label">팀명</label>
						<input type="text" id="editTeamNameInput" class="form-control">
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary" onclick="updateTeam()">저장</button>
				</div>
			</div>
		</div>
	</div>

	<script>
    // --- 함수 공통화 및 재정의 ---
    function closeEditModal() {
        $('#editModal').modal('hide');
    }
    
    function closeRegisterModal() {
    	$('#registerModal').modal('hide');
    }

    // 숫자에 콤마를 붙이는 함수 (재사용)
    function formatNumberWithCommas(x) {
        return x ? x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") : '';
    }

    // 급여 입력 필드 포맷팅 함수 (재사용)
    function formatSalaryInput(displayId, hiddenId, koreanAmountId) {
        const displayInput = document.getElementById(displayId);
        const hiddenInput = document.getElementById(hiddenId);
        const koreanAmountSpan = document.getElementById(koreanAmountId);

        let value = displayInput.value.replace(/[^0-9]/g, "");
        if (value === "") {
            displayInput.value = "";
            hiddenInput.value = "";
            koreanAmountSpan.textContent = "";
            return;
        }
        displayInput.value = formatNumberWithCommas(value);
        hiddenInput.value = value;
        koreanAmountSpan.textContent = toKoreanNumber(value);
    }
    
    // 모달을 열 때마다 한글 금액 표시 업데이트
    $('#editModal').on('shown.bs.modal', function () {
        const salaryValue = document.getElementById('editSalary').value;
        document.getElementById('editSalaryDisplay').value = formatNumberWithCommas(salaryValue);
        displayKoreanAmount();
    });
    
    // --- 기존 수정 모달 관련 함수 ---
    function fetchEmployeeDataAndOpenModal(empId) {
        Promise.all([
            fetch('/hrm/api/departments').then(res => res.json()),
            fetch('/hrm/api/ranks').then(res => res.json()),
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

            // 사원 이름 표시
            document.getElementById('editEmpName').textContent = employeeData.empName;

            // 기존 데이터 세팅
            document.getElementById('editEmpId').value = employeeData.empId;
            document.getElementById('editSalary').value = employeeData.salaryAmount || "";
        
            const empStatusSelect = document.getElementById('empStatus');
            empStatusSelect.value = employeeData.empStatus || "재직"; // 기본값 '재직'

            if (employeeData.deptName) {
                deptSelect.value = employeeData.deptName;
            }
            if (employeeData.rankName) {
                rankSelect.value = employeeData.rankName;
            }

            if (employeeData.deptName) {
                fetchAndSetTeams(employeeData.deptName, employeeData.teamName, 'editTeam');
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
        fetchAndSetTeams(selectedDeptName, null, 'editTeam');
    });
    
    function fetchAndSetTeams(deptName, currentTeamName = null, teamSelectId) {
        const teamSelect = document.getElementById(teamSelectId);
        teamSelect.innerHTML = '<option value="" disabled selected>선택</option>'; // 팀 목록 초기화

        if (!deptName) return;
        
        const processedDeptName = deptName.replace(/,/g, '');
        fetch('/hrm/api/teams?deptName=' + encodeURIComponent(processedDeptName))
        .then(res => {
            if (!res.ok) {
                throw new Error('통신 에러');
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
        const data = {};
        for (let [key, value] of formData.entries()) {
            data[key] = value;
        }

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
        
        let numStr = String(number).replace(/,/g, '');
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

   	// 직원 등록 관련 함수 
    function openRegisterModal() {
        Promise.all([
            fetch('/hrm/api/departments').then(res => res.json()),
            fetch('/hrm/api/ranks').then(res => res.json())
        ])
        .then(([deptList, rankList]) => {
            const deptSelect = document.getElementById('regDept');
            deptSelect.innerHTML = '<option value="" disabled selected>선택</option>';
            deptList.forEach(dept => {
                const option = new Option(dept, dept);
                deptSelect.add(option);
            });

            const rankSelect = document.getElementById('regRank');
            rankSelect.innerHTML = '<option value="" disabled selected>선택</option>';
            rankList.forEach(rank => {
                const option = new Option(rank, rank);
                rankSelect.add(option);
            });
        })
        .catch(error => {
            console.error('Error fetching data:', error);
            alert('부서 및 직급 목록을 불러오는 데 실패했습니다.');
        });
        
        document.getElementById('registerForm').reset();
        document.getElementById('regKoreanAmount').textContent = '';

        $('#registerModal').modal('show');
    }
    
    // 등록 폼 제출 함수
    function submitRegisterForm() {
        const form = document.getElementById('registerForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);
        const data = {};
        for (let [key, value] of formData.entries()) {
            data[key] = value;
        }

        if (data.salaryAmount) {
            data.salaryAmount = data.salaryAmount.replace(/,/g, '');
        }

        fetch('/hrm/register', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(data)
        })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                alert('사원 등록 성공!');
                location.reload();
            } else {
                alert('사원 등록 실패: ' + result.message);
            }
        })
        .catch(error => {
            console.error('Error submitting form:', error);
            alert('사원 등록 중 오류가 발생했습니다.');
        });
    }

    // 부서 관리 관련 함수
    function openDeptManageModal() {
        $('#deptManageModal').modal('show');
        renderDeptList();
    }

    function renderDeptList() {
        const deptListContainer = document.getElementById('deptList');
        deptListContainer.innerHTML = '';
        fetch('/hrm/api/departments/all')
            .then(res => res.json())
            .then(depts => {
                if (!Array.isArray(depts)) {
                    throw new Error('유효한 부서 목록 데이터가 아닙니다.');
                }
                depts.forEach(dept => {
                	
                    const deptItem = document.createElement('div');
                    deptItem.className = 'list-group-item d-flex justify-content-between align-items-center';
                    deptItem.innerHTML = `
                        <span>${dept.deptName}</span>
                        <div class="ms-auto">
                            <button class="btn btn-warning btn-sm me-2" onclick="openEditDeptModal('${dept.deptId}', '${dept.deptName}')">수정</button>
                        </div>
                    `;
                    deptListContainer.appendChild(deptItem);
                });
            })
            .catch(error => {
                console.error('부서 목록을 불러오는 데 실패:', error);
                deptListContainer.innerHTML = '<p class="text-danger">부서 목록을 불러오는 데 실패했습니다.</p>';
            });
    }

    function submitNewDept() {
        const newDeptName = document.getElementById('newDeptName').value;
        if (!newDeptName) {
            alert('부서명을 입력하세요.');
            return;
        }

        fetch('/hrm/api/dept/new', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ deptName: newDeptName })
        })
        .then(response => {
            if (response.ok) {
                return response.text(); // 문자열 응답 처리
            } else {
                return response.text().then(text => { throw new Error(text || '부서 등록 실패'); });
            }
        })
        .then(message => {
            alert(message);
            $('#deptManageModal').modal('hide');
            location.reload();
        })
        .catch(error => {
            console.error('부서 등록 중 오류:', error);
            alert('부서 등록 실패: ' + error.message);
        });
    }

    function openEditDeptModal(deptId, deptName) {
        document.getElementById('editDeptId').value = deptId;
        document.getElementById('editDeptNameInput').value = deptName;
        $('#editDeptModal').modal('show');
    }

    function updateDept() {
        const deptId = document.getElementById('editDeptId').value;
        const newDeptName = document.getElementById('editDeptNameInput').value;

        if (!newDeptName) {
            alert('새로운 부서명을 입력하세요.');
            return;
        }

        fetch('/hrm/api/dept/update', {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ deptId: deptId, deptName: newDeptName })
        })
        .then(response => {
            if (response.ok) {
                return response.text(); // 문자열 응답 처리
            } else {
                return response.text().then(text => { throw new Error(text || '부서명 수정 실패'); });
            }
        })
        .then(message => {
            alert(message);
            $('#editDeptModal').modal('hide');
            $('#deptManageModal').modal('hide');
            location.reload();
        })
        .catch(error => {
            console.error('부서명 수정 중 오류:', error);
            alert('부서명 수정 실패: ' + error.message);
        });
    }
    
    // 팀 관리 관련 함수 (새로 추가)
    function openTeamManageModal() {
        $('#teamManageModal').modal('show');
        fetchDepartmentsForTeamManage();
    }

    function fetchDepartmentsForTeamManage() {
        Promise.all([
            fetch('/hrm/api/departments/all').then(res => res.json())
        ])
        .then(([depts]) => {
            const newTeamDeptSelect = document.getElementById('newTeamDeptSelect');
            const manageTeamDeptSelect = document.getElementById('manageTeamDeptSelect');
            
            // 초기화
            newTeamDeptSelect.innerHTML = '<option value="" disabled selected>선택</option>';
            manageTeamDeptSelect.innerHTML = '<option value="" disabled selected>선택</option>';

            depts.forEach(dept => {
                const newOption = new Option(dept.deptName, dept.deptId);
                const manageOption = new Option(dept.deptName, dept.deptId);
                newTeamDeptSelect.add(newOption);
                manageTeamDeptSelect.add(manageOption);
            });
        })
        .catch(error => {
             console.error('팀 관리 모달 부서 목록 불러오기 실패:', error);
             alert('부서 목록을 불러오는 데 실패했습니다.');
        });
    }

    function submitNewTeam() {
        const deptId = document.getElementById('newTeamDeptSelect').value;
        const teamName = document.getElementById('newTeamNameInput').value;
        if (!deptId || !teamName) {
            alert('부서와 팀명을 모두 선택/입력하세요.');
            return;
        }

        fetch('/hrm/api/team/new', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({ deptId: deptId, teamName: teamName })
        })
        .then(response => {
            if (response.ok) {
                return response.text();
            } else {
                return response.text().then(text => { throw new Error(text || '팀 등록 실패'); });
            }
        })
        .then(message => {
            alert(message);
            $('#teamManageModal').modal('hide');
            location.reload();
        })
        .catch(error => {
            console.error('팀 등록 중 오류:', error);
            alert('팀 등록 실패: ' + error.message);
        });
    }

    document.getElementById('manageTeamDeptSelect').addEventListener('change', (event) => {
        const deptId = event.target.value;
        if (deptId) {
             renderTeamList(deptId);
        } else {
             document.getElementById('teamList').innerHTML = ''; // 선택 해제 시 목록 초기화
        }
    });

    function renderTeamList(deptId) {
        const teamListContainer = document.getElementById('teamList');
        teamListContainer.innerHTML = '';
        fetch('/hrm/api/teams/by-dept-id?deptId=' + deptId)
            .then(res => {
                if (!res.ok) {
                    throw new Error('팀 목록 API 통신 오류');
                }
                return res.json();
            })
            .then(teams => {
                if (!Array.isArray(teams)) {
                    throw new Error('유효한 팀 목록 데이터가 아닙니다.');
                }
                teams.forEach(team => {
                    const teamItem = document.createElement('div');
                    teamItem.className = 'list-group-item d-flex justify-content-between align-items-center';
                    teamItem.innerHTML = `
                        <span>${team.teamName}</span>
                        <div class="ms-auto">
                            <button class="btn btn-warning btn-sm me-2" onclick="openEditTeamModal('${team.teamId}', '${team.teamName}', '${team.deptId}')">수정</button>
                        </div>
                    `;
                    teamListContainer.appendChild(teamItem);
                });
            })
            .catch(error => {
                console.error('팀 목록을 불러오는 데 실패:', error);
                teamListContainer.innerHTML = '<p class="text-danger">팀 목록을 불러오는 데 실패했습니다.</p>';
            });
    }

    function openEditTeamModal(teamId, teamName, deptId) {
        document.getElementById('editTeamId').value = teamId;
        document.getElementById('editTeamNameInput').value = teamName;
        
        fetch('/hrm/api/departments/all')
        .then(res => res.json())
        .then(depts => {
            const select = document.getElementById('editTeamDeptSelect');
            select.innerHTML = '';
            depts.forEach(dept => {
                const option = new Option(dept.deptName, dept.deptId);
                select.add(option);
            });
            // 기존 부서 선택
            select.value = deptId;
            $('#editTeamModal').modal('show');
        })
        .catch(error => {
             console.error('팀 수정 모달 부서 목록 불러오기 실패:', error);
             alert('부서 목록을 불러오는 데 실패했습니다.');
        });
    }

    function updateTeam() {
        const teamId = document.getElementById('editTeamId').value;
        const newTeamName = document.getElementById('editTeamNameInput').value;
        const newDeptId = document.getElementById('editTeamDeptSelect').value;

        if (!newTeamName || !newDeptId) {
            alert('모든 필드를 입력/선택하세요.');
            return;
        }

        fetch('/hrm/api/team/update', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ teamId: teamId, teamName: newTeamName, deptId: newDeptId })
        })
        .then(response => {
            if (response.ok) {
                return response.text();
            } else {
                return response.text().then(text => { throw new Error(text || '팀 수정 실패'); });
            }
        })
        .then(message => {
            alert(message);
            $('#editTeamModal').modal('hide');
            $('#teamManageModal').modal('hide');
            location.reload();
        })
        .catch(error => {
            console.error('팀 수정 중 오류:', error);
            alert('팀 수정 실패: ' + error.message);
        });
    }
    
	
	$(document).ready(function() {
	    // DataTable 초기화
	    $('#empTable').DataTable({
	        "language": {
	            "lengthMenu": "_MENU_ 개씩 보기",
	            "zeroRecords": "결과 없음",
	            "info": " _PAGES_ 중 _PAGE_ 페이지",
	            "infoEmpty": "검색 결과 없음",
	            "infoFiltered": "(전체 _MAX_ 명 중 검색)",
	            "search": "검색:",
	            "paginate": {
	                "next": "다음",
	                "previous": "이전"
	            }
	        },
	        "dom": '<"top"if>rt<"bottom"lp>',
	    });
	});

	// 부서 등록 모달에서 부서 셀렉트 박스 변경 시 팀 목록 업데이트
    document.getElementById('regDept').addEventListener('change', (event) => {
        const selectedDeptName = event.target.value;
        fetchAndSetTeams(selectedDeptName, null, 'regTeam');
    });

	</script>

</body>
