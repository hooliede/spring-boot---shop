package com.example.sp.repository.product;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.sp.entity.product.Category;

public interface CategoryRepository extends JpaRepository<Category, Integer>{
	
	/* 카테고리-id로 카테고리 이름 찾기 */
	Optional<Category> findByCategoryId(int categoryId);
}
