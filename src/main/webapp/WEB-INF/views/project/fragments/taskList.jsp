<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


	<a href="addTask" class="btn btn-primary mb-sm-0 mb-2" data-bs-toggle="modal" data-bs-target="#scrollable-modal">
	    <i class="ti ti-settings fs-20 me-2"></i>업무 추가
	</a>

	<!-- 모달 -->
	<div class="modal fade" id="scrollable-modal" tabindex="-1" role="dialog"
	    aria-labelledby="scrollableModalTitle" aria-hidden="true">
	    <div class="modal-dialog modal-dialog-scrollable" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h4 class="modal-title" id="scrollableModalTitle">업무 작성</h4>
	                <button type="button" class="btn-close" data-bs-dismiss="modal"
	                    aria-label="Close"></button>
	            </div>
	            <div class="modal-body">
					<input type="text" class="form-control" placeholder="제목을 입력하세요.">
					<br>					
					<label for="taskStatus" class="form-label">상태</label>
	                <select class="form-control" id="taskStatus" name="taskStatus">
	                	<option value="">요청</option>
	                	<c:if test="${deptTeamList != null}">
	                		<c:forEach items="${deptTeamList}" var="dept">
	                			<option value="${dept.teamName}">${dept.deptName}/${dept.teamName}</option>
	      					</c:forEach>
	                	</c:if>
	                </select>
	                <br>
	                <label for="empTable" class="form-label">담당자</label>
	                <input type="text" id="empName" class="form-control" placeholder="사원 이름..">
	                <table id="empTable" class="form-table">
	                	<tbody id="empList" name="empList">

	                	</tbody>
	                </table>	 
	                <br>
	                <label for="memberList" class="form-label">참여자</label>
	                <div class="choices" data-type="text">
	                	<div class="choices__inner">
	                		<input readonly="readonly" class="form-control choices__input" id="choices-text-remove-button" data-choices="" data-choices-limit="3" data-choices-removeitem="" type="text" value="Task-1" hidden="" tabindex="-1" data-choice="active">
	                			<div id="memberList" class="choices__list choices__list--multiple">
	                			<!-- 아이템 들어가는 영역 -->
									
	                			</div>
	                		<input type="search" class="choices__input choices__input--cloned" autocomplete="off" autocapitalize="off" spellcheck="false" aria-autocomplete="list" aria-label="Set limit values with remove button" style="min-width: 1ch; width: 1ch;">
	               		</div>
	               		
	               		<div class="choices__list choices__list--dropdown" aria-expanded="false">
	                		<div class="choices__list" aria-multiselectable="true" role="listbox">
	                		</div>
	               		</div>
	              		</div>                           
	                <br>
	                <br>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-outline-danger"
	                    data-bs-dismiss="modal">취소</button>
	                <button type="button" class="btn btn-outline-success" id="modalBtn">등록</button>
	            </div>
	        </div><!-- /.modal-content -->
	    </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->

	<script>
	    const projectId = ${projectId};  // JSP EL → JS 변수
	    // 초기 호출 (검색어 없이 전체 목록)
	    getMemberList('');
	
	 	// input 이벤트
	 	document.querySelector('#empName').addEventListener('keyup', function() {			
	     	getMemberList(this.value); // 이벤트에서 값 바로 전달
	 	});
	
	 	// 함수 정의
	 	function getMemberList(searchName) {
		    let url = '/memberListByProjectId/' + projectId;
		    if(searchName) url += '/' + searchName; // 비어있으면 붙이지 않음
		
		    fetch(url)
		        .then(res => res.json())
		        .then(result => {
		            if (result.length < 1) {
		                document.querySelector('#empList').innerHTML = '';
		                return;
		            }
		            document.querySelector('#empList').innerHTML = '';
		            result.forEach(function(e){
		            	document.querySelector('#empList').innerHTML += `
		            		<tr>
		            			<td><input type="checkbox" class="pl form-check-input" value="\${e.empId}" data-name="\${e.empName}"></td>
				    			<td><img src="/HTML/Admin/dist/assets/images/default_profile.png" alt="image" class="img-fluid avatar-xs rounded"></td>
		            			<td>\${e.projectRole}</td>
		            			<td>\${e.empName}</td>
		            			<td>\${e.rankName}</td>
		            		</tr>
		            	`
		            });
		        });
		}
	</script>