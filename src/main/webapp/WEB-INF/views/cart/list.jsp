<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장바구니</title>
    
<link rel="stylesheet" type="text/css" href="/css/cart/cartList.css">  

<script>
/*      전체 선택       */
function SelectAll() {
    // 모든 체크박스를 가져옴
    const checkboxes = document.querySelectorAll('.checkbox');

    // 전체 선택 상태를 확인하고 반영
    const allChecked = Array.from(checkboxes).every(checkbox => checkbox.checked);

    // 전체 선택이 아니라면 모두 체크, 이미 전체 선택이 되어 있으면 해제
    checkboxes.forEach(checkbox => {
        checkbox.checked = !allChecked;
    });
    
    /* 총 상품금액 업데이트 */
    calculateTotal();
}

/* 총 상품 금액 */
function calculateTotal() {
	let totalPrice = 0;
	const cartItems = document.querySelectorAll('.cart-item');

	cartItems.forEach(item => {
		const checkbox = item.querySelector('.checkbox');
		if (checkbox.checked) {
			const priceText = item.querySelector('.price').textContent.replace('원', '').replace(/,/g, '').trim();
			const price = parseFloat(priceText); //가격을 숫자로 변환

			const stockText = item.querySelector('.quantity-stock').value.trim();
			const stock = parseInt(stockText, 10); //수량을 숫자로 변환
			
			//console.log(`가격: ${price}, 수량: ${stock}`);
			if (!isNaN(price) && !isNaN(stock)) {
				totalPrice += price * stock;
			}
		}
	});

	document.getElementById('total-price').textContent = totalPrice.toLocaleString();
}

/* 선택 삭제  */

function removeSelectedItems() {
    const selectedItems = [];
    const cartItems = document.querySelectorAll('.cart-item');

    cartItems.forEach(item => {
        const checkbox = item.querySelector('.checkbox');
        if (checkbox.checked) {
            const productCode = item.querySelector('h3 span').textContent.trim(); // ✅ productCode 가져오기
            selectedItems.push(productCode);
        }
    });

    if (selectedItems.length === 0) {
        alert("선택된 항목이 없습니다.");
        return;
    }

    /* 데이터를 URL-encoded 형식으로 변환 */
    const params = new URLSearchParams();
    selectedItems.forEach(productCode => params.append('productCodes', productCode));

    /* fetch API로 데이터 전송 */
    fetch('/cart/deleteCart', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params.toString(),
    })
    .then(response => {
        if (response.ok) {
            alert("선택한 상품이 장바구니에서 삭제되었습니다.");
            window.location.reload(); // ✅ 페이지 새로고침하여 UI 업데이트
        } else {
            alert("삭제에 실패했습니다.");
        }
    })
    .catch(error => {
        console.error("삭제 오류:", error);
        alert("서버와 통신 중 오류가 발생했습니다.");
    });
}
/* 결제하기 */
function handlePayment() {
    const selectedItems = [];
    const cartItems = document.querySelectorAll('.cart-item');

    console.log("전체 장바구니 항목들:", cartItems);

    // 선택된 항목을 확인하여 productCode와 amount 값을 추출
    cartItems.forEach(item => {
        const checkbox = item.querySelector('.checkbox');
        if (checkbox.checked) {
            const productCode = item.querySelector('h3 span').textContent.trim();
            const amount = item.querySelector('.quantity-stock').value;
            const price = parseInt(item.querySelector('.price').textContent.replace('원', '').replace(/,/g, ''));
            console.log("선택된 상품:"+productCode+", 수량: "+amount+", 가격:" +price);

            selectedItems.push({ productCode, amount, price });
        }
    });

    console.log("선택된 항목들:", selectedItems);

    // 선택된 항목이 없을 경우 경고
    if (selectedItems.length === 0) {
        alert("선택된 항목이 없습니다.");
        return;
    }

    // 재고수 검사로 이동.
    checkStock(selectedItems);
}

function checkStock(selectedItems) {
    const params = new URLSearchParams();
    selectedItems.forEach(item => {
        //console.log(`파라미터 추가: productCode = ${item.productCode}, amount = ${item.amount}`);
        params.append('productCode', item.productCode);
        params.append('amount', item.amount);
    });

    //console.log("전송할 파라미터들:", params.toString());

    fetch('/cart/checkStock', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params.toString(),
    })
    .then(response => response.json())
    .then(data => {
        console.log("서버 응답 데이터:", data);

        if (data.status === "success") {
            alert("✅ 재고 확인 완료! 결제 페이지로 이동합니다.");
            calculateTotal(); // 재고 확인 후 totalPrice 업데이트
            proceedToOrder(selectedItems);  // 결제 진행
        } else {
        	if (data.message) {
        		alert("❌"+data.message);
        	}
        }
    })
    .catch(error => {
        console.error('❌ 재고 확인 중 오류 발생:', error);
        alert('서버와 통신 중 문제가 발생했습니다.');
    });
}

function proceedToOrder(selectedItems) {
    // 폼 생성
    var form = document.createElement("form");
    form.method = "POST";
    form.action = "/order/goCardInsert"; // 결제 페이지 URL 설정

    // 선택된 상품 데이터를 폼에 추가
    selectedItems.forEach(function(item) {
        var inputProductCode = document.createElement("input");
        inputProductCode.type = "hidden";
        inputProductCode.name = "productCode"; // 서버에서 받을 key 값
        inputProductCode.value = item.productCode;
        form.appendChild(inputProductCode);

        var inputAmount = document.createElement("input");
        inputAmount.type = "hidden";
        inputAmount.name = "amount"; // 서버에서 받을 key 값
        inputAmount.value = item.amount;
        form.appendChild(inputAmount);

        var inputPrice = document.createElement("input");
        inputPrice.type = "hidden";
        inputPrice.name = "price"; // 서버에서 받을 key 값
        inputPrice.value = item.price;
        form.appendChild(inputPrice);
    });

    // 폼을 body에 추가 후 제출
    document.body.appendChild(form);
    form.submit();
}


</script>
</head>
<body>
<%@ include file="/WEB-INF/views/include/main/1_floor/header.jsp" %>

	
    <div class="main-container">
        <h1 class="cart-header">장바구니 ${fn:length(cartList)}개</h1>

        <div class="summary-controls">
            <button class="select-all" onclick="SelectAll()">전체 선택</button>
            <button class="remove-selected" onclick="removeSelectedItems()">선택 삭제</button>
        </div>

        <div id="cart-items">
			<c:set var="totalPrice" value="0" />
			<c:forEach var="row" items="${cartList}">
				<div class="cart-item">
						<input type="checkbox" class="checkbox" id="checkbox-${row.product.productCode}" onchange="calculateTotal()"/>
						<img src="${row.product.imageUrl}">
						<div class = "cart-details">
						<h3>${row.product.productName} (<span>${row.product.productCode}</span>)</h3>
						</div>
					<div class="cart-controls">
						<div class="quantity-container">
							<label for="quantity-${row.product.productCode}">수량:</label>
							<input type='number' class="quantity-stock" 
							id='quantity-${row.product.productCode}' value = "${row.amount}" 
							onchange="calculateTotal();">
						</div>
						<p class="price"><fmt:formatNumber value="${row.product.price}" type="number" pattern="#,###" />원</p>
						
					</div>
				</div>
				<c:set var="totalPrice" value="{totalPrice + (row.product.price * row.amount)}" />
			</c:forEach>
			
        </div>

        <div class="summary">
            <p class="total">총 상품 금액: <span id="total-price">{totalPrice}</span>원</p>
            <a href="javascript:void(0);" class="btn" onclick="handlePayment()">결제하기</a>
        </div>
    </div>
    <script>
    	// 페이지 로드 후 초기 금액 계산
    	window.onload = function() {
    		calculateTotal();
    	};
    </script>
</body>
</html>
