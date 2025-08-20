<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 추가</title>
</head>
<body>
	<h1>프로젝트 추가</h1>
	
	<form action="/addProjectForm" method="post" id="project" name="project">
		<label for="empName">PM</label>
		<input type="text" id="empName" name="empName" value=""><br>
		
		<label for="projectTitle">프로젝트 명</label>
		<input type="text" id="projectTitle" name="projectTitle" placeholder="프로젝트 명 입력.."><br>
		
		<label for="projectDesc">설명</label>
		<textarea rows="10" cols="20" id="projectDesc" name="projectDesc"></textarea>
		
		<label for="projectGitUrl">Github URL</label>
		<input type="text" id="projectGitUrl" name="projectGitUrl" placeholder="Git URL 입력.."><br>
		
		<label for="endDate">마감일</label>
		<input type="date" id="endDate" name="endDate">
		
		<button type="submit">생성</button>
	</form>
</body>
</html>