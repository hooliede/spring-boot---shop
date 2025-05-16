<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 리스트</title>
<script src="http://code.jquery.com/jquery-3.7.1.js"></script>
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
        max-width: 1400px;
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

    input[type="button"] {
        padding: 8px 16px;
        border: none;
        border-radius: 4px;
        background-color: #3498db;
        color: white;
        cursor: pointer;
        font-size: 14px;
        transition: background-color 0.3s ease;
    }

    input[type="button"]:hover {
        background-color: #2980b9;
    }
	.update-btn {
		background-color: #f39c12 !important;
		color: white;
	}
	.update-btn:hover{
		background-color: #e67e22 !important;
	}
	.delete-btn {
		background-color: #e74c3c !important;
	}
	.delete-btn:hover {
		background-color: #c0392b !important;	
	}
	.order-btn {
		background-color: #2ecc71 !important;
	}
	.order-btn:hover {
		background-color: #27ea60 !important;
	}
    .add-btn {
        display: block;
        width: fit-content;
        margin: 20px auto;
        padding: 10px 20px;
        font-size: 16px;
    }
</style>
<script>
function ConfirmDelete(userid) {
    if (confirm("정말 삭제하시겠습니까?")) {
        fetch('/admin/deleteUser', {
            method: 'POST',
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "userid=" + encodeURIComponent(userid)  // ✅ 세미콜론(;) 제거
        })
        .then(response => {
            if (!response.ok) {
                return response.json().then(err => { throw new Error(err.error || "삭제 실패"); });
            }
            return response.json();
        })
        .then(data => {
            if (data.message === "success") {
                alert("회원이 삭제처리 되었습니다.");
                location.href = "/admin/listUser";  // ✅ 삭제 후 회원 목록 페이지로 이동
            } else {
                alert("삭제 실패: " + data.error);
            }
        })
        .catch(error => {
            console.error("Error:", error);
            alert(error.message);
        });
    }
}

</script>
</head>
<body>
<h2>회원 리스트</h2><br><br>

<form name = "form2" method="post" action = "">
	<table>
		<tr>
			<th>분류 검색</th>
			<th>&nbsp;</th>
			<th>검색어 입력</th>
		</tr>
		<tr>
			<td>
				<select name = "search_type">
				<option value = "name" >이름</option>
				<option value = "userid">아이디</option>
				<option value = "phone">전화번호</option>
				<option value = "email">이메일</option>
				</select>
			</td>
			<td>&nbsp;</td>
			<td>
				<input name="keyword" value = "${keyword}">
				<input type = "submit" value = "검색" id = "btnSearch">
			</td>
		</tr>
		
	</table>	
</form>

<form name="form1" method="post">
    <table>
        <tr>
            <th colspan="2">계정 정보</th>
            <th colspan="3">고객 정보</th>
            <th rowspan="2">작업</th>
        </tr>
        <tr>
            <th>아이디(닉네임)</th>
            <th>이름</th>
            <th>휴대전화</th>
            <th>주소</th>
            <th>이메일</th>
            
        </tr>
        <c:forEach var="row" items="${list}" varStatus="s">
            <tr>
                <td>${row.userid}(${row.nickname})</td>
                <td>${row.name}</td>
                <td>${row.phone}</td>
                <td>${row.mainAddress} / ${row.subAddress}</td>
                <td>${row.email}</td>
                
                <td>
                    <input type="button" value="상세보기" class="update-btn"
                           onclick="location.href='/admin/detailUser?userid=${row.userid}'">
                    <input type="button" value="삭제하기" class="delete-btn" 
                    onclick="ConfirmDelete('${row.userid}')">
                    <input type="button" value="주문내역(준비중)" class="order-btn">
                </td>
            </tr>
        </c:forEach>
    </table>
    <input type="button" class="add-btn" value="회원추가 (수동 가입)" onclick="location.href='/admin/joinUser'">
    <input type="button" class="add-btn" value="돌아가기" onclick="location.href='/admin/dashboard'">
</form>
</body>
</html>
