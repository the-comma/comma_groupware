<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-layout="">

<head>
    <meta charset="utf-8" />
    <title>Login with Pin | Adminto - Responsive Bootstrap 5 Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta content="A fully featured admin theme which can be used to build CRM, CMS, etc." name="description" />
    <meta content="Coderthemes" name="author" />

    <!-- App favicon -->
    <link href = "<c:url value='/HTML/Admin/dist/assets/images/favicon.ico'/>">

    <!-- Theme Config Js -->
    <script src="<c:url value='/HTML/Admin/dist/assets/js/config.js'/>"></script>

    <!-- Vendor css -->
    <link href="<c:url value='/HTML/Admin/dist/assets/css/vendor.min.css'/>" rel="stylesheet" type="text/css" />

    <!-- App css -->
    <link href="<c:url value='/HTML/Admin/dist/assets/css/app.min.css'/>" rel="stylesheet" type="text/css" id="app-style" />

    <!-- Icons css -->
    <link href="<c:url value='/HTML/Admin/dist/assets/css/icons.min.css'/>"  rel="stylesheet" type="text/css" />
    
    
    <script defer src="<c:url value='/HTML/Admin/dist/assets/js/vendor.min.js'/>"></script>
	<script defer src="<c:url value='/HTML/Admin/dist/assets/js/app.js'/>"></script>
</head>

<body class="h-100">
    <div class="auth-bg d-flex min-vh-100">
        <div class="row g-0 justify-content-center w-100 m-xxl-5 px-xxl-4 m-3">
            <div class="col-xxl-3 col-lg-5 col-md-6">
                <a href="index.html" class="auth-brand d-flex justify-content-center mb-2">
                    <img src="assets/images/logo-dark.png" alt="dark logo" height="26" class="logo-dark">
                    <img src="assets/images/logo.png" alt="logo light" height="26" class="logo-light">
                </a>
<c:choose>
	<c:when test="${not empty msg}">
		<script type="text/javascript">alert("${msg}")</script>
	</c:when>
	<c:when test="${not empty error}">
		<script type="text/javascript">alert("${error}")</script>
	</c:when>
</c:choose>
                <p class="fw-semibold mb-4 text-center text-muted fs-15">Admin Panel Design by Coderthemes</p>

                <div class="card overflow-hidden text-center p-xxl-4 p-3 mb-0">
                    <h4 class="fw-semibold mb-2 fs-20">Login with PIN</h4>

                    <p class="text-muted mb-4">We sent you a code, please enter it below to verify <br />your number
                        <span class="link-dark fs-13 fw-medium">+ (12) 345-678-912</span>
                    </p>

                    <form action="/login-pin" method="post" class="text-start mb-3">
        				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
        				<input type="hidden" id="code" name="code"/>
        				
        
                        <label class="form-label" for="code">6자리 코드 입력</label>
		
                        <div class="d-flex gap-2 mt-1 mb-3" id="otpInputs">
					        <input type="text" maxlength="1" class="form-control text-center">
					        <input type="text" maxlength="1" class="form-control text-center">
					        <input type="text" maxlength="1" class="form-control text-center">
					        <input type="text" maxlength="1" class="form-control text-center">
					        <input type="text" maxlength="1" class="form-control text-center">
					        <input type="text" maxlength="1" class="form-control text-center">
					    </div>

						
						<div class="mb-2">남은 시간: <span id="timer">${remainSeconds}</span>초</div>
						
                        <div class="mb-3 d-grid">
                            <button id="submitBtn"  class="btn btn-primary fw-semibold" type="submit">번호 인증하기</button>
                        </div>
                        <p class="mb-0 text-center">인증번호를 아직 못받으셨나요?  <a href="/findPw"
                                class="link-primary fw-semibold text-decoration-underline">인증번호 다시 보내기</a></p>
                    </form>

                    <p class="text-muted fs-14 mb-0">Back To <a href="/login"
                            class="fw-semibold text-danger ms-1">Home!</a></p>

                </div>

                <p class="mt-4 text-center mb-0">
                    <script>document.write(new Date().getFullYear())</script> © Adminto - By <span
                        class="fw-bold text-decoration-underline text-uppercase text-reset fs-12">Coderthemes</span>
                </p>
            </div>
        </div>
    </div>


<script type="text/javascript">
(function(){
  const boxes = Array.from(document.querySelectorAll('#otpInputs input'));
  const hidden = document.getElementById('code');
  const submitBtn = document.getElementById('submitBtn');
  const resendBtn = document.getElementById('resendBtn');

  // 숫자만, 자동 이동, 붙여넣기 지원
  boxes.forEach((el, idx) => {
    el.addEventListener('keydown', e => {
      if (e.key === ' ') e.preventDefault();
      if (e.key === 'Backspace' && !el.value && idx > 0) boxes[idx-1].focus();
    });
    el.addEventListener('input', e => {
      el.value = el.value.replace(/\D/g,'').slice(0,1);
      if (el.value && idx < boxes.length - 1) boxes[idx+1].focus();
      sync();
    });
    el.addEventListener('paste', e => {
      const text = (e.clipboardData || window.clipboardData).getData('text').replace(/\D/g,'').slice(0,6);
      if (!text) return;
      e.preventDefault();
      for (let i=0;i<boxes.length;i++) boxes[i].value = text[i] || '';
      boxes[Math.min(text.length, boxes.length) - 1]?.focus();
      sync();
    });
  });

  function sync(){
    const code = boxes.map(b=>b.value).join('');
    hidden.value = code;
    submitBtn.disabled = (code.length !== 6);
  }

  // 타이머
  let remain = parseInt(document.getElementById('timer').textContent || '0', 10);
  function tick(){
    if (remain <= 0) {
      document.getElementById('timer').textContent = '0';
      submitBtn.disabled = true;
      if (resendBtn) resendBtn.disabled = false;
      return;
    }
    document.getElementById('timer').textContent = remain.toString();
    remain -= 1;
    setTimeout(tick, 1000);
  }
  tick();

  // 처음 포커스
  boxes[0].focus();
})();
</script>

</body>
</html>