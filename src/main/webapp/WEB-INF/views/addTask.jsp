<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>업무 추가 모달</title>
</head>
<body>
				<div class="modal-header">
	                <h4 class="modal-title" id="scrollableModalTitle">업무 작성</h4>
	                <button type="button" class="btn-close" data-bs-dismiss="modal"
	                    aria-label="Close"></button>
	            </div>
	            <div class="modal-body">
				<form action="/addTask" method="post" name="addTask" id="addTask" enctype="multipart/form-data">
	            	<input type="hidden" id="projectId" name ="projectId" value="${projectId}">
	            	<input type="hidden" id="parentId" name ="parentId" value="">
	            	
	            	<input type="hidden" name ="writerId" value="${loginEmp.empId}">
	            	
					<input type="text" class="form-control" name="taskTitle" placeholder="제목을 입력하세요.">
					<br>
					<label for="taskStatus" class="form-label">상태</label>
	                <select class="form-control" id="taskStatus" name="taskStatus">
	                	<option value="REQUEST" class="badge badge-soft-primary p-1">요청</option>
	                	<option value="PROGRESS" class="badge badge-soft-success p-1">진행</option>
	                	<option value="FEEDBACK" class="badge badge-soft-danger p-1">피드백</option>
	                	<option value="COMPLETED" class="badge badge-soft-secondary p-1">완료</option>
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
					
					<!-- 새로운 추가 파일 -->
					<div id="newFilePreview">
					
					</div>
				</form>
	            </div> <!-- modal-body -->
	            <div class="modal-footer">
	                <button type="button" class="btn btn-outline-danger"
	                    data-bs-dismiss="modal">취소</button>
	                <button type="button" class="btn btn-outline-success" id="modalBtn">등록</button>
	            </div>
	            	            
				<script>
				document.getElementById('modalBtn').addEventListener('click', function() {
				    // form submit
				    document.getElementById('addTask').submit();
				});
				</script>
</body>
</html>