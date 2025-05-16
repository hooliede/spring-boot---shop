<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문 관리</title>
    <style>
    	h2 {
        text-align: center;
        color: #2c3e50;
    	}
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        .btn {
            padding: 5px 10px;
            border: none;
            cursor: pointer;
            border-radius: 3px;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-back {
        display: block;
        width: fit-content;
        margin: 20px auto;
        padding: 10px 20px;
        font-size: 16px;
    	}
    </style>
</head>
<body>
	<h2>
		<c:choose>
			<c:when test="${isAllOrders}">전체 주문 목록</c:when>
			<c:when test="${isCheckOrders}">승인 대기 주문 목록</c:when>
			<c:otherwise>주문 내역</c:otherwise>
		</c:choose>
	</h2>
    <table>
        <thead>
        	<tr>
        		<th colspan = "2"><button onclick="location.href='/admin/listAllOrder'" class ="btn">전체 주문 보기</button></th>
        		<th><button onclick="location.href='/admin/listOrder'" class="btn">승인대기 주문 보기</button></th>
        		<th><button onclick="deleteAllDeliveredOrders()" class="btn">배송완료 전체삭제</button></th>
        		<th><button onclick="deleteAllCanceledOrders()" class="btn">주문취소완료 전체삭제</button></th>
        	</tr>
            <tr>
                <th>주문번호</th>
                <th>고객명</th>
                <th>상품명</th>
                <th>금액</th>
                <th>상태</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
        <c:choose>
        	<c:when test="${empty orderList}">
        		<tr>
        			<td colspan="6">주문 목록이 없습니다.</td>
        		</tr>
        	</c:when>
        	<c:otherwise>
        
            <c:forEach var="order" items="${orderList}">
                <tr>
                    <td>${order.orderIdx}</td>
                    <td>${order.userid}</td>
                    <td>
                        <c:forEach var="detail" items="${order.orderDetailList}">
                            ${detail.productCode}<br>
                        </c:forEach>
                    </td>
                    <td>${order.totalPrice}</td>
                    <td id="status-${order.orderIdx}">${order.status}</td>
                    <td>
                        <c:choose>
                            <c:when test="${order.status eq 'PAID'}">
                                <button onclick="confirmOrder(${order.orderIdx})" class="btn btn-primary">주문 승인</button>
                            </c:when>
                            <c:when test="${order.status eq 'CANCELING'}">
                                <button onclick="cancelOrder(${order.orderIdx})" class="btn btn-danger">주문 취소 승인</button>
                            </c:when>
                            <c:when test="${order.status eq 'CANCELED'}">
                            	주문 취소 완료
                            </c:when>
                            <c:when test ="${order.status eq 'DELIVERING'}">
                            	배송중
                            </c:when>
                            <c:when test = "${order.status eq 'DELIVERED'}">
                            	배송 완료
                            </c:when>
                        </c:choose>
                    </td>
                </tr>
            	</c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
	<input type="button" class="btn-back" value="돌아가기" onclick="location.href='/admin/dashboard'">
<script>    
    /* 주문 승인 */
    function confirmOrder(orderIdx) {
        fetch("/admin/orderConfirm/"+orderIdx, {
            method: "POST",
            headers: { "Content-Type": "application/json" }
        })
        .then(response => response.json())
        .then(data => {
            alert(data.message);
            location.reload();
        })
        .catch(error => {
            alert("주문 승인 처리에 실패했습니다.");
            console.error("Error:", error);
            if (error.message) {
            	console.error("오류 메시지 : " ,error.message);
            }
        });
    }
	
    /* 주문 취소 승인 */
    function cancelOrder(orderIdx) {
        fetch("/admin/orderCancel/"+orderIdx, {
            method: "POST",
            headers: { "Content-Type": "application/json" }
        })
        .then(response => response.json())
        .then(data => {
            alert(data.message);
            location.reload();
        })
        .catch(error => {
            alert("주문 취소 처리에 실패했습니다.");
            console.error("Error:", error);
        });
    }
    /* 배송 완료 삭제 */
    function deleteAllDeliveredOrders() {
    	if (!confirm("정말 모든 배송완료 주문을 삭제하시겠습니까?")) return;
    	
    	fetch("/admin/deleteAllDeliveredOrders", {
    		method: "POST",
    		headers: { "Content-Type": "application/json" }
    	})
    	.then(response => response.json())
    	.then(data => {
    		alert(data.message);
    		if (data.success) {
    			location.reload();
    		}
    	})
    	.catch(error => {
    		alert("배송 완료 삭제에 실패했습니다.");
    		console.error("Error:", error);
    	});
    }
    /* 주문 취소 삭제 */
    function deleteAllCanceledOrders() {
    	if (!confirm("정말 모든 주문취소 주문을 삭제하시겠습니까?")) return;
    
    	fetch("/admin/deleteAllCanceledOrders", {
    		method: "POST",
    		headers: { "Content-Type": "application/json" }
    	})
    	.then(response => response.json())
    	.then(data => {
    		alert(data.message);
    		if (data.success) {
    			location.reload();
    		}
    	})
    	.catch(error => {
    		alert("주문 취소 삭제에 실패했습니다.");
    		console.error("Error", error);
    	})
    }
</script>
</body>
</html>
