<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- 업무 작성, 수정 모달 -->
	<div class="modal fade" id="scrollable-modal" tabindex="-1" role="dialog"
	    aria-labelledby="scrollableModalTitle" aria-hidden="true">
	    <div class="modal-dialog modal-dialog-scrollable" role="document">
	        <div class="modal-content">
	            
	        </div><!-- /.modal-content -->
	    </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	
	<a href="javascript:void(0)" 
	   onclick="openAddTaskModal(0)" 
	   class="btn btn-primary mb-sm-0 mb-2">
	    <i class="ti ti-circle-plus fs-20 me-2"></i>업무 추가
	</a>

	<script src="${pageContext.request.contextPath}/resources/js/taskModal.js"></script>
	<script>
	function openAddTaskModal(parentId) {
	    $("#scrollable-modal .modal-content").load("/addTask", function() {
	        var modalEl = document.getElementById('scrollable-modal');
	        var myModal = new bootstrap.Modal(modalEl); 
	        myModal.show();
	
	        // 모달 로드 후 JS 초기화
	        initTaskModalJS(${projectId},parentId);
	    });
	}
	</script>

	
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
				        data-task-writer="${t.writerName}"
				        data-task-title="${t.taskTitle}"
				        data-task-desc="${t.taskDesc}"
				        data-task-status="${t.taskStatus}"
				        data-task-start-date="${t.startDate}"
				        data-task-due-date="${t.dueDate}"
				        data-parent-id="${t.taskParent}"
				        class="task-row <c:if test='${t.level > 0}'>child-row</c:if>">
				        <td>
				            <c:forEach begin="1" end="${t.level}">
				                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				            </c:forEach>
				            <c:if test="${t.taskParent != 0}">
				            	<i class="ti ti-corner-down-right"></i>
				            </c:if>
				            <c:if test="${t.childCount > 0}">
				                <span class="toggle-btn" style="cursor:pointer;">[-]</span>
				            </c:if>
				            <!-- 작업 타이틀 -->
				            <a href="#" 
				            	class="link-dark" 
			            		data-bs-target="#offcanvasScrolling" 
			            		aria-controls="offcanvasScrolling">
			            		${t.taskTitle}
		            		</a>
		            		
		            		<!-- 자식 작업 수 -->
				            <c:if test="${t.childCount > 0}">(${t.childCount})</c:if>
				        </td>
				        <td>
       						<c:choose>
								<c:when test="${t.taskStatus eq 'REQUEST'}">
									<span class="badge badge-soft-primary p-1">요청</span>
								</c:when>
								<c:when test="${t.taskStatus eq 'PROGRESS'}">
									<span class="badge badge-soft-success p-1">진행</span>
								</c:when>
								<c:when test="${t.taskStatus eq 'FEEDBACK'}">
									<span class="badge badge-soft-danger p-1">피드백</span>
								</c:when>
								<c:when test="${t.taskStatus eq 'COMPLETED'}">
									<span class="badge badge-soft-secondary p-1">완료</span>
								</c:when>
							</c:choose>
				        </td>
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
				        <td>${t.writerName}</td>
				    </tr>
				</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
	<!-- 업무 리스트 끝 -->
	
	<!-- 업무 상세 -->
	<div class="offcanvas offcanvas-end border" style="width:33%" data-bs-scroll="true" data-bs-backdrop="false" tabindex="-1" id="offcanvasScrolling" aria-labelledby="offcanvasScrollingLabel" aria-modal="true" role="dialog">
		<div class="offcanvas-header border" style="height:3%">
		    <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
		</div> <!-- end offcanvas-header-->
		<div class="offcanvas-body">
			<div class="row">
				<div class="col-lg-2">
					<img src="/HTML/Admin/dist/assets/images/default_profile.png" alt="image" class="img-fluid avatar-lg rounded">
				</div>
				<div class="col-lg-4">
					<span id="detail-writer">이름</span>
				</div>
				<!-- 업무 수정 버튼 -->
				<div class="col-lg-2">
					<button class="btn btn-primary mt-2 mt-md-0" id="modifyBtn" onclick="openModifyTaskModal()" data-bs-dismiss="offcanvas" aria-label="Close">업무 수정</button>
				</div>
					<!-- 업무 수정 버튼 클릭하고 모달창 생성 -->
					<script>
						function openModifyTaskModal(taskId) {
						    $("#scrollable-modal .modal-content").load("/modifyTask?id=" + taskId, function() {
						        var modalEl = document.getElementById('scrollable-modal');
						        var myModal = new bootstrap.Modal(modalEl); 
						        myModal.show();
						        
						     	// 모달 로드 후 JS 초기화
						        initTaskModalJS(${projectId});
						    });
						}
					</script>
				<!-- 하위 업무 등록 버튼 -->
				<div class="col-lg-2">
					<a href="javascript:void(0)"
					   id="addChildTaskBtn"
					   onclick="openAddTaskModal()"
					   class="btn btn-primary mb-sm-0 mb-2">
					    하위 업무
					</a>
				</div>
				<!-- 업무 삭제 버튼 -->
				<div class="col-lg-2">
		    		<button class="btn btn-danger mt-2 mt-md-0"
		    				id="deleteTaskBtn"
		    				onclick="deleteTask()">업무 삭제</button>
		    		
				</div>
			</div>
		    <h4 class="mt-3" id="detail-title">업무 제목</h4>
		    <hr>
		    
		    <div class="row">
		    	<label for="detail-member" class="form-label">담당자</label>
				<div class="choices" data-type="text">
                	<div class="choices__inner">
                		<input readonly="readonly" class="form-control choices__input" id="choices-text-remove-button" data-choices="" data-choices-limit="3" data-choices-removeitem="" type="text" value="Task-1" hidden="" tabindex="-1" data-choice="active">
                			<div id="detail-member" class="choices__list choices__list--multiple">
                			
                			</div>
                		<input type="search" class="choices__input choices__input--cloned" autocomplete="off" autocapitalize="off" spellcheck="false" aria-autocomplete="list" aria-label="Set limit values with remove button" style="min-width: 1ch; width: 1ch;">
               		</div>
           		</div>		    	
					    
				<div class="col-lg-3">
					상태
				</div>
				<div class="col-lg-6">
					<span id="detail-status"></span>
				</div>
			</div>
			
			<div class="row">
				<div class="col-lg-3">
					시작일
				</div>
				<div class="col-lg-6">
					<span id="detail-startDate"></span>
				</div>
			</div>
			
			<div class="row">
				<div class="col-lg-3">
					마감일
				</div>
				<div class="col-lg-6">
					<span id="detail-dueDate"></span>		
				</div>
			</div>
			
			<hr>
			
			<div>
				<!-- 작업 설명 -->
				<span id="detail-desc"></span>
				
				<!-- 첨부된 이미지 프리뷰 -->
				<div id="detail-image">
				
				</div>
				
				<!-- 첨부된 파일 다운 받는 공간 -->
				<div id="detail-file">
					
				</div>
			</div>
			<hr>
			<div id="detail-comment">

			</div>
		</div> <!-- end offcanvas-body-->
		
		<!-- 댓글 입력 폼 -->
		<div class="offcanvas-footer" style="height:18%">
			<div class="row" style="margin-left:0px; height:55px">
				<div class="col-lg-2">
					<!-- 여백 -->
				</div>
				<!--  @ 멘션 리스트 -->
				<div id="mentionList" 
				     class="col-lg-9 rounded bg-light" 
				     style="display:none; max-height:55px; overflow-y:auto; z-index:1000;">
				</div>
			</div>
			<div class="row">
				<!-- 사원 프로필 -->
				<div class="col-lg-2">
					<img src="/HTML/Admin/dist/assets/images/default_profile.png" alt="image" class="img-fluid avatar-xl rounded">
				</div>				
				<!-- 댓글 입력 부분 -->
				<div class="col-lg-10">
					<div class="input-group">
					<input type="hidden" id="writerId" name="writerId" value="${loginEmp.empId}">
					<input type="hidden" id="taskId" name="taskId" value="${loginEmp.empId}">
                    <textarea rows="3" class="form-control" id="taskCommentContent" name="taskCommentContent" placeholder="댓글 입력."></textarea>
					<button class="btn btn-primary btn-sm" id="addCommetBtn">작성</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 스크립트 -->
	<script src="${pageContext.request.contextPath}/resources/js/getTask.js"></script>
	
	<script>
    const projectId = ${projectId};

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
	</script>