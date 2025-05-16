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
            color: #007bff;
        }

        .order-history-table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
        }

        .order-history-table th, .order-history-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
        }

        .order-history-table th {
            background-color: #007bff;
            color: #fff;
            font-weight: bold;
        }

        .order-history-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .order-history-table tr:hover {
            background-color: #f1f1f1;
        }

        .btn {
            display: inline-block;
            background-color: #007bff;
            color: #fff;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            text-align: center;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }

        .btn:hover {
            background-color: #0056b3;
        }

        .btn-danger {
            background-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .btn-warning {
            background-color: #ffc107;
            color: #000;
        }

        .btn-warning:hover {
            background-color: #e0a800;
        }
    </style>
</head>
<body>
    <div class="main-container">
        <h1 class="order-header">주문 내역</h1>

        <table class="order-history-table">
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
                        <td id="status-${order.orderIdx}">${order.status}</td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status eq 'PAID'}">
                                    <a href="#" onclick="requestCancelOrder('${order.orderIdx}')" class="btn btn-danger">주문취소(준비중)</a>
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
    </div>
</body>
</html>
