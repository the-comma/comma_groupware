<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<div>
		PM : ${project.pmName}(${project.deptName}/${project.teamName}) <br>
		시작일 : ${project.startDate}<br>
		종료일 : ${project.endDate}<br>
		Github : ${project.projectGitUrl}<br>
		설명 : ${project.projectDesc}<br>
	</div>