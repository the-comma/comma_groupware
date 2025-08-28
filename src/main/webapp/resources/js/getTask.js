// taskList.jsp에서 사용중

// 요소 찾기
const taskTitle = document.querySelector('#detail-title');
const taskStartDate = document.querySelector('#detail-startDate');
const taskDueDate = document.querySelector('#detail-dueDate');
const taskDesc = document.querySelector('#detail-desc');
const taskFile = document.querySelector('#detail-file');
const taskStatus = document.querySelector('#detail-status');
const taskWriter = document.querySelector('#detail-writer');
const taskMember = document.querySelector('#detail-member');
const taskImage = document.querySelector('#detail-image');
const modifyBtn = document.getElementById("modifyBtn");
const addChildTaskBtn = document.getElementById("addChildTaskBtn");
const deleteTaskBtn = document.getElementById("deleteTaskBtn");

const offcanvasEl = document.getElementById('offcanvasScrolling');
const bsOffcanvas = new bootstrap.Offcanvas(offcanvasEl);

// 작업 클릭되었을 때
document.addEventListener("click", function (e) {
  const link = e.target.closest("a.link-dark"); 
  if (!link) return; // a.link-dark 클릭 아닐 때 무시

  e.preventDefault(); // 기본 토글 막기

  // 이미 show 상태면 무시 (닫히지 않게 유지)
  if (!offcanvasEl.classList.contains('show')) {
      bsOffcanvas.show();
  }

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
  addChildTaskBtn.onclick = function(){ openAddTaskModal(id) }
  deleteTaskBtn.onclick = function() { deleteTask(id) };
  modifyBtn.onclick = function() { openModifyTaskModal(id); // 이 id는 tr.dataset.taskId  
  };
  
  // 첨부 파일 불러오기
  fetch('/selectTaskFileByTaskId/' + id)
  	.then(function(res){
  		return res.json();
  	})
  	.then(function(result) {
		taskFile.innerHTML = '';
		taskImage.innerHTML = '';
		if(result.length < 1){
			return;
		}
		
		result.forEach(f => {
			  const savedFileName = `${f.fileName}.${f.fileExt}`; // uuid.확장자
			  
			  // 이미지 확장자인지 확인
			  const isImage = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].includes(f.fileExt.toLowerCase());
			  
			  // 파일이 이미지
			  if(isImage){
                taskImage.innerHTML += `
                    <div class="mb-2">
                        <img src="/upload/${savedFileName}" alt="${f.fileOriginName}" class="img-fluid rounded" style="max-width: 200px; max-height: 200px;">
                    </div>
                `;
			  }
			  // 그 외
			  else{
			      taskFile.innerHTML += `
			        <div class="d-flex align-items-center mb-2 p-2 border rounded">
			          <div class="flex-grow-1">
			            <a href="/upload/${savedFileName}" 
			               download="${f.fileOriginName}" 
			               class="fw-bold text-decoration-none">
			               ${f.fileOriginName}
			            </a>
			            <small class="text-muted"> (${(f.fileSize/1024).toFixed(1)} KB)</small>
			          </div>
			          <div>
			            <a href="/upload/${savedFileName}" 
			               download="${f.fileOriginName}" 
			               class="btn btn-sm btn-outline-primary">
			               <i class="bi bi-download"></i> 다운로드
			            </a>
			          </div>
			        </div>
			      `;
			  }
		})
  	});
  
  // 댓글 불러오기
  
  // 담당자 불러오기  
  fetch('/selectTaskMemberByTaskId/' + id)
	.then(function(res){
		return res.json();
	})
	.then(function(result) {
		taskMember.innerHTML = ``;
		if(result.length < 1){
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