<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/css/main/main.css">
    <title>카드 결제</title>
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

        .error {
            color: red;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }
    </style>
<script>
    function processPayment() {
        // 'buy'라는 name 속성을 가진 form을 정확히 선택
        let form = document.forms['buy']; // form name을 'buy'로 지정
        if (!form) {
            alert('폼을 찾을 수 없습니다.');
            return false;
        }

        // 카드 번호 입력 필드 가져오기
        const cardInputs = form.querySelectorAll(".card-input-container input");
        const cardNumber = Array.from(cardInputs).map(input => input.value).join('');
        const expirationDate = form.querySelector("#expiration-date").value;
        const cvc = form.querySelector("#cvc").value;

        // 카드 번호 유효성 검사
        if (cardNumber.length !== 16 || isNaN(cardNumber)) {
            alert("올바른 카드 번호를 입력해주세요 (16자리 숫자).");
            return false;
        }

        // 유효기간 검사 (MM/YY)
        const expirationPattern = /^(0[1-9]|1[0-2])\/\d{2}$/;
        if (!expirationPattern.test(expirationDate)) {
            alert("유효기간을 MM/YY 형식으로 입력해주세요.");
            return false;
        }

        // CVC 검사
        if (cvc.length !== 3 || isNaN(cvc)) {
            alert("올바른 CVC를 입력해주세요 (3자리 숫자).");
            return false;
        }

        // 상품명(input[name="full_name"]) 값 가져오기
        let full_name_input = form.querySelector('input[name="full_name"]');
        if (!full_name_input) {
            alert('상품명 정보가 없습니다.');
            return false;
        }
        let full_name = full_name_input.value;

        // 수량(input[name="stock"]) 값 가져오기
        let stock_input = form.querySelector('input[name="request_stock"]');
        if (!stock_input) {
            alert('수량 정보가 없습니다.');
            return false;
        }
        let request_stock = parseInt(stock_input.value, 10);

        console.log('full_name : ' + full_name);
        console.log('stock : ' + request_stock);

        // 폼의 action을 설정하여 전송할 URL을 지정
        form.action = "/jsp_project/product_servlet/detail_buy_product.do";
        
        // 폼 제출
        form.submit();
        
        // 결제 성공 메시지
        //alert("결제가 성공적으로 처리되었습니다.");
    }
</script>

</head>
<body>
	<!-- 상단 네비게이션 -->
	<%@ include file="/include/main/1_floor/header.jsp" %>
    
    <div class="container-wrapper">
        <!-- 카테고리 섹션 -->
        <div id="category-section">
            <%@ include file="/include/main/2_floor/category.jsp" %>
        </div>
		    	<div class="main-container">
        <div class = "title-container">
        <div>
        	<p>${param.full_name}</p>
        </div>
        <h2>🛒 주문 내역</h2></div>
        <div class = "product-container">
        <form name="buy" method="post">
            <div class="input-box">
                <!-- 카드 번호 -->
                <div class ="input-group">
                	<label for="product_name">상품명</label>
                    <span>${param.full_name}</span>
                </div>
                <div class = "input-group">
                	<label for="stock">수량</label>
                    <!-- stock 값 출력 -->
                    <span>${param.request_stock}</span>
                </div>
                <div class = "input-group">
                	<label for ="total-price">결제 가격</label>
                	<span>${param.total_price}원</span>
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
            <input type = "hidden" name = "full_name" value = "${param.full_name}">
            <input type = "hidden" name = "request_stock" value = "${param.request_stock}">
            <button type="button" class="btn" onclick="processPayment()">결제</button>
        </div>
        </form>
    </div>
    </div>
    </div>
</body>
</html>
