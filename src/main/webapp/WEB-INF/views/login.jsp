<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko" data-layout="">

<head>
    <meta charset="utf-8" />
    <title>Log In | Adminto - Responsive Bootstrap 5 Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta content="A fully featured admin theme which can be used to build CRM, CMS, etc." name="description" />
    <meta content="Coderthemes" name="author" />

    <!-- App favicon -->
    <link rel="shortcut icon" href="/HTML/Admin/dist/assets/images/favicon.ico">

<!-- App css -->
<link href="<c:url value='/HTML/Admin/dist/assets/css/app.min.css'/>" rel="stylesheet" type="text/css" />

<!-- Vendor / Icons css -->
<link href="<c:url value='/HTML/Admin/dist/assets/css/vendor.min.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/HTML/Admin/dist/assets/css/icons.min.css'/>" rel="stylesheet" type="text/css" />

<!-- JS -->
<script src="<c:url value='/HTML/Admin/dist/assets/js/config.js'/>"></script>

<script defer src="<c:url value='/HTML/Admin/dist/assets/js/vendor.min.js'/>"></script>
<script defer src="<c:url value='/HTML/Admin/dist/assets/js/app.js'/>"></script>

</head>

<body>

    <div class="auth-bg d-flex min-vh-100">
        <div class="row g-0 justify-content-center w-100 m-xxl-5 px-xxl-4 m-3">
            <div class="col-xxl-3 col-lg-5 col-md-6">
                <a href="index.html" class="auth-brand d-flex justify-content-center mb-2">
                    <img src="assets/images/logo-dark.png" alt="dark logo" height="26" class="logo-dark">
                    <img src="assets/images/logo.png" alt="logo light" height="26" class="logo-light">
                </a>

                <p class="fw-semibold mb-4 text-center text-muted fs-15">Admin Panel Design by Coderthemes</p>

                <div class="card overflow-hidden text-center p-xxl-4 p-3 mb-0">

                    <h4 class="fw-semibold mb-3 fs-18">Log in to your account</h4>

                    <form action="/loginAction" method="post">
                        <div class="mb-3">
                            <label class="form-label" for="example-email">Email</label>
                            <input type="text" id="example-email" name="username" class="form-control"
                                placeholder="사원번호 입력">
                        </div>

                        <div class="mb-3">
                            <label class="form-label" for="example-password">Password</label>
                            <input type="password" id="password" name="password" class="form-control"
                                placeholder="Enter your password">
                        </div>

                        <div class="d-flex justify-content-between mb-3">
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="checkbox-signin">
                                <label class="form-check-label" for="checkbox-signin">Remember me</label>
                            </div>

                            <a href="/findPw" class="text-muted border-bottom border-dashed">Forget
                                Password</a>
                        </div>

                        <div class="d-grid">
                            <button class="btn btn-primary fw-semibold" type="submit">Login</button>
                        </div>
                    </form>


                </div>
                <p class="mt-4 text-center mb-0">
                    <script>document.write(new Date().getFullYear())</script> © Adminto - By <span
                        class="fw-bold text-decoration-underline text-uppercase text-reset fs-12">Coderthemes</span>
                </p>
            </div>
        </div>
    </div>



</body>

</html>