<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 메뉴 화면</title>
    <style>
        /* 기본 스타일 */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #5a6e7d; /* 부드러운 다크 그레이 색상 */
            color: white;
            padding: 25px 0;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        header h1 {
            margin: 0;
            font-size: 36px;
        }

        .menu-container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .menu-container h2 {
            text-align: center;
            font-size: 26px;
            color: #333;
            margin-bottom: 25px;
            font-weight: 600;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 15px;
            text-align: center;
            font-size: 18px;
        }

        th {
            background-color: #4b5c6b; /* 고급스러운 짙은 파란색 */
            color: white;
        }

        tr:nth-child(even) {
            background-color: #fafafa; /* 미세한 회색 배경 */
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        a {
            color: #5a6e7d; /* 부드러운 다크 그레이 색상 */
            text-decoration: none;
            font-weight: 500;
        }

        a:hover {
            color: #3b4951; /* 약간 더 진한 색상 */
        }

        .logout {
            display: block;
            width: 100%;
            background-color: #5a6e7d;
            color: white;
            padding: 16px;
            text-align: center;
            border-radius: 6px;
            font-size: 18px;
            margin-top: 25px;
            text-decoration: none;
            font-weight: 600;
        }

        .logout:hover {
            background-color: #475a63;
        }

        .status-message {
            font-size: 18px;
            font-weight: bold;
            text-align: center;
            color: #4CAF50; /* 초록색 */
        }

    </style>
</head>
<body>
    <header>
        <h1>병훈전자 관리자 화면</h1>
    </header>

    <div class="menu-container">
        <c:choose>
            <c:when test="${sessionScope.userid == null}">
                <a href="/admin/admin_login.jsp">관리자 로그인</a>
            </c:when>
            <c:otherwise>
                <p class="status-message">${sessionScope.name}님이 로그인중입니다.</p>
            </c:otherwise>
        </c:choose>

        <h2>※ 관리자 기능 ※</h2>

        <table>
            <tr>
                <td rowspan="3">회원<br><br>회원 수 :   <span style="font-size:34px;">${sessionScope.users}</span>명</td>
                <td><a href="/admin/listUser">회원 목록</a></td>
            </tr>
            <tr>
                <td><a href="/admin/listOrder">주문 관리</a>
            </tr>
            <tr>
            	<td><a href="">회원 등급 관리(준비중)</a></td>
            </tr>
            <tr>
                <td rowspan="4">상품<br><br><br><br>상품 수 :   <span style="font-size: 34px;">${sessionScope.products}</span>개</td>
                <td><a href="/admin/listProduct">상품 목록</a></td>
            </tr>
            <tr>
                <td><a href="/admin/category_list">카테고리 조회(준비중)</a></td>
            </tr>
            <tr>
            	<td>특성 관리(준비중)</td>
            </tr>
            <tr>
            	<td><a href="/admin/calist">카테고리-특성 검색(준비중)</a></td>
            </tr>
            <tr>
            	<td>게시판</td>
            	<td><a href="/admin/insertProduct">게시판 관리(준비중)</a>
            </tr>
        </table>
			
        <a href="/admin/logout" class="logout">로그아웃</a>
    </div>
</body>
</html>
