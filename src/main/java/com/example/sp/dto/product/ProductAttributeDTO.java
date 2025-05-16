package com.example.sp.dto.product;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class ProductAttributeDTO {
	private int paIdx;
	
	private String productCode;
	private String attributeId;
	private String attributeValue;
	
}
