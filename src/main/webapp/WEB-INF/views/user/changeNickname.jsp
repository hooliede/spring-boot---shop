<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
    input[type="text"], input[type="password"] {
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

<div id="nickname-change-container" style="display: none; margin-top: 20px;">
    <form id="nicknameChangeForm">
        <input type="hidden" id="userid" name="userid" value="${member.userid}">
        
        <!-- 현재 닉네임 표시 -->
        <label for="currentNickname">현재 닉네임:</label>
        <input type="text" id="currentNickname" name="currentNickname" value="${member.nickname}" readonly><br>

        <!-- 새 닉네임 입력 -->
        <label for="newNickname">새 닉네임:</label>
        <input type="text" id="newNickname" name="newNickname" required><br>

        <input type="button" onclick="changeNickname()" value="닉네임 변경">
    </form>
    
    <p id="nicknameMessage" style="color: red; font-weight: bold;"></p>
</div>
