<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 로그인 화면</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f9;
        margin: 0;
        padding: 20px;
        color: #333;
    }

    h2 {
        text-align: center;
        color: #2c3e50;
    }

    table {
        width: 100%;
        max-width: 800px;
        margin: 20px auto;
        border-collapse: collapse;
        background-color: #ffffff;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    table th, table td {
        padding: 10px;
        text-align: center;
        border: 1px solid #ddd;
    }

    table th {
        background-color: #2c3e50;
        color: #ffffff;
    }

    table tr:nth-child(even) {
        background-color: #f9f9f9;
    }

    table tr:hover {
        background-color: #f1f1f1;
    }

    button[type="button"] {
        padding: 8px 16px;
        border: none;
        border-radius: 4px;
        background-color: #3498db;
        color: white;
        cursor: pointer;
        font-size: 14px;
        transition: background-color 0.3s ease;
    }

    button[type="button"]:hover {
        background-color: #2980b9;
    }

    .add-button {
        display: block;
        width: fit-content;
        margin: 20px auto;
        padding: 10px 20px;
        font-size: 16px;
    }
</style>
<script src="http://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
$(function(){
	$("#btnLogin").click(function(){
		const userid = document.form1.userid.value;
		const passwd = document.form1.passwd.value;
		//console.log("userid:"+userid);
		//console.log("passwd:"+passwd);
		if (userid == "") {
			alert("아이디를 입력하세요.");
			document.form1.userid.focus();
			return;
		}
		if (passwd == "") {
			alert("비밀번호를 입력하세요.");
			document.form1.passwd.focus();
			return;
		}
		document.form1.action ="/admin/login";
		document.form1.submit();
	})
});
</script>
</head>
<!--  
<c:if test="${param.message == 'error' }">
	<script>
		alert("아이디 또는 비밀번호가 일치하지 않습니다.");
	</script>
</c:if>
-->

<body>

<h2>관리자 로그인</h2>
<form method="post" name="form1">
<!-- 직접 컨트롤러에 정보 전달? -->
<table border = "1">
	<tr>
		<td>아이디</td>
		<td><input type = text value="admin" name = "userid" ></td>
	</tr>
	<tr>
		<td>비밀번호</td>
		<td><input type="password" value="1234" name="passwd"></td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<button type='button' id='btnLogin'>로그인</button>
		</td>
</table>
</form>
</body>
</html>