<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>

	<!-- CSS -->
	<jsp:include page ="../views/nav/head-css.jsp"></jsp:include>
	
   	<!-- App 아이콘 -->
	<link rel="shortcut icon" href="/HTML/Admin/dist/assets/images/favicon.ico">
	
<meta charset="UTF-8">
<title>프로젝트 생성</title>
</head>
<body>
    <!-- 페이지 시작 -->
    <div class="wrapper">

	<!-- 사이드바 -->
	<jsp:include page ="../views/nav/sidenav.jsp"></jsp:include>
	
	<!-- 헤더 -->
	<jsp:include page ="../views/nav/header.jsp"></jsp:include>
	
        <div class="page-content">

            <div class="page-container">
            
            	<div class="container">
            	<!-- 본문 내용 -->
            	
            	<div class="row">
                    <div class="col-16">
                        <div class="card">
                            <div class="card-header border-bottom border-dashed d-flex align-items-center">
                                <h4 class="header-title">프로젝트 추가</h4>
                            </div>

                            <div class="card-body">
                                <p class="text-muted">
	                            	<!-- 부가 설명 -->
                                </p>
                                <div class="row">
                                    <div class="col-lg-12">
                                        <form action="/addProject" method="post" id="project" name="project">
											<label for="empName">PM</label>
											<input type="text" id="empName" name="empName" value=""><br>
											
											<label for="projectTitle">프로젝트 명</label>
											<input type="text" id="projectTitle" name="projectTitle" placeholder="프로젝트 명 입력.."><br>
											
											<label for="projectDesc">설명</label>
											<textarea rows="10" cols="20" id="projectDesc" name="projectDesc"></textarea><br>
											
											<label for="projectGitUrl">Github URL</label>
											<input type="text" id="projectGitUrl" name="projectGitUrl" placeholder="Git URL 입력.."><br>
											
											<label for="startDate">시작일</label>
											<input type="date" id="startDate" name="startDate"><br>
											
											<label for="endDate">마감일</label>
											<input type="date" id="endDate" name="endDate"><br>
											
											FE 개발자
											<!-- 추가 버튼 -->
						                    <button type="button" class="btn btn-secondary" data-bs-toggle="modal"
						                     data-bs-target="#scrollable-modal">추가</button>	<br>
						                     <input type="text" id="feList" readonly="readonly">
						                     <br>
											
											<!-- 모달 -->
											<div class="modal fade" id="scrollable-modal" tabindex="-1" role="dialog"
							                    aria-labelledby="scrollableModalTitle" aria-hidden="true">
							                    <div class="modal-dialog modal-dialog-scrollable" role="document">
							                        <div class="modal-content">
							                            <div class="modal-header">
							                                <h4 class="modal-title" id="scrollableModalTitle">개발자 추가</h4>
							                                <button type="button" class="btn-close" data-bs-dismiss="modal"
							                                    aria-label="Close"></button>
							                            </div>
							                            <div class="modal-body">
							                            	부서/팀<br>
							                                <select id="deptTeam" name="deptTeam">
							                                	<option value="">부서/팀 선택</option>
							                                	<c:if test="${deptTeamList != null}">
							                                		<c:forEach items="${deptTeamList}" var="dept">
							                                			<option value="${dept.teamName}">${dept.deptName}/${dept.teamName}</option>
													                </c:forEach>
							                                	</c:if>
							                                </select>
							                                
							                                <br>사원<br>
							                                <table>
							                                	<thead>
							                                		<tr>
							                                			<td>FE</td>
							                                			<td>BE</td>
							                                			<td>기획자</td>
							                                		</tr>
							                                	</thead>
							                                	<tbody id="empList" name="empList">
							                                	</tbody>
							                                </table>	 
							                                
							                                <div id="memberList">
							                                
							                                </div>                               
							                                <br>
							                                <br>
							                                <br>
							                                <br>
							                                <br>
							                            </div>
							                            <div class="modal-footer">
							                                <button type="button" class="btn btn-secondary"
							                                    data-bs-dismiss="modal">취소</button>
							                                <button type="button" class="btn btn-primary" id="modalBtn">등록</button>
							                            </div>
							                        </div><!-- /.modal-content -->
							                    </div><!-- /.modal-dialog -->
							                </div><!-- /.modal -->
											
											BE 개발자<br>
						                    <input type="text" id="beList" readonly="readonly">
						                    <br>
											
											기획자<br>
											<input type="text" id="plList" readonly="readonly">
											<br>
											
											<!-- FE, BE, PL 리스트 들어갈 영역 -->
											<div id="feListBox"></div>
											<div id="beListBox"></div>
											<div id="plListBox"></div>
											
											<button type="submit">생성</button>
										</form>
                                    </div> <!-- end col -->
                                </div>
                                <!-- end row-->
                            </div> <!-- end card-body -->
                        </div> <!-- end card -->
                    </div><!-- end col -->
                </div><!-- end row -->
            	
            	
            	<!-- 본문 내용 끝 -->
            
            	</div><!-- container 끝 -->
            	
            	<!-- 푸터 -->
            	<jsp:include page ="../views/nav/footer.jsp"></jsp:include>
            	
            </div><!-- page-container 끝 -->
            
       	</div><!-- page-content 끝 -->
       	
   </div><!-- wrapper 끝 -->
   
   <!-- 자바 스크립트 -->
   
   <script>
 		// 선택된 멤버를 저장할 Set (중복 방지)
		const selectedFE = new Set();
		const selectedBE = new Set();
		const selectedPL = new Set();
    
    	document.querySelector('#deptTeam').addEventListener('change',function() {
    		if(this.value == ''){
    			alert('부서/팀을 선택하세요');
    			return;
    		}

		fetch('/empListByTeam/'+this.value)
		.then(function(res){
			return res.json();
		})
		.then(function(result) {
			document.querySelector('#empList').innerHTML = '';
			result.forEach(function(e){
				const feChecked = [...selectedFE].some(item => item.id === String(e.empId)) ? "checked" : "";
		        const beChecked = [...selectedBE].some(item => item.id === String(e.empId)) ? "checked" : "";
		        const plChecked = [...selectedPL].some(item => item.id === String(e.empId)) ? "checked" : "";
				
			    document.querySelector('#empList').innerHTML += `
			        <tr>
			            <td><input type="checkbox" class="fe" value="\${e.empId}" data-name="\${e.empName}" \${feChecked}></td>
			            <td><input type="checkbox" class="be" value="\${e.empId}" data-name="\${e.empName}" \${beChecked}></td>
			            <td><input type="checkbox" class="pl" value="\${e.empId}" data-name="\${e.empName}" \${plChecked}></td>
			            <td>[\${e.rankName}]</td>
			            <td>\${e.empName}</td>
			            <td>\${e.empExp}</td>
			        </tr>
			    `;
			});
		});
    	})
		
		// 체크박스 선택 이벤트 위임
		document.querySelector('#empList').addEventListener('change', function(e) {
		    if(e.target.classList.contains('fe')) {
		        if(e.target.checked){
		            selectedFE.add({id: e.target.value, name: e.target.dataset.name});
		        } else {
		            [...selectedFE].forEach(item => {
		                if(item.id === e.target.value) selectedFE.delete(item);
		            });
		        }
		    }
		
		    if(e.target.classList.contains('be')) {
		        if(e.target.checked){
		            selectedBE.add({id: e.target.value, name: e.target.dataset.name});
		        } else {
		            [...selectedBE].forEach(item => {
		                if(item.id === e.target.value) selectedBE.delete(item);
		            });
		        }
		    }
		
		    if(e.target.classList.contains('pl')) {
		        if(e.target.checked){
		            selectedPL.add({id: e.target.value, name: e.target.dataset.name});
		        } else {
		            [...selectedPL].forEach(item => {
		                if(item.id === e.target.value) selectedPL.delete(item);
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
		
		    selectedFE.forEach(e => {
		        memberList.innerHTML += `<button class="member-btn" data-role="FE" data-id="\${e.id}">\${e.name} (FE)</button>`;
		    });
		    selectedBE.forEach(e => {
		        memberList.innerHTML += `<button class="member-btn" data-role="BE" data-id="\${e.id}">\${e.name} (BE)</button>`;
		    });
		    selectedPL.forEach(e => {
		        memberList.innerHTML += `<button class="member-btn" data-role="PL" data-id="\${e.id}">\${e.name} (PL)</button>`;
		    });
		}
		
		// 버튼 클릭 → 해당 멤버 제거
		document.querySelector('#memberList').addEventListener('click', function(e){
		    if(e.target.classList.contains('member-btn')){
		        const role = e.target.dataset.role;
		        const id = e.target.dataset.id;
		
		        if(role === "FE"){
		            [...selectedFE].forEach(item => { if(item.id === id) selectedFE.delete(item); });
		        }
		        if(role === "BE"){
		            [...selectedBE].forEach(item => { if(item.id === id) selectedBE.delete(item); });
		        }
		        if(role === "PL"){
		            [...selectedPL].forEach(item => { if(item.id === id) selectedPL.delete(item); });
		        }
		
		        // 체크박스도 해제
		        document.querySelectorAll(`input[value="\${id}"]`).forEach(cb => cb.checked = false);
		
		        // 다시 렌더링
		        renderMemberList();
		    }
		});
		
		// 최종 등록 버튼 클릭 시 → feList, beList, plList에 출력
		document.querySelector('#modalBtn').addEventListener('click', function() {

			const f = document.querySelector('#feList');
			const b = document.querySelector('#beList');
			const p = document.querySelector('#plList');
			
			// 값 초기화
		    f.value = "";
		    b.value = "";
		    p.value = "";
		    
			// hidden input 영역 초기화		
		    const fb = document.querySelector('#feListBox');
		    const bb = document.querySelector('#beListBox');
		    const pb = document.querySelector('#plListBox');
		    
		    fb.innerHTML = '';
		    bb.innerHTML = '';
		    pb.innerHTML = '';
			
		
		    // FE 개발자 최종 등록
		    selectedFE.forEach(e => {
		        f.value += `\${e.name}(\${e.id}), `;
		        fb.innerHTML += `
		            <input type="hidden" name="feList" value="\${e.id}">
		        `;
		    });
		    
		    // BE 개발자 최종 등록
		    selectedBE.forEach(e => {
		        b.value += `\${e.name}(\${e.id}), `;
		        bb.innerHTML += `
		            <input type="hidden" name="beList" value="\${e.id}">
		        `;
		    });
		    
		    // PL 개발자 최종 등록
		    selectedPL.forEach(e => {
		        p.value += `\${e.name}(\${e.id}), `;
		        pb.innerHTML += `
		            <input type="hidden" name="plList" value="\${e.id}">
		        `;
		    });
		
		    
		    // 마지막 쉼표, 공백 제거
		    f.value = f.value.substr(0,f.value.length - 2);
		    b.value = b.value.substr(0,b.value.length - 2);
		    p.value = p.value.substr(0,p.value.length - 2);
		    
		    // 모달 닫기
		    const modal = bootstrap.Modal.getInstance(document.querySelector('#scrollable-modal'));
		    modal.hide();
		});


    </script>
   
   <jsp:include page ="../views/nav/javascript.jsp"></jsp:include>
</body>
</html>