package com.example.sp.entity.product;

import java.util.ArrayList;
import java.util.List;

import com.example.sp.entity.order.Cart;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@ToString
public class Product {
	
	/* 상품의 공용 칼럼을 담는 테이블 */
	
	@Id
	private String productCode;
	
	private String productName;
	private String manufacturer;
	private int price;
	private int stock;
	private int sales;
	private String imageUrl;
	
	@ManyToOne
	@JoinColumn(name = "category_id", nullable = false)
	private Category category;
	
	@OneToMany(mappedBy = "product")
	private List<ProductAttribute> productAttribute;
	
	/* cascade = CascadeType.ALL: 상품이 삭제되면 관련된 장바구니 항목도 자동 삭제됨 */
	/* orphanRemoval = true: 장바구니에서 상품이 삭제되면 자동으로 제거됨 */
	@OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
	private List<Cart> cartItems = new ArrayList<>();
	
	
}
