<%@ page language="java" contentType="text/html; charset=UTF-8" 
pageEncoding="UTF-8" %>
<style>
 input[type="text"], input[type="password"] {
        width: 100%;
        padding: 10px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
    }
    input[type="submit"], input[type="button"] {
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
</style>
<div id="password-change-container" style="display: none; margin-top: 20px;">
    <form id="passwordChangeForm">
        <input type="hidden" id="userid" name = "userid" value ="${member.userid}">
        
        <label for="passwd">기존 비밀번호:</label>
        <input type="password" id="passwd" name="passwd" required><br>
		
        <label for="newPasswd">새 비밀번호:</label>
        <input type="password" id="newPasswd" name="newPasswd" required><br>

        <label for="confirmPasswd">새 비밀번호 확인:</label>
        <input type="password" id="confirmPasswd" name="confirmPasswd" required><br>

        <input type="button" onclick="changePassword()" value="비밀번호 변경">
    </form>
    
    <p id="passwdMessage" style = "color: red; font-weight: bold;"></p>
    
</div>
