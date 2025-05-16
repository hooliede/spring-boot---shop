<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>가전제품 쇼핑몰</title>


<link rel="stylesheet" type="text/css" href="/css/main/main.css">

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

</head>
<body>
<!-- 상단 네비게이션 -->
<%@ include file="/WEB-INF/views/include/main/1_floor/header.jsp" %>
<div class="main-container">
   <div class="main-layout">
      <!-- 카테고리바 -->
      <div id="category-section">
         <%@ include file="/WEB-INF/views/include/main/2_floor/category.jsp" %>
      </div>
      <!-- 배너 -->
      <div id="banner-section">
         <%@ include file="/WEB-INF/views/include/main/2_floor/banner.jsp" %>
      </div>
      <div id="product-section">
         <%@ include file="/WEB-INF/views/include/main/2_floor/product.jsp" %>
      </div>
   </div>
   <div class = "sub-layout">
   	<div id="customer_center-section">
   		<%@ include file="/WEB-INF/views/include/main/3_floor/noticeHead.jsp" %>
   	</div>
   	<div id="advertise-section">
   		<%@ include file="/WEB-INF/views/include/main/3_floor/advertise.jsp" %>
   	</div>
   </div>
</div>
</body>

</html>
