<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #fff;
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
        width: 400px;        
        text-align: center;
    }
    /* 로고 스타일 */
	.logo {
        margin-bottom: 20px;
        font-weight: bold;
        font-size: 24px;
        color: #333;
    }

    input[type="text"], input[type="password"] {
        width: 100%;
        padding: 10px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
    }
    input[type="submit"], input[tpye="button"] {
        width: 100%;
        padding: 10px;
        background-color: #007BFF;
        color: white;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
    }
    input[type="button"]:hover {
        background-color: #0056b3;
    }
    .links {
        margin-top: 10px;
    }
    .links a {
        text-decoration: none;
        color: #007BFF;
        font-size: 14px;
    }
    .links a:hover {
        text-decoration: underline;
    }
</style>
<body>
<div class="container">
    <div class= "logo">
    <a href= '#' style="text-decoration: none; color: inherit;">아이디 찾기 결과</a>
    </div>
    	<c:if test = "${not empty member}">
        <p>회원님의 아이디는 <span>${member.userid}</span> 입니다.</p>
        </c:if>
        <c:if test = "${not empty maskedIdList}">
        	<p>검색된 아이디 목록 : </p>
        	<ul>
        		<c:forEach var = "maskedId" items = "${maskedIdList}">
        			<li>${maskedId}</li>
        		</c:forEach>
        	</ul>
        </c:if>
        <div class="links">
           <a href="/member/findPwd">비밀번호 찾기</a> | <a href= "/member/login">로그인</a>
	</div>
</div>
</body>
</html>
