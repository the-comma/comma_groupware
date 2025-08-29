// addTask.jsp 에서 사용
// modifyTask.jsp 에서 사용

// 모달 로드 후 실행할 초기화 함수
function initTaskModalJS(projectId, parentId) {	
    const selectedEmp = new Set();
	const existingFiles = new Set(); // 기존 파일 ID 관리
    
    const hl = document.querySelector('#hiddentList');
    const empNameInput = document.querySelector('#empName');
    const empList = document.querySelector('#empList');
    const memberList = document.querySelector('#memberList');
    const fileInput = document.getElementById('formFileMultiple01');
    const filePreview = document.getElementById('filePreview');
	const newFilePreview = document.getElementById('newFilePreview');
	const taskStatusSelect = document.getElementById('taskStatus');
	
	if(projectId != null){	
		document.querySelector('#projectId').value = projectId;
	}	
	if(parentId != null){		
		document.querySelector('#parentId').value = parentId;
	}
	
    // 프로젝트 참여자 리스트 ('') => 전체
    getMemberList('');
	
	// 기존 참여자 초기화 
    const hiddenInputs = hl.querySelectorAll('input[name="selectedEmp"]');
	hiddenInputs.forEach(input => {
	    selectedEmp.add({
	        id: input.value,		 // value에서 아이디 가져오기
	        name: input.dataset.name // data-name에서 이름 가져오기
	    });
	});

    renderMemberList(); // 기존 참여자 반영

    // input 이벤트
    empNameInput.addEventListener('keyup', function() {
        getMemberList(this.value);
    });

    // 멤버 리스트 가져오기
    function getMemberList(searchName) {
        let url = '/memberListByProjectId/' + projectId;
        if (searchName) url += '/' + searchName;

        fetch(url)
            .then(res => res.json())
            .then(result => {
                empList.innerHTML = '';
                if (result.length < 1) return;

                result.forEach(e => {
                    const checked = [...selectedEmp].some(item => item.id === String(e.empId)) ? "checked" : "";

                    empList.innerHTML += `
                        <tr>
                            <td><input type="checkbox" class="emp form-check-input" value="${e.empId}" data-name="${e.empName}" ${checked}></td>
                            <td><img src="/HTML/Admin/dist/assets/images/default_profile.png" alt="image" class="img-fluid avatar-xs rounded"></td>
                            <td>[${e.projectRole}]</td>
                            <td>${e.empName}</td>
                            <td>${e.rankName}</td>
                        </tr>
                    `;
                });
            });
    }

    // 체크박스 선택 이벤트 위임
    empList.addEventListener('change', function(e) {
        if (!e.target.classList.contains('emp')) return;

        if (e.target.checked) {
            selectedEmp.add({id: e.target.value, name: e.target.dataset.name});
        } else {
            [...selectedEmp].forEach(item => {
                if (item.id === e.target.value) selectedEmp.delete(item);
            });
        }

        renderMemberList();
    });

    // 선택 멤버 렌더링
    function renderMemberList() {
        memberList.innerHTML = "";
        hl.innerHTML = '';

        selectedEmp.forEach(e => {
            hl.innerHTML += `<input type="hidden" name="selectedEmp" value="${e.id}">`;
            memberList.innerHTML += `
                <div class="member-btn choices__item choices__item--selectable" data-id="${e.id}">
                    <img src="/HTML/Admin/dist/assets/images/default_profile.png" alt="image" class="img-fluid avatar-xs rounded">
                    ${e.name}
                    <button type="button" class="member-btn choices__button" data-id="${e.id}" aria-label="Remove item">Remove item</button>
                </div>
            `;
        });
    }

    // memberList에서 버튼 클릭 → 제거
    memberList.addEventListener('click', function(e){
        if(!e.target.classList.contains('member-btn')) return;

        const id = e.target.dataset.id;
        [...selectedEmp].forEach(item => { if(item.id === id) selectedEmp.delete(item); });

        document.querySelectorAll(`input[value="${id}"]`).forEach(cb => cb.checked = false);

        renderMemberList();
    });
	
	// 초기 기존 파일 Set에 추가
	document.querySelectorAll('.existing-file').forEach(div => {
	    existingFiles.add(div.dataset.fileid);
	});
	

	// 새 파일 선택 시 프리뷰
	if(fileInput && filePreview){
	    fileInput.addEventListener('change', function(event){
	        const files = event.target.files;
			newFilePreview.innerHTML = '';
			
	        // 새 파일 전용 프리뷰 영역
	        Array.from(files).forEach(file => {
	            const sizeKB = (file.size / 1024).toFixed(1);

	            let previewHTML = `
	                <div class="mb-2 p-2 border rounded new-file">
	                    <p>${file.name} (${sizeKB} KB)
	                    </p>
	            `;

	            // 이미지일 경우 썸네일
	            if(file.type.startsWith("image/")){
	                const reader = new FileReader();
	                reader.onload = e => {
	                    previewHTML += `<img src="${e.target.result}" class="img-thumbnail mt-1" style="max-width:150px; max-height:150px;"></div>`;
	                    newFilePreview.innerHTML += previewHTML;
	                };
	                reader.readAsDataURL(file);
	            } else {
	                previewHTML += `</div>`;
	                newFilePreview.innerHTML += previewHTML;
	            }
	        });
	    });
	}

	// 기존 파일 삭제 버튼
	document.getElementById("filePreview").addEventListener("click", function(e){	
	    if (e.target.closest('.remove-existing-file')) {
			if (!confirm("정말 삭제하시겠습니까?")) return;
			
			// 삭제할 div는 무조건 .existing-file
	        const fileDiv = e.target.closest('.existing-file');
	        const fileId = fileDiv.dataset.fileid;

			fetch('/deleteTaskFileByFileId/'+fileId)
		    .then(res => res.json())
		    .then(result => {
		        if(result){
					existingFiles.delete(fileId); // Set에서 제거
			        fileDiv.remove();
				}
				else{
					alert('파일 삭제에 실패 했습니다.');	
				}
		    });
	    }
	});

	
    // taskStatus 색깔 적용
    function updateStatusColor() {
        const selectedOption = taskStatusSelect.options[taskStatusSelect.selectedIndex];
        // 기존 badge-soft-* 제거
        taskStatusSelect.classList.remove('badge-soft-primary', 'badge-soft-success', 'badge-soft-danger', 'badge-soft-secondary');
        // 선택된 option 클래스 적용
        selectedOption.classList.forEach(cls => {
            if (cls.startsWith('badge-soft-')) {
                taskStatusSelect.classList.add(cls);
            }
        });
    }

    // 초기 상태 적용
    updateStatusColor();
    // 상태 변경 이벤트
    taskStatusSelect.addEventListener('change', updateStatusColor);
}

// task 삭제
function deleteTask(taskId){
	if(!confirm("작업을 삭제 하시겠습니까? 하위 작업도 함께 삭제 됩니다.")){
		return;
	}
	
	fetch('/deleteTaskByTaskId/'+taskId)
    .then(res => res.json())
    .then(result => {
        if(result){
			window.location.reload();
		}
		else{
			alert('작업 삭제에 실패 했습니다.');	
		}
    });
	
}