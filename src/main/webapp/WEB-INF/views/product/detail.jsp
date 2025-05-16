<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="/css/main/main.css">
<link rel="stylesheet" type="text/css" href="/css/product/detail.css">
<title>가전제품 쇼핑몰</title>
<!-- 헤더 -->
<style>

.product-container {
   max-width: auto;
   height: auto;
   border-radius: 5px;
    border: 2px solid #e0e0e0;
    background-color: #fff; 
}
/* 이미지 설정 */
  .product-container img {
      width: 100%;    
      border-radius: 8px;
      margin-bottom: 15px;
      margin: auto; /* 이미지 중앙 정렬 */      
  }
  
  
  
  .product-info {
    text-align: center;
}


.product-description {
    font-size: 14px;
    color: #666;
    margin-bottom: 10px;
}

.product-price {
    font-size: 18px;
    font-weight: bold;
    color: #ff5733;
}
</style>
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

<!-- 장바구니 추가 -->
<script>
function add_cart(productCode){	
	
    // 유저가 선택한 수량 가져오기
    const stockSelect = document.getElementById("stock");
    const stock = parseInt(stockSelect.value, 10);
		
    if (isNaN(stock) || stock <= 0) {
        alert("올바른 수량을 선택하세요.");
        return;
    }
    console.log("stock : " +stock);
    console.log("상품 코드 : " +encodeURIComponent(productCode));
	
    fetch("/cart/insertCart", {
    	method: "POST",
    	headers: {
    		"Content-Type": "application/json",
    	},
    	body: JSON.stringify({ productCode: productCode, stock: stock }),
    })
    .then(response => {
    	if(!response.ok) {
    		throw new Error("장바구니 추가 실패!");
    	}
    	return response.json();
    })
   .then(data => {
        // 메시지 영역 업데이트
        const cartMessage = document.getElementById("cart-message");
        cartMessage.innerHTML = 
            "✅ 장바구니에 추가되었습니다!<br>" + 
            "<a href='/cart/listCart' style='color: blue; text-decoration: underline; font-weight: bold;'>[장바구니 보기]</a>";

        cartMessage.style.display = "block";

        // 3초 후 메시지 사라지게 설정
        setTimeout(() => {
            cartMessage.style.display = "none";
        }, 10000);
    })
    .catch(error => {
    	console.error("장바구니 추가 오류 : ", error);
    	alert("장바구니 추가 중 오류가 발생했습니다.");
    });

}   
</script>
<script>
/* 결제하기 */
function checkStockAndProceed(productCode) {
    const stockInput = document.getElementById("stock");
    const requestStock = parseInt(stockInput.value, 10);

    if (isNaN(requestStock) || requestStock <= 0) {
        alert("올바른 수량을 선택하세요.");
        return;
    }

    fetch("/cart/checkOneStock", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ productCode: productCode, amount: requestStock }) // JSON 본문 추가
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === "success") {
            proceedToPayment(productCode, requestStock, data.price);
        } else {
            alert(data.message);
        }
    })
    .catch(error => {
        console.error("재고 확인 오류:", error);
        alert("재고 확인 중 오류가 발생했습니다.");
    });
}

function proceedToPayment(productCode, amount, price) {
    const form = document.createElement("form");
    form.method = "POST";
    form.action = "/order/goCardInsert"; // POST 요청을 보내는 URL

    form.appendChild(createHiddenInput("productCode", productCode));
    form.appendChild(createHiddenInput("amount", amount));
    form.appendChild(createHiddenInput("price", price));

    document.body.appendChild(form);
    form.submit();
}

function createHiddenInput(name, value) {
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = name;
    input.value = value;
    return input;
}
</script>
<!-- 장바구니 추가되었습니다 메세지 -->
<script type="text/javascript">
    var alertMessage = "${alertMessage}";
    if (alertMessage) {
        alert(alertMessage);
    }
</script>
</head>
<body>
    <!-- 상단 네비게이션 -->
    <%@ include file="/WEB-INF/views/include/main/1_floor/header.jsp" %>

    <div class="container-wrapper">
        <!-- 카테고리 섹션 -->
        <div id="category-section">
            <%@ include file="/WEB-INF/views/include/main/2_floor/category.jsp" %>
        </div>

        <div class="main-container">
        	<div id="cart-message" style="display: none; color: green; font-weight: bold; margin-top: 10px;"></div>
            <!-- 상단 제품명 섹션 -->
            <div class="title-container">${product.productName} (<span style="font-size: 17px; color:red;">${product.productCode}</span>)</div>
			<input type="hidden" id="productCode" name="productCode" value="${product.productCode}">
			 <!-- 리뷰 섹션 -->
            <div class="review-container">
                <span class="rating">★★★★★</span>
                <span class="review-count">(1500 reviews)(준비중)</span>
            </div>
			
            <!-- 상품 정보 섹션 -->
            <div class="product-container">
                
                <!-- 좌측 이미지 섹션 -->
             	<div class="product-image-container">
    				<img src="${product.imageUrl}" alt="상품이미지">
				</div>

                <!-- 우측 상세 정보 섹션 -->
                	
                <div class="product-details">
                	<p class = "product-name-right">제품명  <span class="product-title">${product.productName}</span></p>
                    
                    <div class="price-info">
                    	<fmt:formatNumber value="${product.price}" type="currency" />원
                    	<input type="hidden" id="productPrice" value="${product.price}" />
                    </div>
                    <div class="product-options">
                        재고수 : ${product.stock}&nbsp;&nbsp;&nbsp;<label for="stock">수량 선택:</label>
                        <select id="stock" name="amount">
                            <c:forEach var="i" begin="1" end="99">
                                <option value="${i}">${i}개</option>
                            </c:forEach>
                        </select>
                    </div>
                    <input type="hidden" name="price" value ="${product.price}">
                    <div class="button-group">
                    <c:choose>
                    	<c:when test = "${not empty sessionScope.userid}">
                    		<button type = "button" class="add-to-cart" onclick="checkStockAndProceed('${product.productCode}')">구매하기</button>
                    		<button class="add-to-cart" id="addToCartButton" onclick="add_cart('${product.productCode}')">장바구니 추가</button>
                   	 	</c:when>
                   	 	<c:otherwise>
                    		<button class="not-login" type = "button"
                    		onclick="alert('로그인이 필요합니다.'); return false;">
                    		구매하기
                    		</button>
                    		<button class="not-login" type="button" 
                    		onclick="alert('로그인이 필요합니다.'); return false;">
            				장바구니 추가
        					</button>
                    	</c:otherwise>
                    </c:choose>
                        
                    </div>
                </div>
            </div>
			
			
			<!-- 상품 상세정보 섹션 -->
           <div class="product-attributes">
           		<table align="center">
           			<thead>
           				<tr>
           					<td colSpan="2" align="center">제품 속성</td>
           				</tr>
           			</thead>
           		<tbody>
           			<c:forEach var="attribute" items="${aList}" varStatus="status">
           				<tr>
           					<td>${attribute.attributeName}</td>
           					<td>
           						<c:choose>
           							<c:when test = "${not empty paList[status.index]}">
           								${paList[status.index].attributeValue}
           							</c:when>
           							<c:otherwise>
           								없음
           							</c:otherwise>
           						</c:choose>
           					</td>
           				</tr>
           			</c:forEach>
           		</tbody>
           		</table>
           </div>

            <!-- 하단 추가 정보 -->
            <div class="additional-info">
                <table>
                    <tr>
                        <td onclick="location.href='/reviews'">리뷰</td>
                        <td onclick="location.href='/similar_products'">비슷한 제품 보기</td>
                    </tr>
                </table>
            </div>
        </div>
    </div>

</body>
</html>
