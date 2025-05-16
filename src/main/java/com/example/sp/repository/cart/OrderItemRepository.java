package com.example.sp.repository.cart;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.sp.entity.order.OrderItem;
import com.example.sp.entity.order.OrderStatus;

@Repository
public interface OrderItemRepository extends JpaRepository<OrderItem, Long>{
	List<OrderItem> findByUserid(String userid);
	
	/* 특정 상태 목록들에 해당하는 주문만 조회 */
	List<OrderItem> findByStatusIn(List<OrderStatus> of);
	
	/* 특정 상태에 해당하는 주문만 조회 */
	List<OrderItem> findByStatus(OrderStatus delivered);
}
