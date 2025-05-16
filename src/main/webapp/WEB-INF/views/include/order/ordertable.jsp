<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>

<body>
<table border="1" class="order-history-table">
    <thead>
        <tr>
            <th>주문번호</th>
            <th>상품명</th>
            <th>수량</th>
            <th>총 가격</th>
            <th>주문 날짜</th>
            <th>배송 주소</th>
            <th>주문 상태</th>
            <th>주문 상세</th>
        </tr>
    </thead>
    <tbody>
    	<c:if test="${empty orders}">
            <tr>
                <td colspan="8" style="text-align: center;">주문 내역이 없습니다.</td>
            </tr>
        </c:if>
        <c:forEach var="order" items="${orders}">
            <tr>
                <td>${order.orderIdx}</td>
                <td>
                    <c:forEach var="detail" items="${order.orderDetailList}">
                        <span>${detail.productCode}</span><br>
                    </c:forEach>
                </td>
                <td>
                	<c:forEach var="detail" items="${order.orderDetailList}">
                		<span>${detail.amount} 개</span><br>
                	</c:forEach>
                </td>
                <td>${order.totalPrice} 원</td>
                <td>${order.createdAt}</td>
                <td>${order.deliveryAddress}</td>
                <td id = "status-${order.orderIdx}" >${order.status}</td>
                <td>
					    <c:choose>
        					<c:when test="${order.status eq 'PAID'}">
            					<a href="#" onclick="requestCancelOrder('${order.orderIdx}')" class="btn btn-danger" id="cancel-btn-${order.orderIdx}">주문취소(준비중)</a>
        					</c:when>
        					<c:when test="${order.status eq 'CANCELING'}">
            					<button class="btn btn-warning" disabled>주문 취소 요청 중</button>
        					</c:when>
        					<c:when test="${order.status eq 'CANCELED'}">
            					<p>주문 취소 완료</p>
        					</c:when>
        					<c:otherwise>
            					<p>주문 취소 불가!</p>
        					</c:otherwise>
   						 </c:choose>
				</td>
            </tr>
        </c:forEach>
    </tbody>
</table>

</body>

</html>