// taskList.jsp에서 사용중

// 요소 찾기
const taskTitle = document.querySelector('#detail-title');
const taskStartDate = document.querySelector('#detail-startDate');
const taskDueDate = document.querySelector('#detail-dueDate');
const taskDesc = document.querySelector('#detail-desc');
const taskStatus = document.querySelector('#detail-status');
const taskWriter = document.querySelector('#detail-writer');
const taskMember = document.querySelector('#detail-member');
const modifyBtn = document.getElementById("modifyBtn");

// 작업 클릭되었을 떄
document.addEventListener("click", function (e) {
  const link = e.target.closest("a.link-dark"); 
  if (!link) return; // a.link-dark 클릭 아닐 때 무시

  e.preventDefault(); // a 태그 기본 동작(#, 새로고침 등 방지)

  // 부모 tr 찾아가기
  const tr = link.closest("tr.task-row");
  if (!tr) return;

  // data-task-* 읽기
  const id = tr.dataset.taskId; // data-task-id -> dataset.taskId
  const title = tr.dataset.taskTitle; 
  let status = tr.dataset.taskStatus; 
  const startDate = tr.dataset.taskStartDate; 
  const dueDate = tr.dataset.taskDueDate;
  const desc = tr.dataset.taskDesc;
  const writer = tr.dataset.taskWriter;
  
  // 실제 값 보여주기
  
  switch(status){
	case 'PROGRESS':
		status = '진행';
		break;
	case 'FEEDBACK':
		status = '피드백';
		break;
	case 'REQUEST':
			status = '요청';
			break;
	case 'COMPLETED':
		status = '완료';
		break;
  }
  
  taskStatus.textContent = status;
  taskTitle.textContent = title;
  taskDesc.textContent = desc;
  taskStartDate.textContent = startDate;
  taskDueDate.textContent = dueDate;
  taskWriter.textContent = writer;
  modifyBtn.onclick = function() { openModifyTaskModal(id); // 이 id는 tr.dataset.taskId
	
  };
  
  // 첨부 파일 불러오기
  
  // 댓글 불러오기
  
  // 담당자 불러오기  
  fetch('/selectTaskMemberByTaskId/' + id)
	.then(function(res){
		return res.json();
	})
	.then(function(result) {
		taskMember.innerHTML = ``;
		if(result.length < 1){
			document.querySelector('#empList').innerHTML = `담당자가 없습니다.`;	
			return;
		}
		
		result.forEach(e => {
            taskMember.innerHTML += `
                <div class="member-btn choices__item choices__item--selectable" data-id="${e.id}">
                    <img src="/HTML/Admin/dist/assets/images/default_profile.png" alt="image" class="img-fluid avatar-xs rounded">
                    ${e.empName}
                </div>
            `;
        });
	});
	
	
	
});