package com.example.sp.repository.product;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.sp.entity.product.Product;
import com.example.sp.entity.user.Member;

public interface ProductRepository extends JpaRepository<Product, String>{
	
	/* 카테고리 & 제품명 검색 */
	List<Product> findByCategoryCategoryNameAndProductNameContaining(String categoryName, String keyword);
	/* 카테고리 검색 */
	List<Product> findByCategoryCategoryName(String categoryName);
	/* 제품명 검색 */
	List<Product> findByProductNameContaining(String keyword);
	Optional<Member> findByProductCode(String productCode);

	/* 키워드 검색 */
	@Query("SELECT p FROM Product p LEFT JOIN p.category c " +
	           "WHERE p.productName LIKE %:keyword% " +
	           "OR p.productCode LIKE %:keyword% " +
	           "OR c.categoryName LIKE %:keyword%")
	List<Product> searchByKeyword(@Param("keyword") String keyword);
	
	
}
