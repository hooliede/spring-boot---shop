package com.example.sp.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.example.sp.entity.product.Attribute;
import com.example.sp.entity.product.Category;
import com.example.sp.entity.product.Product;
import com.example.sp.entity.product.ProductAttribute;
import com.example.sp.repository.product.AttributeRepository;
import com.example.sp.repository.product.ProductRepository;

@Controller
@RequestMapping("/product")
public class ProductController {

	@Autowired
	ProductRepository pRepository;

	@Autowired
	AttributeRepository aRepository;

	/* 카테고리 바 검색 */
	@GetMapping("/categorySearch")
	public ModelAndView categorySearch(@RequestParam(name = "categoryName") String categoryName,
									   ModelAndView mav) {

		// ✅ 앞뒤 공백 제거
		categoryName = categoryName.trim();

		List<Product> productList = pRepository.findByCategoryCategoryName(categoryName);

		// ✅ 디버깅 로그 출력
		System.out.println("[categorySearch] categoryName: [" + categoryName + "]");
		System.out.println("[categorySearch] productList is null? " + (productList == null));
		System.out.println("[categorySearch] productList size: " + (productList != null ? productList.size() : "N/A"));

		if (productList != null && !productList.isEmpty()) {
			mav.addObject("categoryName", categoryName);
			mav.addObject("productList", productList);
		} else {
			mav.addObject("categoryName", categoryName);
			mav.addObject("message", "해당 상품이 비어있습니다!");
		}
		mav.setViewName("/product/List");
		return mav;
	}

	/* 키워드 검색 */
	@GetMapping("/keywordSearch")
	public ModelAndView keywordSearch(@RequestParam(name = "keyword") String keyword,
									  ModelAndView mav) {

		if (keyword == null || keyword.trim().isEmpty()) {
			mav.addObject("message", "검색어를 입력해주세요.");
			mav.setViewName("/product/List");
			return mav;
		}

		List<Product> productList = pRepository.searchByKeyword(keyword);

		// ✅ 디버깅 로그 출력
		System.out.println("[keywordSearch] keyword: [" + keyword + "]");
		System.out.println("[keywordSearch] productList is null? " + (productList == null));
		System.out.println("[keywordSearch] productList size: " + (productList != null ? productList.size() : "N/A"));

		mav.addObject("keyword", keyword);
		if (productList != null && !productList.isEmpty()) {
			mav.addObject("productList", productList);
		} else {
			mav.addObject("message", "해당 상품이 비어있습니다!");
		}
		mav.setViewName("/product/List");

		return mav;
	}

	/* 상품 상세보기 */
	@GetMapping("/detailProduct")
	public ModelAndView detailProduct(@RequestParam(name = "productCode") String productCode,
									  ModelAndView mav) {

		Product product = pRepository.findById(productCode)
				.orElseThrow(() -> new RuntimeException("해당 상품을 찾을 수 없습니다: " + productCode));

		System.out.println("이미지 주소값 : " + product.getImageUrl());

		mav.addObject("product", product);
		mav.addObject("categoryName", product.getCategory().getCategoryName());

		List<Attribute> aList = aRepository.findAttributesByCategoryId(product.getCategory().getCategoryId());
		mav.addObject("aList", aList);

		List<ProductAttribute> paList = product.getProductAttribute();
		mav.addObject("paList", paList);

		mav.setViewName("/product/detail");
		return mav;
	}
}
