package com.example.sp.entity.product;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Entity
@Getter
@Setter
@NoArgsConstructor
public class Attribute {
	
	/* 속성들의 종류를 담는 테이블 */
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int attributeId;
	
	private String attributeName;
	
	//@OneToMany(mappedBy = "attribute")
	//private List<CategoryAttribute> categoryAttribute;
	
	@OneToMany(mappedBy = "attribute")
	@JsonIgnore
	private List<ProductAttribute> productAttribute;
	
	public Attribute(int attributeId) {
		this.attributeId = attributeId;
	}
}
