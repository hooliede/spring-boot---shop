<%@page import="org.hibernate.internal.build.AllowSysOut"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/css/main/main.css">
    <title>결제하기</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .container-wrapper {
            display: flex;
            flex-direction: row;
            align-items: flex-start;
            width: 100%;
            margin-top: 20px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }

        #category-section {
            flex: 0 0 200px;
        }

        .main-container {
            flex: 1;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            margin-left: 20px;
        }

        .title-container {
            text-align: center;
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }

        .product-container {
            display: flex;
            width: 100%;
            gap: 20px;
        }
        .input-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }

        .card-input-container {
            display: flex;
            gap: 8px;
        }

        .card-input-container input {
            width: calc(25% - 6px);
            padding: 10px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }

        input {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .btn {
            display: block;
            width: 100%;
            max-width: 300px;
            margin: 20px auto;
            padding: 12px 20px;
            font-size: 18px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-align: center;
        }

        .btn:hover {
            background-color: #0056b3;
        }

        .input-box {
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #fff;
        }
		.input-box input {
        	width: calc(100% - 100px);
        	padding: 10px;
        	font-size: 16px;
        	border: 1px solid #ccc;
        	border-radius: 6px;
        	background-color: #f8f9fa;
        	margin-bottom: 10px;
    	}
    	.input-box button {
       		padding: 10px 15px;
        	font-size: 14px;
        	background-color: #007bff;
        	color: white;
        	border: none;
        	border-radius: 4px;
        	cursor: pointer;
    	}
    	.input-box button:hover {
      		background-color: #0056b3;
    	}
    	/* 주문 내역 테이블 스타일 */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }

    th, td {
        border: 1px solid #ddd;
        padding: 12px;
        text-align: center;
    }

    th {
        background-color: #2c3e50;
        color: white;
        font-weight: bold;
    }

    tr:nth-child(even) {
        background-color: #ecf0f1;
    }
    tr:nth-child(odd) {
    	background-color: #ffffff;
    }

    tr:hover {
        background-color: #d5dbdb;
        transition: background-color 0.2s ease-in-out;
    }
    
        .error {
            color: red;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }
    </style>
<script>
function validateCardInfo() {
    let form = document.forms['buy'];
    if (!form) {
        alert('폼을 찾을 수 없습니다.');
        return;
    }

    const cardInputs = form.querySelectorAll(".card-input-container input");
    const cardNumber = Array.from(cardInputs).map(input => input.value).join('');
    const expirationDate = form.querySelector("#expiration-date").value;
    const cvc = form.querySelector("#cvc").value;

    if (cardNumber.length !== 16 || isNaN(cardNumber)) {
        alert("올바른 카드 번호를 입력해주세요 (16자리 숫자).");
        return;
    }

    const expirationPattern = /^(0[1-9]|1[0-2])\/\d{2}$/;
    if (!expirationPattern.test(expirationDate)) {
        alert("유효기간을 MM/YY 형식으로 입력해주세요.");
        return;
    }

    if (cvc.length !== 3 || isNaN(cvc)) {
        alert("올바른 CVC를 입력해주세요 (3자리 숫자).");
        return;
    }

    // ✅ 유효성 검사 통과 시 바로 결제 진행
    processPayment();
}

function processPayment() {
    let form = document.forms['buy'];
    if (!form) {
        alert('폼을 찾을 수 없습니다.');
        return;
    }

    // 상품 코드 및 수량 가져오기
    let productCodeList = Array.from(form.querySelectorAll('input[name="productCode"]'))
        .map(input => input.value);
    let amountList = Array.from(form.querySelectorAll('input[name="amount"]'))
        .map(input => input.value);
	let priceList = Array.from(form.querySelectorAll('input[name="price"]'))
		.map(input => input.value);
    // 총 결제 금액 가져오기
    let totalPrice = form.querySelector('input[name="totalPrice"]').value;
	let deliveryAddress = form.querySelector('input[name="deliveryAddress"]').value;
    // 서버로 보낼 데이터 구성
    let requestData = {
        products: productCodeList.map((code, index) => ({
            productCode: code,
            amount: amountList[index],
            price: priceList[index]
        })),
        totalPrice: totalPrice,
        deliveryAddress: deliveryAddress
    };

    // `fetch`를 사용해 서버로 JSON 요청 보내기 (비동기 처리)
    fetch('/order/payMent', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(requestData)
    })
    .then(response => response.json()) // JSON 응답 받기
    .then(result => {
        if (result.success) {
            alert("결제가 성공적으로 완료되었습니다!");
            window.location.href = "/order/success?orderIdx="+result.orderIdx;
        } else {
            alert("결제 실패: " + result.message);
            window.location.href="/order/failure?message="+encodeURIComponent(result.message);
        }
    })
    .catch(error => {
        console.error("결제 오류:", error);
        alert("결제 중 오류가 발생했습니다.");
        window.location.href = "/payment-failed.jsp"; // ❌ 네트워크 오류 시 실패 페이지 이동
    });
}

</script>

</head>
<body>
	<!-- 상단 네비게이션 -->
	<%@ include file="/WEB-INF/views/include/main/1_floor/header.jsp" %>
    
    <div class="container-wrapper">
      
		    	<div class="main-container">
        <div class = "title-container">
        <h1>결제 정보 입력</h1></div>
        <div class = "product-container">
        <form name="buy" method="post">
            <div class="input-box">
                <div class = "input-group">
                	<h2>👤 구매자 정보</h2>
					<p>이름: ${member.name}</p>
					<p>연락처: ${member.phone}</p>
					<p>이메일: ${member.email}</p>
					<hr>
                </div>
                
                <div class = "input-group">
                <h2>🏠 배송지 관리</h2>
                	<input type="text" name="deliveryAddress" placeholder= "${member.mainAddress}" value="${member.mainAddress}">
                	<hr>
                </div>
                <div class = "input-group">
                <h2>📦 주문 내역</h2><br>
                <table border="1">
    			<tr>
        			<th><span>상품 코드</span></th>
        			<th>수량</th>
        			<th>가격</th>
    			</tr>

    			<c:forEach var="i" begin="0" end="${fn:length(productCodeList) - 1}">
        			<tr>
            			<td>${productCodeList[i]}</td>
            			<td>${amountList[i]}</td>
            			<td><fmt:formatNumber value="${priceList[i]}" type="number" pattern="#,###"/> 원</td>
        			</tr>
        			
        			<input type="hidden" name="productCode" value="${productCodeList[i]}">
        			<input type="hidden" name="amount" value="${amountList[i]}">
        			<input type="hidden" name="price" value="${priceList[i]}">
    			</c:forEach>
				</table>
				</div>                

                <div class = "input-group">
                	<h3 style="align:right;">🛍 총 결제 금액: <fmt:formatNumber value="${totalPrice}" type="number" pattern="#,###"/> 원</h3><hr>
       				<input type="hidden" name="totalPrice" value="${totalPrice}">
       				<h2>💳 카드 정보 입력</h2><br>
       			<!-- 카드번호 -->
                <div class="input-group">
                    <label for="card-number">카드 번호</label>
                    <div class="card-input-container">
                        <input type="text" maxlength="4" placeholder="0000" required>
                        <input type="text" maxlength="4" placeholder="0000" required>
                        <input type="text" maxlength="4" placeholder="0000" required>
                        <input type="text" maxlength="4" placeholder="0000" required>
                    </div>
                </div>

                <!-- 유효기간 -->
                <div class="input-group">
                    <label for="expiration-date">유효기간 (MM/YY)</label>
                    <input type="text" id="expiration-date" name="expirationDate" placeholder="MM/YY" required>
                </div>

                <!-- CVC -->
                <div class="input-group">
                    <label for="cvc">CVC</label>
                    <input type="text" id="cvc" name="cvc" placeholder="123" maxlength="3" required>
                </div>
            </div>

            <!-- 결제 버튼 -->
            <button type="button" class="btn" onclick="validateCardInfo()">결제</button>
        </div>
        </form>
    </div>
    </div>
    </div>
</body>
</html>
