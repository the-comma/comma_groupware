
$(function () {
  const $form = $('form');
  const $pw  = $('#new-password');
  const $re  = $('#re-password');
  const pwRe = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,15}$/;
  const $fields = $('#new-password , #re-password');
  
  $fields.on('keydown', function (e) {
    if (e.key === ' ' || e.keyCode === 32) {
      e.preventDefault();
    }
  });
  
  function validatePw() {
    const v = $pw.val().trim();
    if (pwRe.test(v)) {
      $pw.removeClass('is-invalid').addClass('is-valid');
    } else {
      $pw.removeClass('is-valid').addClass('is-invalid');
    }
  }

  function resetPwFields() {
    // 1) 값 비우기
    $pw.val('');
    $re.val('');

    // 2) 부트스트랩 유효성 표시 제거
    $pw.add($re).removeClass('is-valid is-invalid');
    $form.removeClass('was-validated'); // 폼 단위 검증 클래스도 제거

    // 3) 메시지/아이콘 숨기기(쓰고 있다면)
    $form.find('.valid-feedback, .invalid-feedback, .form-text.text-success, .form-text.text-danger')
         .addClass('d-none'); // 또는 .text('').hide();

    // 4) 이벤트 기반 UI 갱신(검증 스크립트가 input/change에 묶여있다면)
    $pw.add($re).trigger('input').trigger('change');

    // 5) 포커스
    $pw.focus();
  }
  
  
  
  function validateRe() {
    const v1 = $pw.val().trim();
    const v2 = $re.val().trim();
    if (v2 && v1 === v2) {
      $re.removeClass('is-invalid').addClass('is-valid');
    } else {
      $re.removeClass('is-valid').addClass('is-invalid');
    }
  }

  function checkPrevPassword(pw){
	return $.ajax({
		url: '/api/auth/check-password',
		method: 'POST',
		dataType: 'json',
		data: { 'new-password': pw }
	}).then(res =>{
		return (typeof res === 'boolean')? res : !!res.reused;
	});
  };
  
  $pw.on('input blur', validatePw);  // input 또는 blur를 할떄 실행
  $re.on('input blur', validateRe);	 // input 또는 blur를 할떄 실행


  $('form').on('submit', function (e) {
	e.preventDefault(); // 통과 못하면 전송 막기
	validatePw();
    validateRe();
    if (!$pw.hasClass('is-valid') || !$re.hasClass('is-valid')) {
      return;
    }
	
	const pw = $pw.val().trim();
	const form = this;
	
	checkPrevPassword(pw)
	.done(function (reused) {
		if(reused){
			alert("이전 비밀번호와 동일합니다.");
			resetPwFields();
			return;
		}
	
		form.submit();
	})
		.fail(function(){
			alert('검증 과정중 오류 발생');		
		})
	})
	
  });

