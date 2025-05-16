package com.example.sp.repository.cart;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import com.example.sp.entity.order.OrderDetail;
import com.example.sp.entity.order.OrderItem;

public interface OrderDetailRepository extends JpaRepository<OrderDetail, Long>{
	List<OrderDetail> findByOrderItem(OrderItem orderItem);
	
	/* 주문번호 기준 레코드 삭제 */
	@Modifying
    @Transactional
    @Query("DELETE FROM OrderDetail od WHERE od.orderItem.orderIdx IN :orderIdxList")
    void deleteByOrderIdxIn(@Param("orderIdxList") List<Long> orderIdxList);
}
