<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f8f8f8;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
    }
    .container {
        background-color: #fff;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        width: 350px;
    }
    h2 {
        text-align: center;
        margin-bottom: 20px;
    }
    label {
        font-weight: bold;
        display: block;
        margin-bottom: 5px;
    }
    input[type="text"], input[type="password"], textarea {
        width: 100%;
        padding: 10px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
    }
    input[type="button"] {
        width: 100%;
        padding: 10px;
        border: none;
        background-color: #4CAF50;
        color: white;
        border-radius: 5px;
        cursor: pointer;
        font-weight: bold;
    }
    input[type="button"]:hover {
        background-color: #45a049;
    }
    #checkID {
        margin-top: -10px;
        background-color: #007BFF;
    }
    #checkID:hover {
        background-color: #0056b3;
    }
</style>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
let idCheckResult = false;
let nicknameCheckResult = false;

$(function () {
    $("#checkID").click(function () {
        let userid = $("#userid").val();
        if (userid.length < 3 || userid.length > 20) {
            alert("아이디는 최소 3자 이상 최대 20자 미만 이어야 합니다.");
            return;
        }

        let params = { "userid": userid };

        $.ajax({
            type: "post",
            url: "/member/check_userid",
            data: params,
            success: function (response) {
                alert(response.message);
				idCheckResult = response.message === "사용 가능한 아이디입니다.";
				console.log("아이디 중복검사 결과 " +idCheckResult);
            },
            error: function () {
                alert("오류가 발생했습니다. 다시 시도해주세요.");
            }
        });
    });
    
	$("#checkNickName").click(function (){
		let nickname = $("#nickname").val();
		let params = {"nickname": nickname};
		
		$.ajax({
			type: "post",
			url: "/member/check_nickname",
			data: params,
			success: function(response) {
				alert(response.message);
				nicknameCheckResult = response.message === "사용 가능한 닉네임입니다.";	
				console.log("닉네임 중복검사 결과 " +nicknameCheckResult);
			},
			error: function(){
				alert("오류가 발생했습니다. 다시 시도해주세요.");
			}
		});
	});
    
	$("#signup").click(function(){
		if (!idCheckResult) {
			alert("아이디 중복검사를 완료해주세요.");
			document.form1.userid.focus();
			return;
		}
		if (!nicknameCheckResult) {
			alert("닉네임 중복검사를 완료해주세요.");
			document.form1.nickname.focus();
			return;
		}
		
		let userid = document.form1.userid.value;
		let passwd = document.form1.passwd.value;
		let name = document.form1.name.value;
		let phone = document.form1.phone.value;
		let mainAddress = document.form1.mainAddress.value;
		let subAddress = document.form1.subAddress.value;
		if (userid == "") {
	        alert("아이디를 입력해주세요.");
	        document.form1.userid.focus();
	        return;
	    }
	    if (passwd == "") {
	        alert("비밀번호를 입력해주세요.");
	        document.form1.passwd.focus();
	        return;
	    }
	    if (name == "") {
	        alert("이름을 입력해주세요.");
	        document.form1.name.focus();
	        return;
	    }
	    if (phone == "") {
	        alert("전화번호를 입력해주세요.");
	        document.form1.phone.focus();
	        return;
	    }
	    if (mainAddress == "") {
	        alert("주소를 입력해주세요.");
	        document.form1.mainAddress.focus();
	        return;
	    }
	    if (subAddress == "") {
	        alert("상세주소를 입력해주세요.");
	        document.form1.subAddress.focus();
	        return;
	    }
	    
	    document.form1.action = "/member/insert";
	    document.form1.submit();
	    alert("회원가입이 완료되었습니다.");
	});
	
});
</script>
</head>
<body>
<div class="container">
    <h2>회원가입</h2>
    <form name="form1" method="post">
        <label for="userid">아이디</label>
        <input type="text" name="userid" id="userid" placeholder="영문 4자 이상, 최대 20자">
        <input type="button" value="중복검사" id="checkID">
		
		<label for="nickname">닉네임</label>
		<input type="text" name="nickname" id="nickname" placeholder="닉네임 입력(최대 20자)">
		<input type="button" value="중복검사" id="checkNickName">
		
		
        <label for="passwd">비밀번호</label>
        <input type="password" name="passwd" id="passwd" placeholder="숫자, 영문, 특수문자 포함 최소 8자 이상">

        <label for="name">이름</label>
        <input type="text" name="name" id="name" placeholder="이름 입력">

        <label for="phone">전화번호</label>
        <input type="text" name="phone" id="phone" placeholder="000-000-0000">
		
		<label for="email">이메일</label>
		<input type="text" name="email" id="email" placeholder="이메일을 입력하세요."> 
		
        <label for="mainAddress">주소</label>
        <textarea name="mainAddress" id="mainAddress" placeholder="주소를 입력해주세요."></textarea>
		<label for="sub_address">상세주소</label>
		<textarea name="subAddress" id="subAddress" placeholder="상세주소를 입력해주세요."></textarea>
        <input type="button" value="추가하기" id="signup">
    </form>
</div>
</body>
</html>
