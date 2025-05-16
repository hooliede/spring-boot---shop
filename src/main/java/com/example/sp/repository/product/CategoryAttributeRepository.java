package com.example.sp.repository.product;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.sp.entity.product.CategoryAttribute;

public interface CategoryAttributeRepository extends JpaRepository<CategoryAttribute, Integer>{

	List<CategoryAttribute> findByCategoryId(int categoryId);

	/* 특정 카테고리로 속성 리스트 출력 */
	//List<CategoryAttribute> findbyCategoryId(int categoryId);
}
