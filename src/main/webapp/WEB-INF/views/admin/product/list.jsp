<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 상품관리 리스트</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 20px;
        background-color: #f9f9f9;
    }
    h2 {
        text-align: center;
        color: #2c3e50;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0;
    }
    th, td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: center;
    }
    th {
        background-color: #f4f4f4;
        color: #333;
        font-weight: bold;
    }
    tr:nth-child(even) {
        background-color: #f9f9f9;
    }
    tr:hover {
        background-color: #f1f1f1;
    }
    .delete-btn {
		background-color: #e74c3c !important;
	}
	.delete-btn:hover {
		background-color: #c0392b !important;	
	}
    .add-button, input[type="button"] {
        background-color: #007bff;
        color: white;
        border: none;
        padding: 10px 20px;
        margin: 10px 5px;
        cursor: pointer;
        border-radius: 4px;
    }
    .add-button:hover, input[type="button"]:hover {
        background-color: #45a049;
    }
    input[type="submit"] {
        background-color: #007BFF;
        color: white;
        border: none;
        padding: 5px 10px;
        cursor: pointer;
        border-radius: 4px;
    }
    input[type="submit"]:hover {
        background-color: #0056b3;
    }
    select, input[name="keyword"] {
        padding: 5px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }
</style>


</head>
<script>
function viewProductDetail(productCode) {
	location.href="/admin/detailProduct?productCode="+productCode;
}
function ConfirmDelete(productCode) {
	if (confirm("정말 삭제하시겠습니까?")) {
		fetch('/admin/deleteProduct', {
			method: 'POST',
			headers: { "Content-Type": "application/x-www-form-urlencoded" },
			body: "productCode="+ encodeURIComponent(productCode)
		})
		.then(response => response.json())
		.then(data => {
			if (data.message === "success") {
				alert("상품이 삭제되었습니다.");
				location.href = "/admin/listProduct";
			}
		});
	}
}

</script>
<body>
<h2>상품 리스트</h2>
<!-- 검색 폼 -->
<form name="form2" method="get" action="/admin/searchProduct">
    <table>
        <tr>
            <th>제품 분류로 검색</th>
            <th></th>
            <th>제품명으로 검색</th>
        </tr>
        <tr>
            <td>
                <select name="search_type" onchange="this.form.submit();">
                    <option value="">선택안함</option>
                    <option value="Moniter" ${search_type eq 'Moniter' ? 'selected' : ''}>모니터</option>
                    <option value="TV" ${search_type eq 'TV' ? 'selected' : ''}>TV</option>
                    <option value="Laptop" ${search_type eq 'Laptop' ? 'selected' : ''}>노트북</option>
                    <option value="Mobile" ${search_type eq 'Mobile' ? 'selected' : ''}>스마트폰</option>
                    <option value="Refrigerator" ${search_type eq 'Refrigerator' ? 'selected' : ''}>냉장고</option>
                    <option value="Kimchi"  ${search_type eq 'Kimchi' ? 'selected' : ''}>김치냉장고</option>
                    <option value="Dryer" ${search_type eq 'Dryer' ? 'selected' : ''}>세탁건조기</option>
                </select>
            </td>
            <td>&nbsp;</td>
            <td>
                <input name="keyword" value="${keyword}" placeholder="제품명을 입력하세요">
                <input type="submit" value="검색">
            </td>
        </tr>
    </table>
</form>
<!-- 상품 리스트 -->
<form name="form1" method="post">
    <table>
        <tr>
            <th>이미지</th>
            <th>고유번호</th>
            <th>상품명</th>
            <th>제조사</th>
            <th>가격</th>
            <th>분류</th>
            <th>재고량</th>
            <th>상태</th>
            <th>판매량</th>
            <th>상품 관리</th>
        </tr>
        <c:forEach var="row" items="${list}" varStatus="s">
            <tr>
                <td>
                <img src="${row.imageUrl}" alt="상품 이미지" width="100"/>
                </td>
                <td>${row.productCode}</td>
                <td>${row.productName}</td>
                <td>${row.manufacturer}</td>
                <td>${row.price}</td>
                <td>${row.category.categoryName}
                	<input type ="hidden" value="${row.category.categoryId}" name = "categoryId">
                </td>
                <td>${row.stock}</td>
                <td>(준비중)</td>
                <td>${row.sales}</td>
                <td>
                <input type="hidden" value="${row.productCode}" name = "productCode">

                <input type="button" value="제품상세" onclick ="viewProductDetail('${row.productCode}')">
                <input class = "delete-btn" type="button" value="삭제하기" 
                onclick = "ConfirmDelete('${row.productCode}')">
                </td>
            </tr>
        </c:forEach>
    </table>
    <div style="text-align: center;">
        <input type="button" class="add-button" value="상품추가하기" onclick="location.href='/admin/insertProduct'">
        <input type="button" value="돌아가기" onclick="location.href='/admin/dashboard'">
    </div>
</form>
</body>
</html>
