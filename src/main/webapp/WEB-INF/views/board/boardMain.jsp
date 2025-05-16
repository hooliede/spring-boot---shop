<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<style>
/* 기본 스타일 */
.board-container {
    overflow-x: auto; /* 👉 가로 스크롤 추가 */
    max-width: 100%; /* 👉 부모 요소를 넘지 않도록 제한 */
}


.board-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-bottom: 10px;
    border-bottom: 2px solid #0078ff;
}
.board-header h2 {
    font-size: 20px;
    font-weight: bold;
    color: #0078ff;
}
.board-header h2 a {
    text-decoration: none;
    color: #333;
    margin-right: 15px;
    font-size: 16px;
    transition: color 0.3s ease;
}
.board-header h2 a:hover {
    color: #0078ff;
}
.board-contents {
    width: 100%;
    table-layout: auto;
    border-collapse: collapse;
    margin-top: 10px;
    font-size: 16px;
    background-color: #ffffff;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
.board-contents table {
    width: 100%;
    border-collapse: collapse;
    margin: 0;
    padding: 0;
    background-color: #ffffff;
}
/* ✅ 테이블 헤더 스타일 */
.board-contents thead {
	background-color: #ececec;
    color: #333;
    font-weight: bold;
    text-transform: uppercase;
    border-bottom: 2px solid #d0d0d0;
}
.board-contents th {
    padding: 12px;
    font-weight: bold;
   
    text-align: center; /* 가운데 정렬 유지 */
    vertical-align: middle; /* 세로 중앙 정렬 */
    border-bottom: 1px solid #e0e0e0;
    letter-spacing: 0.5px;
    writing-mode: horizontal-tb; /* ✅ 가로 정렬 강제 */
    white-space: nowrap; /* ✅ 줄바꿈 방지 */
}

/* ✅ 테이블 행 스타일 */
/*
.board-contents tbody tr {
    text-align: center;
    border-bottom: 1px solid #ddd;
    transition: background 0.3s ease-in-out;
}
.board-contents tbody tr:hover {
    background-color: #f1f1f1;
}
*/
.board-contents tbody tr {
    background-color: #ffffff;
    transition: background-color 0.3s ease-in-out;
}

.board-contents tbody tr:nth-child(even) {
    background-color: #f9f9f9; /* 줄무늬 효과 */
}

.board-contents tbody tr:hover {
    background-color: #f1f1f1; /* 마우스 오버 시 색 변경 */
}

/* ✅ 테이블 셀 스타일 */

.board-contents td {
    padding: 12px;
    text-align: center;
    color: #333;
    border-bottom: 1px solid #e0e0e0;
}

/* ✅ 제목 링크 스타일 */
.board-contents td a {
    text-decoration: none;
    color: #333;
    font-size: 16px;
    font-weight: normal;
}

.board-contents td a:hover {
    color: #0056b3;
    text-decoration: underline;
}
.board-contents td.title, 
.board-contents td.contents {
    max-width: 200px;  /* 최대 너비 설정 */
    white-space: nowrap; /* 줄바꿈 방지 */
    overflow: hidden;
    text-overflow: ellipsis; /* 말줄임표(...) 적용 */
}
/* ✅ 글쓰기 버튼 스타일 */
.write-btn-container {
    text-align: center; /* ✅ 버튼을 가운데 정렬 */
    margin-top: 20px; /* 위쪽 여백 추가 */
}
.write-btn {
    display: inline-block;
    padding: 8px 15px;
    margin-top: 10px;
    font-size: 14px;
    background-color: #0078ff;
    color: white;
    border-radius: 5px;
    text-decoration: none;
    transition: background 0.3s ease;
}
.write-btn:hover {
    background-color: #0056b3;
}
/* ✅ 검색 폼 스타일 */
.search-form {
    display: flex;
    justify-content: flex-start;
    align-items: center;
    gap: 10px;
    margin-bottom: 15px;
}

/* ✅ 검색 옵션 (제목/내용 선택) */
.search-option {
    padding: 8px;
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 5px;
    background: #fff;
    cursor: pointer;
}

/* ✅ 검색 입력 필드 */
.search-input {
    flex: 1;
    padding: 8px;
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 5px;
    width: 200px;
}

/* ✅ 검색 버튼 */
.search-btn {
    padding: 8px 12px;
    font-size: 14px;
    background-color: #0078ff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background 0.3s;
}

.search-btn:hover {
    background-color: #0056b3;
}

/* 페이지네이션 */
.pagination {
    display: flex;
    justify-content: center;
    margin-top: 20px;
}

.page-btn {
    padding: 10px 15px;
    margin: 0 5px;
    text-decoration: none;
    color: #0078ff;
    border: 1px solid #0078ff;
    border-radius: 6px;
    font-size: 15px;
    font-weight: 500;
    background-color: #ffffff;
    transition: all 0.3s ease-in-out;
    cursor: pointer;
}

.page-btn:hover {
    background-color: #0078ff;
    color: white;
    box-shadow: 0px 4px 8px rgba(0, 120, 255, 0.2);
    transform: translateY(-2px);
}

.page-btn.active {
    background-color: #0078ff;
    color: white;
    font-weight: bold;
    border: 1px solid #005fcc;
    box-shadow: 0px 4px 8px rgba(0, 120, 255, 0.3);
}

.page-btn:disabled {
    color: #b0b0b0;
    border-color: #d0d0d0;
    cursor: not-allowed;
    background-color: #f8f8f8;
}

</style>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>가전제품 쇼핑몰</title>


<link rel="stylesheet" type="text/css" href="/css/main/main.css">
<link rel="stylesheet" type="text/css" href="/css/page/pagenation.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
function submitCategory(categoryName) {
	document.getElementById('categoryName').value = categoryName;
    
	/* form1만 제출 */
    document.form1.action = "/product/categorySearch"; // category_search
    document.form1.submit();
}

function handleFormSubmit(event) {
	const keyword = document.forms["form2"]["keyword"].value.trim();
	if (keyword === "") {
		event.preventDefault();
		alert("검색어를 입력해 주세요.");
	}
}

document.addEventListener("DOMContentLoaded", function () {//dom 트리거 함수발생	
	const searchInput = document.getElementById("searchInput");
	const searchForm = document.forms["form2"];
	
	if (searchInput) {
		searchInput.addEventListener("keydown", function (event) {
			if (event.key === "Enter") {
				handleFormSubmit(event);
			}
		});
	}
	
	if (searchForm) {
		searchForm.addEventListener("submit", handleFormSubmit);
	}
});

</script>
<script>
function searchBoard(event) {
	event.preventDefault(); // 기본 폼 제출 방지
	const searchOption = document.getElementById("searchOption").value;
	const keyword = document.getElementById("keyword").value.trim();
	if (!keyword) {
        alert("검색어를 입력해주세요.");
        return;
    }
	
	const encodedKeyword = encodeURIComponent(keyword);
	
	window.location.href = "/board/search?searchOption=" + searchOption + "&keyword=" + encodedKeyword;
}
</script>
</head>
<body>
<!-- 상단 네비게이션 -->
<%@ include file="/WEB-INF/views/include/main/1_floor/header.jsp" %>
<div class="main-container">
   <!-- 상단 -->
   <div class="main-layout">
   
      <!-- 카테고리바 -->
      <div id="category-section">
         <%@ include file="/WEB-INF/views/include/main/2_floor/category.jsp" %>
      </div>
      
      <!-- 배너 -->
      <div id="banner-section">
         <div class="board-container">
         	<!-- 게시판 검색 폼 -->
         	<form id="searchForm" class="search-form" onsubmit="searchBoard(event);">
   				<select id="searchOption" class="search-option">
        			<option value="title" ${searchOption == 'title' ? 'selected' : ''}>제목</option>
        			<option value="contents" ${searchOption == 'contents' ? 'selected' : ''}>내용</option>
        			<option value="nickname" ${searchOption == 'nickname' ? 'selected' : ''}>작성자</option>
        			<option value="titleAndContents" ${searchOption == 'titleAndContents' ? 'selected' : ''}>제목+내용</option>
    			</select>
    		<input type="text" id="keyword" class="search-input" placeholder="검색어 입력" value="${keyword}">
    		<button type="submit" class="search-btn">검색</button>
			</form>
         
    		<div class="board-header">
        		<h2><a href="/board/listAll">전체보기</a> | <a href="/board/boardType?type=NOTICE">공지사항</a> | <a href="/board/boardType?type=FREE">자유게시판</a> | <a href="/board/boardType?type=REVIEW">리뷰게시판</a></h2>
    		</div>

    		<div class="board-contents">
    		<table class="board-contents">
    			<thead>
    				<tr>
    					<th>번호</th>
    					<th>제목</th>
    					<th>내용</th>
    					<th>작성자</th>
    					<th>조회수</th>
    					<th>작성날짜</th>
    				</tr>
    			</thead>
    			<tbody>
    				<c:forEach items="${boardList}" var="board">
    					<tr>
    					<td>${board.boardIdx}</td>
    					<td class = "title"><a href="/board/detail?boardIdx=${board.boardIdx}" class="text-decoration-none">${board.title}</a></td>
                    	<td class = "contents">${board.contents}</td>
                    	<td>${board.member.nickname}</td>
                    	<td>${board.hit}</td>
                    	<td>${board.formattedRegdate}</td>
    					</tr>
    				</c:forEach>
    			</tbody>
    		</table>
    		</div>
    		
    		<!-- 페이지 네이션 -->
    		<div class="pagination">
    			<!-- 이전 버튼 -->
    			<c:if test = "${currentPage > 0}">
    				<a href="/board/listAll?page=${currentPage - 1}&size=${pageSize}" class="page-btn">이전</a>
    			</c:if>
    			
    			<!-- 페이지 번호 -->
    			<c:forEach var="i" begin="0" end="${totalPages - 1}">
    				<a href="/board/listAll?page=${i}&size=${pageSize}"
    					class = "page-btn ${i == currentPage ? 'active' : ''}">
    					${i + 1}
    				</a>
    			</c:forEach>
    			
    			<!-- 다음 버튼 -->
    			<c:if test = "${currentPage < totalPages - 1}">
    				<a href="/board/listAll?page=${currentPage+1}&size=${pageSize}"
    				class ="page-btn">다음</a>
    			</c:if>
    		</div>
    		
    		<!-- ✅ 글쓰기 버튼 추가 -->
    		<div class = "write-btn-container">
    		<c:choose>
    		<c:when test = "${not empty sessionScope.userid}">
    			<div class="text-center mt-3">
	        		<a href="/board/writeBoard" class="write-btn">글쓰기</a>
    			</div>
    		</c:when>
    		<c:otherwise>
	    		<div class="text-center mt-3">
        			<a href="#" class="btn btn-primary" onclick="alert('로그인이 필요합니다.'); return false;">글쓰기</a>
    			</div>
    		</c:otherwise>
    		</c:choose>
    		</div>
		</div> 
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      </div>
      
      <div id="product-section">
         <%@ include file="/WEB-INF/views/include/main/2_floor/product.jsp" %>
      </div>
      
   </div>
   
   <!-- 하단 -->
   <div class = "sub-layout">
   	<div id="customer_center-section">
   		<%@ include file="/WEB-INF/views/include/main/2_floor/banner.jsp" %>
   	</div>
   	<div id="advertise-section">
   		<%@ include file="/WEB-INF/views/include/main/3_floor/advertise.jsp" %>
   	</div>
   </div>
</div>
</body>

</html>
