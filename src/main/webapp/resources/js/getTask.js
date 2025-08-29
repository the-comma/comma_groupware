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

// 댓글 요소
const taskComment = document.getElementById('detail-comment');
const addCommetBtn = document.getElementById("addCommetBtn");
const commentTaskId = document.getElementById("taskId");
const writerId = document.getElementById("writerId");
const taskCommentContent = document.getElementById("taskCommentContent");

// 상세 페이지 요소
const offcanvasEl = document.getElementById('offcanvasScrolling');
const bsOffcanvas = new bootstrap.Offcanvas(offcanvasEl);

// 작업 클릭되었을 때 작업 상세 페이지 로드
document.addEventListener("click", function (e) {
	canvasInit(e);
});

// 댓글 달기
addCommetBtn.addEventListener("click", function(){
	if(taskCommentContent.value === ''){
		alert("내용을 입력해 주세요");
		return;
	}
	
	fetch('/addComment', {
	    method: 'POST',               // GET, POST, PUT, DELETE 등 선택
	    headers: {
	        'Content-Type': 'application/json'
	    },
	    body: JSON.stringify({
			taskId: commentTaskId.value,
	        writerId: writerId.value,
	        taskCommentContent: taskCommentContent.value			
	    })
	})
	.then(res => res.json())  // 서버에서 boolean 리턴 → JS에서 true/false 로 파싱됨
	.then(success => {
	    if (success) {
			commentLoad(commentTaskId.value);			
			taskCommentContent.value = '';
	    } else {
	        console.log("실패");
	    }
	});
	
});

// 상세 페이지 init
function canvasInit(e){
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

	// 댓글 작성 부분에 히든 taskId 값 할당
	commentTaskId.value = id;
	taskCommentContent.value = '';
	
	// task 로드
	taskLoad(id,title,status,desc,startDate,dueDate,writer);

	// 첨부 파일 불러오기
	fileLoad(id);

	// 댓글 불러오기
	commentLoad(id);

	// 댓글 eventListener
	commentEvent(id);
	
	// 담당자 불러오기  
	memberLoad(id);
}

// 작업 상세 load
function taskLoad(id,title,status,desc,startDate,dueDate,writer){

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
	modifyBtn.onclick = function() { openModifyTaskModal(id)}; // 이 id는 tr.dataset.taskId  
}

// 파일 load
function fileLoad(id){
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
}

// 담당자 load
function memberLoad(id){
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
}

// 댓글 load
function commentLoad(id){
	fetch('/selectTaskCommentByTaskId/' + id)
	.then(function(res){
		return res.json();
	})
	.then(function(result) {
		taskComment.innerHTML = ``;
		if(result.length < 1){
			return;
		}
		
		// 멘션 정규식 : @로 시작하고 ;로 끝나는 구간 감지
		const mentionRegex = /@([^;\s]+);/g;
		
		result.forEach(e => {
			const indent = e.depth * 30; // depth 1당 30px 들여쓰기
	        const replyBtn = e.depth === 0 
	            ? `<a href="#" class="reply-btn text-muted"><i class="ti ti-corner-down-right"></i> 답글</a>` 
	            : ``; // depth가 0일 때만 답글 버튼 보이기
			const isReply = e.depth > 0 
				? `<i class="ti ti-corner-down-right"></i>`
				: ``;
				
				const highlightedContent = e.taskCommentContent.replace(mentionRegex, (match, p1) => {
				    return `<span class="mention-tag text-primary fw-bold">@${p1}</span>`; 
				});
					
	        taskComment.innerHTML += `
	            <div class="d-flex align-items-top mb-3 comment-item" 
	                 data-id="${e.taskCommentId}" 
	                 style="margin-left:${indent}px">
					${isReply}                
	                <img src="/HTML/Admin/dist/assets/images/default_profile.png" 
	                     alt="image" 
	                     class="flex-shrink-0 comment-avatar avatar-sm rounded me-2">
	                
	                <div class="flex-grow-1">
	                    <h5 class="mt-0">
	                        <a href="#" class="text-dark">${e.empName}</a>
	                        <small class="ms-1 text-muted">${e.createdAt}</small>
	                        <small class="ms-1 text-muted edit-btn" style="cursor:pointer;">수정</small>
	                        <small class="ms-1 text-muted delete-btn" style="cursor:pointer;">삭제</small>
	                    </h5>
						<p class="comment-content">${highlightedContent}</p>
	
	                    <div class="d-flex gap-2 align-items-center fs-14">
	                        ${replyBtn}
	                    </div>
						<div class="d-flex align-items-top mb-2">
						</div>
	                </div>
	            </div>
	        `;
        });
	});
}

// 댓글 이벤트 등록 (수정, 삭제, 답글)
function commentEvent(id){
	taskComment.addEventListener('click', function(e){
	    const commentDiv = e.target.closest('.comment-item');
	    if(!commentDiv) return;

	    // 댓글 수정 버튼
	    if(e.target.classList.contains('edit-btn')){			
			const contentEl = commentDiv.querySelector('.comment-content');
		    if(contentEl.querySelector('.edit-comment')) {
		        // 이미 수정 모드라면 무시
		        return;
		    }
		    const original = contentEl.textContent.trim();
		    contentEl.dataset.original = original;
		    contentEl.innerHTML = `
		        <input type="text" value="${original}" class="form-control edit-comment"></input>
		        <button class="btn btn-sm btn-primary save-edit mt-1">저장</button>
		        <button class="btn btn-sm btn-secondary cancel-edit mt-1">취소</button>
		    `;
	    }

	    // 댓글 수정 저장 버튼
	    if(e.target.classList.contains('save-edit')){
	        const textarea = commentDiv.querySelector('.edit-comment');
	        const newContent = textarea.value;
	        const commentId = commentDiv.dataset.id;

	        // fetch 로 업데이트 API 호출
	        fetch('/modifyComment', {
	            method: 'POST',
	            headers: { 'Content-Type': 'application/json' },
	            body: JSON.stringify(
					{ 
						taskCommentId: commentId, 
						taskCommentContent: newContent
					}
				)	
	        })
	        .then(res => res.json())
	        .then(success => {
	            if(success){
					// 수정 부분 바로 적용
	                commentDiv.querySelector('.comment-content').innerHTML = newContent;
	            } else {
	                alert('댓글 수정 실패 했습니다.');
	            }
	        });
	    }

	    // 수정 취소 버튼
	    if(e.target.classList.contains('cancel-edit')){
	        commentLoad(id); // 댓글 다시 로드
	    }

		// 댓글 삭제 버튼
		if(e.target.classList.contains('delete-btn')){
			if(!confirm('댓글을 삭제 하시겠습니까? 답글과 함께 삭제 됩니다')) return;
			
			const commentId = commentDiv.dataset.id;
			fetch('/deleteComment/' + commentId)
			.then(function(res){
				return res.json();
			})
			.then(function(result) {
				if(result){
					commentLoad(id); // 댓글 다시 로드
				}
				else{
					alert('댓글 삭제 실패 했습니다.');
				}
			});
	    }

		// 답글 버튼
		if(e.target.classList.contains('reply-btn')){
		    // 이미 답글창 있으면 중복 방지
		    if(commentDiv.querySelector('.reply-box')) return;

		    const replyBox = document.createElement('div');			
		    replyBox.classList.add('reply-box', 'mt-2');
			replyBox.style.width = '100%';
		    replyBox.innerHTML = `
			
			<div class="row">
				<div class="col-lg-2">
					<img src="/HTML/Admin/dist/assets/images/default_profile.png" alt="image" class="img-fluid avatar-sm rounded">
				</div>
				<!-- 댓글 입력 부분 -->
				<div class="col-lg-10">
					<div class="input-group">
                    <textarea rows="3" class="form-control reply-input" placeholder="답글을 입력하세요."></textarea>
					<button class="btn btn-sm btn-primary reply-save">등록</button>
		        	<button class="btn btn-sm btm-secondary reply-cancel"><i class="ti ti-x reply-cancel"></i></button>
					</div>
				</div>
					
				</button>
			</div>
		    `;

		    const replyContainer = commentDiv.querySelector('.d-flex.align-items-top.mb-2');
		    if(replyContainer){
		        replyContainer.appendChild(replyBox);
		    }
		}


		// 답글 등록
		if(e.target.classList.contains('reply-save')){
		    const replyBox = e.target.closest('.reply-box');
		    const input = replyBox.querySelector('.reply-input');
		    const replyContent = input.value.trim();
		    if(replyContent === '') return alert("내용을 입력하세요");

		    const parentId = commentDiv.dataset.id; // 부모 댓글 id

		    fetch('/addComment', {
		        method: 'POST',
		        headers: {'Content-Type':'application/json'},
				body: JSON.stringify({
					taskId: id,
			        writerId: writerId.value,
					taskCommentParent: parentId,
			        taskCommentContent: replyContent		
			    })
		    })
		    .then(res => res.json())
		    .then(result => {
		        if(result === true){
					taskCommentContent.value = '';
		            commentLoad(id); // 댓글 다시 로드
		        } else {
		            alert("답글 달기 실패 했습니다.");
		        }
		    });
		}

		// 답글 취소
		if(e.target.classList.contains('reply-cancel')){
		    const replyBox = e.target.closest('.reply-box');
		    replyBox.remove();
		}
		
	});	
}


// 댓글 입력 이벤트 감지
taskCommentContent.addEventListener('keyup', function(e){
    const cursorPos = taskCommentContent.selectionStart;
    const textBeforeCursor = taskCommentContent.value.substring(0, cursorPos);

    // @ 뒤 단어 추출 (예: "@장하")
    const match = textBeforeCursor.match(/@([\w가-힣]*)$/);
    if(!match){
        mentionList.style.display = "none";
        return;
    }

    const keyword = match[1]; // @ 다음 글자
    let url = '/memberListByProjectId/' + projectId;
    if(keyword) url += '/' + keyword;

    // 서버 검색
    fetch(url)
        .then(res => res.json())
        .then(list => {
            if(list.length === 0){
                mentionList.style.display = "none";
                return;
            }
            // 목록 렌더링
            mentionList.innerHTML = list.map(emp => `
                <div class="mention-item p-1" 
                     data-name="${emp.empName}" 
                     style="cursor:pointer;">
                    @${emp.empName}
                </div>
            `).join('');
            mentionList.style.display = "block";
        });
});

mentionList.addEventListener('click', function(e){
    if(!e.target.classList.contains('mention-item')) return;

    const name = e.target.dataset.name;
    const cursorPos = taskCommentContent.selectionStart;
    const textBeforeCursor = taskCommentContent.value.substring(0, cursorPos);

    // @뒤 keyword를 멘션으로 교체
    taskCommentContent.value = textBeforeCursor.replace(/@[\w가-힣]*$/, '@' + name + ';') 
                     + taskCommentContent.value.substring(cursorPos);

    mentionList.style.display = "none";
    textarea.focus();
});