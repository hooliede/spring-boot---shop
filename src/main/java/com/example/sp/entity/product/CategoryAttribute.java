package com.example.sp.entity.product;

import jakarta.persistence.Entity;

import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


@Entity
@Getter
@Setter
@ToString
public class CategoryAttribute {
	
	/* 카테고리별로 어떤 속성을 담고있는지 보여주는 테이블 */
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int caIdx;
	
	private int categoryId;
	private int attributeId;
	
	
	/* category_id */
	//@ToString.Exclude
	//@ManyToOne(fetch = FetchType.LAZY)
	//@JoinColumn(name = "category_id")
	//private Category category; /* 필드 생성 */
	
	/* attribute_id */
	//@ToString.Exclude
	//@ManyToOne(fetch = FetchType.LAZY)
	//@JoinColumn(name = "attribute_id")
	//private Attribute attribute;
	
	
}
