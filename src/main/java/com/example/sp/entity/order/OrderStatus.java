package com.example.sp.entity.order;



public enum OrderStatus {
	PAID, /* 결제 완료 */
	DELIVERING, /* 배송중 */
	DELIVERED, /* 배송 완료 */
	CANCELING, /* 주문 취소 요청 */
	CANCELED, /* 주문 취소 */
	REFUNDED /* 환불 완료 */
}
