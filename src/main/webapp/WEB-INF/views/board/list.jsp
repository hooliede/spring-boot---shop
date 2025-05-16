<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<head>
	<link rel="stylesheet" href="/css/board/list.css">
</head>
<body>
<div class="board-container">
    <h2>자유게시판 목록</h2>

    <!-- ✅ 검색 폼 추가 -->

    <table class="table table-hover text-center">
        <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>내용</th>
                <th>작성자</th>
                <th>조회수</th>
                <th>작성날짜</th> <!-- ✅ 작성일 추가 -->
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${boardList}" var="board">
                <tr>
                    <td>${board.boardIdx}</td>
                    <td><a href="/board/detail?boardIdx=${board.boardIdx}" class="text-decoration-none">${board.title}</a></td>
                    <td>${board.contents}</td>
                    <td>${board.member.nickname}</td>
                    <td>${board.hit}</td>
                    <td>${board.regdate}</td> <!-- ✅ 작성일 표시 -->
                </tr>
            </c:forEach>
        </tbody>
    </table>

	<!-- 페이지 네이션 -->

    <!-- ✅ 글쓰기 버튼 추가 -->
    <c:choose>
    	<c:when test = "${not empty sessionScope.userid}">
    		<div class="text-center mt-3">
        		<a href="/board/writeBoard" class="btn btn-primary">글쓰기</a>
    		</div>
    	</c:when>
    	<c:otherwise>
    		<div class="text-center mt-3">
        		<a href="#" class="btn btn-primary" onclick="alert('로그인이 필요합니다.'); return false;">글쓰기</a>
    		</div>
    	</c:otherwise>
    </c:choose>
    
</div>
</body>

<!-- ✅ Ajax 검색 및 페이지네이션 적용 -->

