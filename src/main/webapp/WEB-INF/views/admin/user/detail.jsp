<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f3f3f3;
            color: #333;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .header-container {
            width: 100%;
            position: absolute;
            top: 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 70px;
            padding: 0 20px;
            background-color: #ffffff;
            border-bottom: 1px solid #ddd;
            box-sizing: border-box;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #0078ff;
        }

        .logo a {
            text-decoration: none;
            color: inherit;
        }

        .nav-links {
            display: flex;
            gap: 10px;
        }

        .nav-links a {
            text-decoration: none;
            color: #333;
            font-size: 16px;
            font-weight: bold;
        }

        .nav-links a:hover {
            color: #0078ff;
        }

        .container {
            width: 100%;
            max-width: 1000px;
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            font-size: 32px;
            color: #333;
            margin-bottom: 30px;
            font-weight: 700;
        }

        .profile-header {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }

        .profile-header img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin-right: 20px;
            border: 4px solid #007bff;
        }

        .profile-header .user-info {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }

        .profile-header .user-info span {
            display: block;
            font-size: 16px;
            color: #777;
        }
		
        .info-card {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #ddd;
            margin-bottom: 20px;
        }

        .info-row {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .info-row label {
            font-size: 14px;
            font-weight: 500;
            color: #555;
            margin-right: 15px;
            width: 120px;
        }

        .info-row span {
            font-size: 14px;
            color: #333;
            font-weight: 500;
        }
		/* 기존 스타일과 유사한 input 스타일 */
		.info-row input {
   			font-size: 14px;
   			font-weight: 500;
    		color: #333;
    		background-color: #f9f9f9; /* 배경을 기존과 비슷하게 */
    		border: 1px solid #ddd; /* 경계선 추가 */
    		border-radius: 5px; /* 둥근 모서리 */
		    padding: 8px;
    		width: 100%; /* 입력 필드 크기를 span과 동일하게 */
    		max-width: 300px; /* 너무 길어지지 않도록 제한 */
    		outline: none; /* 클릭 시 파란 테두리 제거 */
		}
		/* 포커스(클릭 시) 스타일 */
		.info-row input:focus {
    		border-color: #007bff; /* 포커스 시 파란색 테두리 */
    		background-color: #fff; /* 입력 시 배경 변경 */
    		box-shadow: 0 0 5px rgba(0, 120, 255, 0.3); /* 부드러운 그림자 효과 */
		}
        .actions-container {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #ddd;
            margin-top: 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .action {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .action span {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            display: flex;
            align-items: center;
        }

        .action span i {
            margin-right: 10px;
            color: #007bff;
        }

        .action button, .action a {
            padding: 12px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            text-align: center;
            transition: background-color 0.3s ease;
        }

        .action button:hover, .action a:hover {
            background-color: #0056b3;
        }

        .footer {
            text-align: center;
            margin-top: 30px;
            font-size: 14px;
            color: #aaa;
        }

        .edit-btn {
            margin-left: auto;
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 15px;
            font-size: 14px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .edit-btn:hover {
            background-color: #0056b3;
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>
</head>
<c:if test = "${param.message == 'change_nickname' }">
	<script>
		alert("닉네임을 성공적으로 변경했습니다.");
	</script>
</c:if>
<body>

<div class="container">
    <h1>회원 상세보기</h1>
	<form name="form1" method="post" action ="/admin/updateUser">
    <div class="profile-header">
        <img src="https://via.placeholder.com/120" alt="프로필 사진">
    </div>
	
    <div class="info-card">
    	<div class="info-row">
			<div class="action">
				<span><i class="fas fa-user-edit"></i>회원 정보 변경</span><br>
			</div>
		</div>
		<input type="hidden" name="userid" value="${member.userid}">${member.userid}
        <div class="info-row">
            <label for="name">이름:</label>
            <input type="text" placeholder="${member.name}" value="${member.name}" name="name">
        </div>

        <div class="info-row">
            <label for="nickname">닉네임:</label>
            <input type="text" placeholder="${member.nickname}" value="${member.nickname}" name="nickname">
        </div>

        <div class="info-row">
            <label for="phone">전화번호:</label>
            <input type="text" placeholder="${member.phone}" value="${member.phone}" name="phone">
        </div>
        
        <div class ="info-row">
        	<label for="mainAdress">주소 :</label>
        	<input type="text" placeholder="${member.mainAddress}" value="${member.mainAddress}" name="mainAddress">
        </div>
        <div class ="info-row">
        	<label for="subAdress">상세 주소</label>
        	<input type="text" placeholder="${member.subAddress}" value="${member.subAddress}" name="subAddress">
        </div>
        <div class="info-row">
        	<label for="joinDate">가입일 :</label>
        	<span id="joinDate">준비중</span>
        </div>
        <div class = "info-row">
        	<label for="loginDate">최근 로그인:</label>
        	<span id="loginDate">준비중</span>
        </div>
        <div class="info-row">
        	<label for ="grade">회원 등급 :</label>
        	<span id="grade">준비중</span>
        </div>
        <div class="action">
        	<input class="edit-btn" type="submit" value="수정">
        </div>
    </div>
	</form>
	
	<div class= "info-card">
		<div class="info-row">
			<div class="action">
				<span><i class="fas fa-shopping-cart"></i>주문내역</span><br>
			</div>
		</div>
		<div class="info-row">
			주문 내역 테이블 준비중
		</div>
	</div>
</div>

</body>
</html>
