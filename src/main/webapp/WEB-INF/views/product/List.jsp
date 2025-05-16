<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>가전제품 쇼핑몰</title>
<link rel="stylesheet" type="text/css" href="/css/main/main.css">
    <style>
      
		.category-title{
			text-align: center;
		}
        .product-table-wrapper {
            width: 90%;
            width: 950px; /* 테이블 최대 너비 */
            margin: 0 auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden; /* 테이블 내용이 넘칠 경우 처리 */
        }
		
        .product-table {
            width: 100%;
            table-layout: auto;
            border-collapse: collapse;
            margin: 20px 0;
        }
		.product-table th:nth-child(1), /* 첫 번째 열 (이미지) */
		.product-table td:nth-child(1) {
   		 width: 1%; /* 이미지 크기만큼 최소한의 공간 차지 */
   		 white-space: nowrap; /* 불필요한 줄바꿈 방지 */
		4}
        .product-table th,
        .product-table td {
            padding: 10px 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
.product-button {
    display: block; /* 블록 요소로 설정 */
    width: 100%;
    text-align: left;
    padding: 10px 0; /* 위아래 패딩만 유지 */
    border: none; /* 테두리 제거 */
    background-color: transparent; /* 배경색 제거 */
    font-family: inherit;
    font-size: inherit;
    color: black;
    cursor: pointer;
    white-space: normal;
    word-wrap: break-word;
    word-break: break-word;
    overflow: hidden;
    text-decoration: none; /* 기본 링크 스타일 제거 */
}
.product-button:hover {
    text-decoration: underline; /* 마우스를 올리면 밑줄 표시 */
    color: #0078ff; /* 강조 색상 */
}
        .product-table th {
            background-color: #0078ff;
            color: white;
            font-size: 16px;
            width: 500px;
        }

        .product-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .product-table tr:hover {
            background-color: #f1f1f1;
        }
</style>
</head>
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
<body>

    	<!-- 상단 네비게이션 -->
		<%@ include file="/WEB-INF/views/include/main/1_floor/header.jsp" %>

    	<!-- 본문 레이아웃 -->
    	<div class="main-container">
    	<div class="main-layout">
        <!-- 세로형 카테고리 -->
        <div id="category-section">
        <%@ include file="/WEB-INF/views/include/main/2_floor/category.jsp" %>
     	</div>

        <!-- 빈 콘텐츠 공간 -->
            <div>
            <h2 class="category-title">
            	<c:choose>
            		<c:when test="${not empty categoryName}">
            			"${categoryName}" 검색 결과
            		</c:when>
            		<c:when test="${not empty keyword}">
            			"${keyword}" 검색 결과
            		</c:when>
            		<c:otherwise>
            			상품 검색 결과
            		</c:otherwise>
            	</c:choose>
            </h2>

            <div class="product-table-wrapper">
                
                <table class="product-table">
                    <thead>
                        <tr>
                            <th>이미지</th>
                            <th>상품명</th>
                            <th>가격</th>
                            <th>재고</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:if test="${not empty message}">
                    	<p style="text-align: center; color:red;">${message}.</p>
					</c:if>                        
                        <c:forEach var="row" items="${productList}">
                            <tr>
                                <td>
								<img src="${row.imageUrl}" alt = "상품 이미지" width="100">
								</td>
                                <td>
                                	<a href="/product/detailProduct?productCode=${row.productCode}" class="product-button">
                                	${row.productName}
                                	</a>
                                </td>
                                <td><fmt:formatNumber value="${row.price}" type="currency" />원</td>
                                <td>${row.stock}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            </div>
        </div>
    </div>
</body>
</html>
