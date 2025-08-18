<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원카드</title>
<!-- JQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style type="text/css">
	.modal {
    position: fixed;  /* absolute → fixed (스크롤 내려도 화면에 고정) */
    display: flex;    /* 중앙 정렬 위해 flex */
    justify-content: center;
    align-items: center;

    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    
    background-color: rgba(0,0,0,0.4);
}	

	.modal_body {
    width: 350px;
    height: 450px;
    padding: 40px;

    text-align: left;
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 2px 3px 0 rgba(34,36,38,0.15);
}
</style>
</head>
<body>
	<c:if test="${emp != null}">
		<div class="modal">
			<div class="modal_body">
				이름<br>
				${emp.empName}<br><br>
				
				부서<br>
				${emp.deptName != null ? emp.deptName : '미배정'}<br><br>
				
				팀<br>
				${emp.teamName != null ? emp.teamName : '미배정'}<br><br>
				
				직급<br>
				${emp.rankName != null ? emp.rankName : '없음'}<br><br>
				
				이메일<br>
				${emp.empEmail}<br><br>
				<button>1:1채팅</button>
				<button class="exitBtn">닫기</button>
				<script>
					$('.exitBtn').on("click",()=>{
						$('.modal').hide();
					})
				</script>
			</div>
		</div>
	</c:if>
</body>
</html>