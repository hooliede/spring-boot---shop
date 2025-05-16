<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>병훈 전자</title>

<link rel="stylesheet" type="text/css" href="/css/main/1_floor/header.css"> 

</head>
<body>
<header class="header-container">
    <!-- 로고 -->
    <div class="logo">
        <a href= "/" style="text-decoration: none; color: inherit;">병훈전자</a>
    </div>

    <!-- 검색창 -->
    <div class="search-bar">
  		<form class = "search-bar" name = "form2" method="get" action = "/product/keywordSearch">
        <input type="text" class = "search-input" name = "keyword" placeholder="검색어를 입력하세요." id = "searchInput">
        <button class="search-button">검색</button>
		</form>
    </div>

    <!-- 오른쪽 버튼들 -->
    <div class="nav-links">
        	<!-- 로그인 상태 확인 -->
        	<c:choose>
        		<c:when test = "${not empty sessionScope.result}">
        			<p>${sessionScope.result}<br>
        			<a href = "/member/logout">로그아웃</a>
        			<span>|</span>
        			<a href="/member/mypage">마이페이지</a>
        			<span>|</span>
        			<a href="/cart/listCart">장바구니</a>
        			</p>
        		</c:when>
        		<c:otherwise>
           			<a href="/member/login">로그인</a>
          			<span>|</span>
            		<a href="#" onclick="alert('로그인이 필요합니다.'); return false;">마이페이지</a>
            		<span>|</span>
            		<a href="#" onclick="alert('로그인이 필요합니다.'); return false;">장바구니</a>
            	</c:otherwise>
            		
        	</c:choose>
        </div>
</header>
</body>

</html>
