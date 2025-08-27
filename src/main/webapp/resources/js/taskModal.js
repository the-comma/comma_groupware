// addTask.jsp 에서 사용
// modifyTask.jsp 에서 사용

// 모달 로드 후 실행할 초기화 함수
function initTaskModalJS(projectId) {
    const selectedEmp = new Set();
    const hl = document.querySelector('#hiddentList');
    
    const empNameInput = document.querySelector('#empName');
    const empList = document.querySelector('#empList');
    const memberList = document.querySelector('#memberList');
    const fileInput = document.getElementById('formFileMultiple01');
    const filePreview = document.getElementById('filePreview');
	const taskStatusSelect = document.getElementById('taskStatus');
	
	document.querySelector('#projectId').value = projectId;

	
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

    // 파일 프리뷰
    if(fileInput && filePreview){
        fileInput.addEventListener('change', function(event) {
            const files = event.target.files;
            filePreview.innerHTML = "";

            Array.from(files).forEach(file => {
                const fileDiv = document.createElement("div");
                fileDiv.classList.add("mb-2", "p-2", "border", "rounded");

                // 파일 이름 + 크기 표시
                const info = document.createElement("p");
                info.textContent = `${file.name} (${(file.size / 1024).toFixed(1)} KB)`;
                fileDiv.appendChild(info);

                // 이미지 파일이면 썸네일
                if (file.type.startsWith("image/")) {
                    const img = document.createElement("img");
                    img.classList.add("img-thumbnail", "mt-1");
                    img.style.maxWidth = "150px";
                    img.style.maxHeight = "150px";

                    const reader = new FileReader();
                    reader.onload = e => { img.src = e.target.result; };
                    reader.readAsDataURL(file);

                    fileDiv.appendChild(img);
                }

                filePreview.appendChild(fileDiv);
            });
        });
    }
	
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