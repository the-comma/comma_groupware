
  // 단일 선택 전용 상태
  let selectedUser = null; // { id: "123", name: "홍길동" } 형태

  // 부서/팀 선택 시 사원 목록 로드
  document.querySelector('#deptTeam').addEventListener('change', function () {
    if (this.value === '') {
      alert('부서/팀을 선택하세요');
      return;
    }

    fetch('/empListByTeam/' + this.value)
      .then(res => res.json())
      .then(result => {
        const $head = document.querySelector('#empTableHead');
        const $list = document.querySelector('#empList');

        if (!result || result.length < 1) {
          $head.innerHTML = '';
          $list.innerHTML = '';
          document.querySelector('#empTableHead').innerHTML = '해당 부서/팀에 사원이 없습니다.';
          return;
        }

        // 테이블 헤더(필요 시 원하는 컬럼으로 조절)
        $head.innerHTML = `
          <tr>
            <th style="width:80px">선택</th>
            <th style="width:60px">사진</th>
            <th style="width:120px">직급</th>
            <th>이름</th>
          </tr>
        `;

        // 사원 목록 렌더
        $list.innerHTML = '';
        result.forEach(e => {
          const checked = selectedUser && String(selectedUser.id) === String(e.empId) ? 'checked' : '';
          $list.innerHTML += `
            <tr>
              <td>
                <input type="checkbox" class="pick form-check-input"
                       value="${e.empId}" data-name="${e.empName}" ${checked}>
              </td>
              <td>
                <img src="/HTML/Admin/dist/assets/images/default_profile.png"
                     alt="image" class="img-fluid avatar-xs rounded">
              </td>
              <td>[${e.rankName}]</td>
              <td>${e.empName}</td>
            </tr>
          `;
        });
      });
  });

  // === 체크박스: 전체 중 무조건 1명만 유지 ===
  let isHandling = false;
  document.querySelector('#empList').addEventListener('change', function (e) {
    const t = e.target;
    if (!t.classList.contains('pick')) return;
    if (isHandling) return;
    isHandling = true;

    const id = t.value;
    const name = t.dataset.name;

    if (t.checked) {
      // 나 빼고 전부 해제
      this.querySelectorAll('.pick').forEach(cb => { if (cb !== t) cb.checked = false; });
      // 현재만 선택 상태로 저장
      selectedUser = { id, name };
    } else {
      // 체크 해제 시 선택 비움
      selectedUser = null;
    }

    renderMemberList();
    isHandling = false;
  });

  // 미리보기 영역 렌더
  function renderMemberList() {
    const $preview = document.querySelector('#memberList');
    $preview.innerHTML = '';

    if (!selectedUser) return;

    $preview.innerHTML = `
      <div class="member-btn choices__item choices__item--selectable" data-id="${selectedUser.id}">
        ${selectedUser.name}
        <button type="button" class="member-btn choices__button" data-id="${selectedUser.id}">
          Remove item
        </button>
      </div>
    `;
  }

  // 미리보기에서 제거 버튼 클릭 시 선택 해제
  document.querySelector('#memberList').addEventListener('click', function (e) {
    if (!e.target.classList.contains('member-btn')) return;

    const id = e.target.dataset.id;
    // 상태 비움
    selectedUser = null;
    // 체크박스도 해제
    document.querySelectorAll(`input.pick[value="${id}"]`).forEach(cb => cb.checked = false);
    renderMemberList();
  });

  // 최종 등록 버튼: 선택 결과를 출력(표시 + hidden input)
  document.querySelector('#modalBtn').addEventListener('click', function () {
    
	
	// ★ 폼 참조를 추가하세요
	const form = document.querySelector('#create1to1Form');
	if (!form) {
	  console.error('create1to1Form 를 찾을 수 없습니다.');
	  return;
	}
	
	
	// 표시/히든 출력용 컨테이너 (없으면 기존 feList/feListBox로 폴백)
    const $list = document.querySelector('#targetList') || document.querySelector('#feList');
    const $box  = document.querySelector('#targetListBox') || document.querySelector('#feListBox');

    if ($list) $list.innerHTML = '';
    if ($box)  $box.innerHTML  = '';

    if (selectedUser) {
      if ($list) {
        $list.innerHTML = `
          <div class="choices__item choices__item--selectable">
            ${selectedUser.name}
          </div>
        `;
      }
      if ($box) {
        // 서버에서 받을 파라미터명을 맞춰주세요 (예: chatTargetId)
        $box.innerHTML = `
          <input type="hidden" name="chatTargetId" value="${selectedUser.id}">
        `;
      }
	  
	  form.submit();
    }

    // 모달 닫기
    const modalEl = document.querySelector('#scrollable-modal');
    if (window.bootstrap && modalEl) {
      const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
      modal.hide();
    }
  });

