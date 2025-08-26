<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	
	<a href="addTask" class="btn btn-primary mb-sm-0 mb-2" data-bs-toggle="modal" data-bs-target="#scrollable-modal">
	    <i class="ti ti-settings fs-20 me-2"></i>업무 추가
	</a>

	<!-- 모달 -->
    <form action="/addTask" method="post" name="addTask" id="addTask" enctype="multipart/form-data">
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
	            	<input type="hidden" name ="projectId" value="${projectId}">
	            	
					<input type="text" class="form-control" name="taskTitle" placeholder="제목을 입력하세요.">
					<br>					
					<label for="taskStatus" class="form-label">상태</label>
	                <select class="form-control" id="taskStatus" name="taskStatus">
	                	<option value="REQUEST">요청</option>
	                	<c:if test="${deptTeamList != null}">
	                		<c:forEach items="${deptTeamList}" var="dept">
	                			<option value="${dept.teamName}">${dept.deptName}/${dept.teamName}</option>
	      					</c:forEach>
	                	</c:if>
	                </select>
	                <br>
	                <label for="memberList" class="form-label">담당자</label>
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
              		<!-- hiddenList -->
              		<div id="hiddentList">
              		
              		</div>
              		<br>
              		<label for="empName" class="form-label">담당자 추가</label>
              		<input type="text" id="empName" class="form-control" placeholder="사원 이름..">
	                <table id="empTable" class="form-table">
	                	<tbody id="empList" name="empList">

	                	</tbody>
	                </table>	 
	                <br>
	                <div>
						<label for="startDate" class="form-label">시작일</label>
						<input class="form-control" type="date" id="startDate" name="startDate">
					</div>     
	                <br>
					<div>
						<label for="dueDate" class="form-label">마감일</label>
						<input class="form-control" type="date" id="dueDate" name="dueDate">
					</div>
					<br>
					<div>
						<textarea class="form-control" rows="10" cols="20" id="taskDesc" name="taskDesc" placeholder="내용을 입력하세요."></textarea>
					</div>			
					
					<div>
                        <label for="formFileMultiple01" class="form-label">첨부파일</label>
                        <input class="form-control" name="file" type="file" id="formFileMultiple01" multiple>
                    </div>
					
					<!-- 미리보기 영역 -->
					<div id="filePreview" class="mt-3"></div>
	            </div> <!-- modal-body -->
	            <div class="modal-footer">
	                <button type="button" class="btn btn-outline-danger"
	                    data-bs-dismiss="modal">취소</button>
	                <button type="submit" class="btn btn-outline-success" id="modalBtn">등록</button>
	            </div>
	        </div><!-- /.modal-content -->
	    </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	</form>
	
	<!-- 업무 리스트 -->
	<div class="table-responsive-sm">
		<c:if test="${taskList != null}">
           	<table class="table table-hover mb-0">
           		<thead>
           			<tr>
           				<th>업무명</th>
           				<th>상태</th>
           				<th>담당자</th>
           				<th>시작일</th>
           				<th>마감일</th>
           				<th>진척도</th>
           				<th>작성자</th>
           			</tr>
           		</thead>
           		<tbody>
				<c:forEach items="${taskList}" var="t">
				    <tr 
				        data-level="${t.level}" 
				        data-task-id="${t.taskId}" 
				        data-parent-id="${t.taskParent}"
				        class="task-row <c:if test='${t.level > 0}'>child-row</c:if>">
				        <td>
				            <c:forEach begin="1" end="${t.level}">
				                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				            </c:forEach>
				            <c:if test="${t.childCount > 0}">
				                <span class="toggle-btn" style="cursor:pointer;">[-]</span>
				            </c:if>
				            ${t.taskTitle} 
				            <c:if test="${t.childCount > 0}">(${t.childCount})</c:if>
				        </td>
				        <td>${t.taskStatus}</td>
				        <td>
				            <c:choose>
				                <c:when test="${t.memberName != null}">
				                    ${t.memberName}<c:if test="${t.memberCount - 1 > 0}"> +${t.memberCount - 1}</c:if>
				                </c:when>
				                <c:when test="${t.memberName == null}">
				                    미배정
				                </c:when>
				            </c:choose>
				        </td>
				        <td>${t.startDate}</td>
				        <td>${t.dueDate}</td>
				        <td></td>
				        <td></td>
				    </tr>
				</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
	<!-- 업무 리스트 끝 -->
	
	<script>
	    const projectId = ${projectId};
	    const selectedEmp = new Set();
	    const hl = document.querySelector('#hiddentList');
	    
	    // 초기 호출 (검색어 없이 전체 목록)
	    getMemberList('');
	
	 	// input 이벤트
	 	document.querySelector('#empName').addEventListener('keyup', function() {			
	     	getMemberList(this.value); // 이벤트에서 값 바로 전달
	 	});
	
	 	// 멤버 리스트 가져옴
	 	function getMemberList(searchName) {
		    let url = '/memberListByProjectId/' + projectId;
		    if(searchName) url += '/' + searchName; // 비어있으면 붙이지 않음
		
		    fetch(url)
		        .then(res => res.json())
		        .then(result => {
	                document.querySelector('#empList').innerHTML = '';
		            if (result.length < 1) {
		                return;
		            }
		            result.forEach(function(e){
		            	const checked = [...selectedEmp].some(item => item.id === String(e.empId)) ? "checked" : "";
		            	
		            	document.querySelector('#empList').innerHTML += `
		            		<tr>
		            			<td><input type="checkbox" class="emp form-check-input" value="\${e.empId}" data-name="\${e.empName}" \${checked}></td>
				    			<td><img src="/HTML/Admin/dist/assets/images/default_profile.png" alt="image" class="img-fluid avatar-xs rounded"></td>
		            			<td>[\${e.projectRole}]</td>
		            			<td>\${e.empName}</td>
		            			<td>\${e.rankName}</td>
		            		</tr>
		            	`
		            });
		        });
		}
	 	
	 // 체크박스 선택 이벤트 위임
	document.querySelector('#empList').addEventListener('change', function(e) {
	    if(e.target.classList.contains('emp')) {
	        if(e.target.checked){
	        	selectedEmp.add({id: e.target.value, name: e.target.dataset.name});
	        } else {
	            [...selectedEmp].forEach(item => {
	                if(item.id === e.target.value) selectedEmp.delete(item);
	            });
	        }
	    }
	    
	 	// 현재 선택된 멤버 미리보기 (memberList에 출력)
	    renderMemberList();
	});
	 
	// memberList 영역 그리기 함수
	function renderMemberList(){
	    const memberList = document.querySelector('#memberList');
	    memberList.innerHTML = "";
	    hl.innerHTML = '';				// hidden input 영역 초기화		
	    selectedEmp.forEach(e => {
	    	hl.innerHTML += `
	            <input type="hidden" name="selectedEmp" value="\${e.id}">
	    	`
	        memberList.innerHTML += `<div class="member-btn choices__item choices__item--selectable" data-role="FE" data-id="\${e.id}">
	        						<img src="/HTML/Admin/dist/assets/images/default_profile.png" alt="image" class="img-fluid avatar-xs rounded">
	        						\${e.name}
							        <button type="button" class="member-btn choices__button" data-role="FE" data-id="\${e.id}" aria-label="Remove item: Task-1" data-button="">Remove item</button>
							        </div>`;
	    });
 	}
 	
	// 버튼 클릭 → 해당 멤버 제거
	document.querySelector('#memberList').addEventListener('click', function(e){
	    if(e.target.classList.contains('member-btn')){
	        const role = e.target.dataset.role;
	        const id = e.target.dataset.id;
	
	        [...selectedEmp].forEach(item => { if(item.id === id) selectedEmp.delete(item); });
	
	        // 체크박스도 해제
	        document.querySelectorAll(`input[value="\${id}"]`).forEach(cb => cb.checked = false);
	
	        // 다시 렌더링
	        renderMemberList();
	    }
	});
	
	// 파일 프리뷰
	document.getElementById('formFileMultiple01').addEventListener('change', function (event) {
	    const files = event.target.files;
	    const preview = document.getElementById('filePreview');

	    preview.innerHTML = ""; // 기존 미리보기 초기화

	    Array.from(files).forEach(file => {
	        const fileDiv = document.createElement("div");
	        fileDiv.classList.add("mb-2", "p-2", "border", "rounded");

	        // 파일 이름 + 크기 표시
	        const info = document.createElement("p");

	        info.textContent = `\${file.name} (\${(file.size / 1024).toFixed(1)} KB)`;
	        
	        fileDiv.appendChild(info);

	        // 이미지 파일이면 썸네일 생성
	        if (file.type.startsWith("image/")) {
	            const img = document.createElement("img");
	            img.classList.add("img-thumbnail", "mt-1");
	            img.style.maxWidth = "150px";
	            img.style.maxHeight = "150px";

	            const reader = new FileReader();
	            reader.onload = e => {
	                img.src = e.target.result;
	            };
	            reader.readAsDataURL(file);

	            fileDiv.appendChild(img);
	        }
	        
	        preview.appendChild(fileDiv);
	    });
	});

	// 상위 작업 접었다 폈다
	document.querySelectorAll('.toggle-btn').forEach(btn => {
	    btn.addEventListener('click', function() {
	        const tr = btn.closest('tr');
	        const taskId = tr.dataset.taskId;
	        const isExpanded = btn.textContent === '[-]';
	        btn.textContent = isExpanded ? '[+]' : '[-]';

	        toggleChildren(taskId, !isExpanded);
	    });
	});

	function toggleChildren(parentId, show) {
	    document.querySelectorAll(`tr[data-parent-id="\${parentId}"]`).forEach(child => {
	        child.style.display = show ? '' : 'none';
	        
	     	// 자식의 toggle 버튼도 함께 변경
	        const toggleBtn = child.querySelector('.toggle-btn');
	        if (toggleBtn) {
	            toggleBtn.textContent = show ? '[+]' : '[-]';
	        }

	        // 부모가 접히면 자식들도 재귀적으로 접기
	        if (!show) {
	            const childId = child.dataset.taskId;
	            toggleChildren(childId, false);
	        }
	    });
	}
	
	// 최종 등록 버튼 클릭
	/* document.querySelector('#modalBtn').addEventListener('click', function() {
		document.querySelector('#addTask').submit();
   	}); */
	</script>