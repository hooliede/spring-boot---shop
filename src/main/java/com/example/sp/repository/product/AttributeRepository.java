package com.example.sp.repository.product;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.sp.entity.product.Attribute;

public interface AttributeRepository extends JpaRepository<Attribute, Integer>{
	/* 속성명으로 속성 찾기 */
	Optional<Attribute> findByAttributeName(String attributeName);

	/* 속성아이디로 속성명 찾기 */
	Optional<Attribute> findByAttributeId(int attributeId);
	
	
	/* 특정 categoryId에 해당하는 attribute 리스트 */
	@Query("SELECT a"
		+ " FROM Attribute a JOIN CategoryAttribute ca"
		+ " ON a.attributeId = ca.attributeId"
		+ " WHERE ca.categoryId = :categoryId")
	List<Attribute> findAttributesByCategoryId(@Param("categoryId") int categoryId);

	
	
	
}
