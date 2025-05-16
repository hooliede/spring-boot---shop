package com.example.sp.repository.product;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import com.example.sp.entity.product.ProductAttribute;

import jakarta.transaction.Transactional;

public interface ProductAttributeRepository extends JpaRepository<ProductAttribute, Integer>{

	List<ProductAttribute> findByProduct_ProductCode(String productCode);
	
	
	/* admin - 상품 삭제 */
	@Modifying // ==> "이것은 데이터 변경 쿼리임"
	@Transactional
	void deleteAllByProduct_ProductCode(String productCode);

	/* paIdx 최대값 찾기 */
	@Query("SELECT MAX(pa.paIdx) FROM ProductAttribute pa")
	Integer findMaxPaIdx();

	/* 특정 상품의 속성값찾기 */
	//List<ProductAttribute> findByProductCode(String productCode);
}
