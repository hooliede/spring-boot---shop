<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 내역</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }

        header {
            background-color: #f8f8f8;
            padding: 10px 20px;
            border-bottom: 1px solid #ddd;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .menu-left {
            font-size: 24px;
            font-weight: bold;
            color: #007bff; /* 파란색 */
        }

        .menu-right {
            display: flex;
            gap: 30px;
            font-size: 20px;
        }

        .menu-right a {
            text-decoration: none;
            color: #007bff; /* 파란색 */
            font-weight: bold;
        }

        .menu-right a:hover {
            color: #0056b3; /* 파란색 강조 */
        }

        .main-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .order-header {
            text-align: center;
            margin-bottom: 30px;
            font-size: 32px;
            color: #007bff; /* 파란색 */
        }

        /* 상품 박스 크기 자동 조정 */
        .order-item {
            display: flex;
            justify-content: space-between;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            margin-bottom: 15px;
            background-color: #fff;
            width: 100%;  /* 화면 크기에 따라 자동으로 유동적으로 조정 */
            box-sizing: border-box;
        }

        .order-item img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 5px;
            margin-right: 20px;
        }

        .order-details {
            flex: 1;
            min-width: 250px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .order-details h3 {
            margin: 0 0 10px 0;
            font-size: 18px;
            color: #007bff; /* 파란색 */
        }

        .order-controls {
            text-align: right;
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            justify-content: space-between;
        }

        .order-controls .quantity-container {
            margin-bottom: 5px;
        }

        .order-controls .quantity-container input {
            width: 50px;
            text-align: center;
        }

        .order-controls .price {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }

        .order-summary {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            font-size: 18px;
            font-weight: bold;
            color: #007bff; /* 파란색 */
        }

        .order-summary-total {
            font-size: 18px;
            font-weight: bold;
        }

        .btn {
            display: block;
            background-color: #007bff; /* 파란색 */
            color: #fff;
            padding: 15px 25px;
            border: none;
            border-radius: 5px;
            text-align: center;
            cursor: pointer;
            text-decoration: none;
            font-size: 18px;
            margin-top: 15px;
            width: 100%;
            max-width: 250px;
        }

        .btn:hover {
            background-color: #0056b3; /* 파란색 강조 */
        }
.cancel-btn {
    display: inline-block;
    background-color: #dc3545; /* 빨간색 */
    color: #fff;
    padding: 10px 15px;
    border-radius: 5px;
    text-align: center;
    cursor: pointer;
    text-decoration: none;
    font-size: 14px;
    font-weight: bold;
    border: none;
}

.cancel-btn:hover {
    background-color: #c82333; /* 더 진한 빨간색 */
}
/* 주문 취소 요청 중 스타일 */
.cancelling-text {
    color: #FFA500; /* 주황색 */
    font-weight: bold;
    font-size: 16px;
}

/* 주문 취소 불가 스타일 */
.cannot-cancel-text {
    color: #A9A9A9; /* 회색 */
    font-weight: bold;
    font-size: 16px;
}
    </style>
</head>
<body>
    <div class="main-container">
        <!-- 구매 내역 테이블 -->
        <div id="order-items">
        <c:if test = "${empty orders}">
               <p>주문 내역이 없습니다.</p>
        </c:if>
        <c:forEach var="order" items="${orders}">
        	<div class="order-item">
        		<div class="order-details">
        			<h3>주문번호 ${order.orderIdx}</h3>
        			<p><strong>상품명:  </strong> 
        				<c:forEach var="detail" items="${order.products}">
        					<span>${detail.productCode} (${detail.amount}개)   </span>
        				</c:forEach>
        			</p>
        			<p><strong>배송지:  ${order.deliveryAddress}</strong>
        			<p><strong>주문 날짜: ${order.createdAt}</strong>
        		</div>
        		<div class="order-controls">
					<p id = "status-${order.orderIdx}">
						<strong>주문 상태:${order.status}</strong></p>
						<c:choose>
							<c:when test="${order.status eq 'PAID'}">
								<a href="#" onclick="requestCancelOrder('${order.orderIdx}')" class="cancel-btn" id="cancel-btn-${order.orderIdx}">주문취소</a>
							</c:when>
							<c:when test="${order.status eq 'CANCELING'}">
								<p class="cancelling-text"><strong>주문 취소 요청중</strong>
							</c:when>
							<c:otherwise>
								<p class="cannot-cancel-text"><strong>주문 취소 불가!</strong></p>
							</c:otherwise>
						</c:choose>


					<p><strong>총 금액: ${order.totalPrice} 원</strong></p>        		
        		</div>
        	</div>
        </c:forEach>
        </div>
    </div>
</body>
</html>