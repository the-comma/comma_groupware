<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-layout="">

<head>
    <meta charset="utf-8" />
    <title>비밀번호 재설정</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta content="A fully featured admin theme which can be used to build CRM, CMS, etc." name="description" />
    <meta content="Coderthemes" name="author" />

    <!-- App favicon -->
    <link rel="shortcut icon" href="/HTML/Admin/dist/assets/images/favicon.ico">

    <!-- Theme Config Js -->
    <script src="/HTML/Admin/dist/assets/js/config.js"></script>

    <!-- Vendor css -->
    <link href="<c:url value='/HTML/Admin/dist/assets/css/vendor.min.css'/>" rel="stylesheet" type="text/css" />

    <!-- App css -->
    <link href="<c:url value='/HTML/Admin/dist/assets/css/app.min.css'/>" rel="stylesheet" type="text/css" id="app-style" />

    <!-- Icons css -->
    <link href="<c:url value='/HTML/Admin/dist/assets/css/icons.min.css'/>"  rel="stylesheet" type="text/css" />
    
    <script defer src="<c:url value='/HTML/Admin/dist/assets/js/vendor.min.js'/>"></script>
	<script defer src="<c:url value='/HTML/Admin/dist/assets/js/app.js'/>"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script> 
	<script defer src="<c:url value='/assets/js/resetPw.js'/>"></script>
</head>

<body class="h-100">
    <div class="auth-bg d-flex min-vh-100">
        <div class="row g-0 justify-content-center w-100 m-xxl-5 px-xxl-4 m-3">
            <div class="col-xxl-3 col-lg-5 col-md-6">
                <a href="index.html" class="auth-brand d-flex justify-content-center mb-2">
                    <img src="assets/images/logo-dark.png" alt="dark logo" height="26" class="logo-dark">
                    <img src="assets/images/logo.png" alt="logo light" height="26" class="logo-light">
                </a>

                <p class="fw-semibold mb-4 text-center text-muted fs-15">Admin Panel Design by Coderthemes</p>

                <div class="card overflow-hidden text-center p-xxl-4 p-3 mb-0">

                    <h4 class="fw-semibold mb-2 fs-20">Create New Password</h4>

                    <p class="text-muted mb-2">Please create your new password.</p>
            

                    <form action="/resetPw" class="text-start mb-3" method="post">

                        <div class="mb-3">
                            <label class="form-label" for="new-password">새로운 비밀번호 입력 <small
                                    class="text-info ms-1">Must be at least 8 characters</small></label>
                            <input type="password" id="new-password" name="new-password"  pattern="\S{8,15}" class="form-control"
                                placeholder="새로운 비밀번호 입력"> 
                                 <div class="valid-feedback">사용 가능한 비밀번호입니다.</div>
  								 <div class="invalid-feedback">영문과 숫자를 포함해 8~15자로 입력하세요.</div>         
                                
                                
                       </div>

                        
                        <div class="mb-3">
                            <label class="form-label" for="re-password">새로운 비밀번호 재입력</label>
                            <input type="password" id="re-password" name="re-password" pattern="\S{8,15}" class="form-control" placeholder="비밀번호 재입력">
                            <div class="valid-feedback">비밀번호가 일치합니다.</div>
  							<div class="invalid-feedback">비밀번호가 일치하지 않습니다.</div>
                        </div>
                        <div class="mb-2 d-grid">
                            <button class="btn btn-primary fw-semibold" type="submit">Create New Password</button>
                        </div>
                    </form>

                    <p class="text-muted fs-14 mb-0">
                        Back To <a href="/login" class="fw-semibold text-danger ms-1">Login !</a>
                    </p>
                </div>

                <p class="mt-3 text-center mb-0">
                    <script>document.write(new Date().getFullYear())</script> © Adminto - By <span
                        class="fw-bold text-decoration-underline text-uppercase text-reset fs-12">Coderthemes</span>
                </p>
            </div>
        </div>
    </div>

</body>

</html>