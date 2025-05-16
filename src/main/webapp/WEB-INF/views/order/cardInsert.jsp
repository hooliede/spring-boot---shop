<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>카드 결제</title>
</head>
<body>

<h2>🛒 주문 내역</h2>

<table border="1">
    <tr>
        <th>상품 코드</th>
        <th>수량</th>
        <th>가격</th>
    </tr>

    <c:forEach var="i" begin="0" end="${fn:length(productCodeList) - 1}">
        <tr>
            <td>${productCodeList[i]}</td>
            <td>${amountList[i]}</td>
            <td><fmt:formatNumber value="${priceList[i]}" type="number" pattern="#,###"/> 원</td>
        </tr>
    </c:forEach>
</table>
<h3>🛍 총 결제 금액: <fmt:formatNumber value="${totalPrice}" type="number" pattern="#,###"/> 원</h3>
<h2>💳 카드 정보 입력</h2>

<form method="POST" action="/order/processPayment">
    <label>카드 번호:</label>
    <input type="text" name="cardNumber" required><br>

    <label>유효기간 (MM/YY):</label>
    <input type="text" name="expiryDate" required><br>

    <label>CVV:</label>
    <input type="text" name="cvv" required><br>

    <!-- 선택한 상품 정보도 숨겨서 같이 전송 -->
    <c:forEach var="i" begin="0" end="${fn:length(productCodeList) - 1}">
        <input type="hidden" name="productCodes" value="${productCodes[i]}">
        <input type="hidden" name="amounts" value="${amounts[i]}">
        <input type="hidden" name="prices" value="${prices[i]}">
    </c:forEach>

    <button type="submit">💰 결제하기</button>
</form>

</body>
</html>
