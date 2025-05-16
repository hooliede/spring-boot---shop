<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객센터</title>
<link rel="stylesheet" type="text/css" href="/css/main/3_floor/customer.css">
</head>
<body>
<div class="customer-container">
    <div class="customer-header">
        <h2>고객센터</h2>
        <div class="more-link">
            <a href="/board/listAll">더보기</a>
        </div>
    </div>
    
    <ul class="board" >
    	<c:forEach var="notice" items="${noticeList}">
    		<li><a href="/board/detail?boardIdx=${notice.boardIdx}">${notice.title}</a></li>
    	</c:forEach>
    </ul>
</div>    
</body>
</html>
