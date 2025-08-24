<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <title>비밀번호 재설정</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- CSS -->
  <link href="<c:url value='/HTML/Admin/dist/assets/css/vendor.min.css'/>" rel="stylesheet" />
  <link href="<c:url value='/HTML/Admin/dist/assets/css/app.min.css'/>" rel="stylesheet" id="app-style" />
  <link href="<c:url value='/HTML/Admin/dist/assets/css/icons.min.css'/>" rel="stylesheet" />

  <!-- 앱 스크립트(선택) -->
  <script defer src="<c:url value='/HTML/Admin/dist/assets/js/vendor.min.js'/>"></script>
  <script defer src="<c:url value='/HTML/Admin/dist/assets/js/app.js'/>"></script>

  <!-- jQuery는 별도 태그로 로드 (본문 코드 넣지 말 것) -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

  <!-- 사용자 스크립트: 별도 <script>로 분리 -->
<script>
  // 한국 전화번호 하이픈 포맷터
  function formatPhoneKR(s) {
    let d = (s || '').replace(/\D/g, '');
    if (!d) return '';
    if (d.length <= 3) return d;
    if (d.length <= 7) return d.replace(/(\d{3})(\d+)/, '$1-$2');
    return d.replace(/(\d{3})(\d{3,4})(\d{4}).*/, '$1-$2-$3');
  }

  // 이메일 유효성 검사: 유효하면 true
  function isValidEmail(str) {
    const email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/i;
    return email_regex.test(str);
  }

  $(function () {
    const $ph = $('#phone');
    const $em = $('#email');

    // 1) 초기 표시
    if ($ph.val()) {
      $ph.val(formatPhoneKR($ph.val()));
    }

    // 2) 입력 중 실시간 하이픈
    $ph.on('input', function () {
      this.value = formatPhoneKR(this.value);
    });

    // 3) 제출 시 검증
    $('form').on('submit', function (e) {
      // 전화번호 숫자만 추출
      const rawDigits = $ph.val().replace(/\D/g, '');
      $ph.val(rawDigits);

      // 이메일 체크
      const emailVal = $em.val().trim();
      if (!isValidEmail(emailVal)) {
        e.preventDefault();   // 제출 막기
        alert("이메일 형식이 올바르지 않습니다.");
        $em.focus();
        return;
      }


      // 여기까지 통과하면 제출
      alert("개인정보가 수정되었습니다.");
    });
  });
</script>

</head>

<body>
  <div class="auth-bg d-flex min-vh-100">
    <div class="row g-0 justify-content-center w-100 m-xxl-5 px-xxl-4 m-3">
      <div class="col-xxl-3 col-lg-5 col-md-6">

        <div class="card overflow-hidden text-center p-xxl-4 p-3 mb-0">
          <h4 class="fw-semibold mb-3 fs-18">Sign Up to your account</h4>

  
          <form action="/updateInfo" method="post" class="text-start mb-3" novalidate>
            <div class="mb-3">
              <label class="form-label" for="email">이메일</label>
              <input type="email" id="email" name="email" class="form-control"
                     value="${email}" placeholder="이메일을 입력하세요.">
            </div>

            <div class="mb-3">
              <label class="form-label" for="phone">휴대폰번호</label>
              <input type="tel" id="phone" name="phone" class="form-control"
                     placeholder="휴대폰 번호를 입력하세요."
                     value="${phone}"
                     pattern="^(\d{2,3}-\d{3,4}-\d{4}|\d{8,11})$">
            </div>

            <div class="d-grid">
              <button class="btn btn-primary fw-semibold" type="submit">개인정보 수정하기</button>
            </div>
          </form>
        </div>

        <p class="mt-4 text-center mb-0">
          <script>document.write(new Date().getFullYear())</script> © Adminto
        </p>
      </div>
    </div>
  </div>
</body>
</html>
