package com.example.sp.dto.product;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ProductDTO {
	private String productCode;
	private String productName;
	private String manufacturer;
	private int price;
	private int stock;
	private int sales;
	private int categoryId;
	
	/* 파일 이미지 */
	private MultipartFile productImage;
	private List<ProductAttributeDTO> productAttributeList;
	
	
}
