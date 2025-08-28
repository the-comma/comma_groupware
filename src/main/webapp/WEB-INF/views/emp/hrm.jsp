<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
<title>인사관리</title>

<!-- CSS -->
<jsp:include page="../../views/nav/head-css.jsp"></jsp:include>

<link rel="stylesheet" type="text/css"
	href="https://cdn.datatables.net/v/bs4/dt-1.11.3/datatables.min.css" />

<script src="/HTML/Admin/dist/assets/vendor/jquery/jquery.min.js"></script>
<script
	src="/HTML/Admin/dist/assets/vendor/bootstrap/bootstrap.bundle.min.js"></script>
<script type="text/javascript"
	src="https://cdn.datatables.net/v/bs4/dt-1.11.3/datatables.min.js"></script>


</head>
<body>

	<div id="wrapper">
		<!-- 사이드바 -->
		<jsp:include page="../../views/nav/sidenav.jsp"></jsp:include>

		<!-- 헤더 -->
		<jsp:include page="../../views/nav/header.jsp"></jsp:include>

		<div class="page-content">

			<div class="page-container">

				<div class="container">
					<!-- 본문 내용 -->
					<div class="card">
						<div
							class="card-header border-bottom border-dashed d-flex justify-content-between align-items-center">
							<h4 class="header-title">인사관리</h4>
							<div class="col-6 d-flex justify-content-end">
								<button class="btn btn-outline-info me-2"
									onclick="openDeptManageModal()">부서 관리</button>
								<button class="btn btn-outline-success me-2"
									onclick="openTeamManageModal()">팀 관리</button>
								<button class="btn btn-outline-primary"
									onclick="openRegisterModal()">사원 등록</button>
							</div>
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
													class="btn btn-outline-primary btn-sm">수정</button>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
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

				</div>
				<div class="modal-body">
					<form id="registerForm">
						<div class="form-group row mb-2">
							<label for="regEmpId" class="col-4 col-form-label">사번</label>
							<div class="col-8">
								<input type="text" id="regEmpId" name="empId"
									class="form-control" readonly>
							</div>
						</div>
						<div class="form-group row mb-2">
							<label for="regEmpName" class="col-4 col-form-label">이름</label>
							<div class="col-8">
								<input type="text" id="regEmpName" name="empName"
									class="form-control" required>
							</div>
						</div>
						<div class="form-group row mb-2">
							<label for="regEmpEmail" class="col-4 col-form-label">이메일</label>
							<div class="col-8">
								<input type="email" id="regEmpEmail" name="empEmail"
									class="form-control" required>
							</div>
						</div>


						<div class="form-group row mb-2">
							<label for="regRole" class="col-4 col-form-label">권한</label>
							<div class="col-8">
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
								<input type="tel" id="regEmpPhone" name="empPhone"
									class="form-control" required>
							</div>
						</div>
						<div class="form-group row mb-2">
							<label for="regEmpExp" class="col-4 col-form-label">경력(년)</label>
							<div class="col-8">
								<input type="number" id="regEmpExp" name="empExp"
									class="form-control" required>
							</div>
						</div>
						<div class="form-group row mb-2">
							<label for="regSalaryDisplay" class="col-4 col-form-label">급여</label>
							<div class="col-8">
								<input type="text" id="regSalaryDisplay" class="form-control"
									oninput="formatSalaryInput('regSalaryDisplay', 'regSalary', 'regKoreanAmount')"
									required> <input type="hidden" id="regSalary"
									name="salaryAmount" required> <small
									class="form-text text-muted" id="regKoreanAmount"></small>
							</div>
						</div>
						
						
						<div class="form-group row mb-2">
							<label for="regRank" class="col-4 col-form-label">직급</label>
							<div class="col-8">
								<select id="regRank" name="rankName" class="form-control"
									required>
									<option value="" disabled selected>선택</option>
								</select>
							</div>
						</div>
						<div class="form-group row mb-2">
							<label for="regDept" class="col-4 col-form-label">부서</label>
							<div class="col-8">
								<select id="regDept" name="deptName" class="form-control"
									required>
									<option value="" disabled selected>선택</option>
								</select>
							</div>
						</div>
						<div class="form-group row mb-2">
							<label for="regTeam" class="col-4 col-form-label">팀</label>
							<div class="col-8">
								<select id="regTeam" name="teamName" class="form-control"
									required>
									<option value="" disabled selected>선택</option>
								</select>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary waves-effect"
						data-bs-dismiss="modal">취소</button>
					<button type="button" onclick="submitRegisterForm()"
						class="btn btn-primary waves-effect waves-light">등록</button>
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
								<!--  서버로 넘어가는 값 -->
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
							<label for="editStatus" class="col-4 col-form-label">재직상태</label>
							<div class="col-8">
								<select id="editStatus" name="empStatus" class="form-control">
									<option value="재직">재직</option>
									<option value="휴직">휴직</option>
								</select>
							</div>
						</div>
							<div class="form-group row">
							<label for="editRole" class="col-4 col-form-label">역할</label>
							<div class="col-8">
								<select id="editRole" name="role" class="form-control">
									<option value="USER">USER</option>
									<option value="MASTER">MASTER</option>
								</select>
							</div>
						</div>
							<div class="form-group row">
							<label for="editExp" class="col-4 col-form-label">경력</label>
							<div class="col-8">
									<input type="text" id="editExp" name="empExp" placeholder="경력" class="form-control">						
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

	
	<!-- 부서 관리 모달 -->
	<div class="modal fade" id="deptManageModal" tabindex="-1"
		role="dialog" aria-labelledby="deptManageModalLabel"
		aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="deptManageModalLabel">부서 관리</h5>

				</div>
				<div class="modal-body">
					<div class="mb-3">
						<label for="newDeptName" class="form-label">새 부서명</label>
						<div class="input-group mb-3">
							<input type="text" id="newDeptName" class="form-control"
								placeholder="부서명 입력">
							<button class="btn btn-success" type="button"
								onclick="submitNewDept()">등록</button>
						</div>

					</div>
					<hr>
					<h6 class="mb-2">기존 부서 수정</h6>
					<div id="deptList" class="list-group">
						<!-- 부서 목록  -->
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">취소</button>
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
					<button type="button" class="close" data-bs-dismiss="modal"
						aria-label="Close">
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
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary"
						onclick="updateDept()">저장</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 팀 관리 모달  -->
	<div class="modal fade" id="teamManageModal" tabindex="-1"
		role="dialog" aria-labelledby="teamManageModalLabel"
		aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="teamManageModalLabel">팀 관리</h5>

				</div>
				<div class="modal-body">
					<!-- 새 팀 등록 -->
					<div class="mb-3">
						<h6 class="mb-2">새 팀 등록</h6>
						<div class="input-group mb-2">
							<label for="newTeamDeptSelect" class="input-group-text">부서</label>
							<select id="newTeamDeptSelect" class="form-select"></select>
						</div>
						<div class="input-group mb-2">
							<label for="newTeamNameInput" class="input-group-text">팀명</label>
							<input type="text" id="newTeamNameInput" placeholder="팀명 입력"
								class="form-control">
							<button class="btn btn-success" type="button"
								onclick="submitNewTeam()">등록</button>
						</div>
					</div>
					<hr>
					<!-- 기존 팀 수정 -->
					<div class="mb-3">
						<h6 class="mb-2">기존 팀 수정</h6>
						<div class="input-group mb-2">
							<label for="manageTeamDeptSelect" class="input-group-text">부서
								선택</label> <select id="manageTeamDeptSelect" class="form-select"></select>
						</div>
					</div>
					<div id="teamList" class="list-group">
						<!-- 팀 목록 -->
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">취소</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 팀 수정 모달 -->
	<div class="modal fade" id="editTeamModal" tabindex="-1" role="dialog"
		aria-labelledby="editTeamModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="editTeamModalLabel">팀 수정</h5>
					<button type="button" class="close" data-bs-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<input type="hidden" id="editTeamId">
					<div class="mb-3">
						<label for="editTeamDeptSelect" class="form-label">부서</label> <select
							id="editTeamDeptSelect" class="form-select"></select>
					</div>
					<div class="mb-3">
						<label for="editTeamNameInput" class="form-label">팀명</label> <input
							type="text" id="editTeamNameInput" class="form-control">
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary"
						onclick="updateTeam()">저장</button>
				</div>
			</div>
		</div>
	</div>
	<!-- App js -->
	<script src="/HTML/Admin/dist/assets/js/app.js"></script>
	<!--  hrm.js -->
	<script src="/js/hrm.js"></script>

	<jsp:include page="../../views/nav/footer.jsp"></jsp:include>
</body>
</html>
