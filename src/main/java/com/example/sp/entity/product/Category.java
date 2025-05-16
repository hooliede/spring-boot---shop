package com.example.sp.entity.product;


import java.util.List;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


@Entity
@Getter
@Setter
@ToString
@NoArgsConstructor
public class Category {
	
	/* 카테고리의 종류를 담는 테이블 */
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int categoryId;
	
	private String categoryName;
	

	/* category_id 로 attribute_id 리스트 봐야할 때 */
	//@OneToMany(mappedBy = "category")
	//List<CategoryAttribute> attributeList = new ArrayList<>();
	
	@OneToMany(mappedBy = "category")
	private List<Product> productList;
	
	
	public Category(int categoryId) {
		this.categoryId = categoryId;
	}
}
