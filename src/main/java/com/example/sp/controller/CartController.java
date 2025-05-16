package com.example.sp.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.example.sp.entity.order.Cart;
import com.example.sp.entity.product.Product;
import com.example.sp.entity.user.Member;
import com.example.sp.repository.cart.CartRepository;
import com.example.sp.repository.product.ProductRepository;
import com.example.sp.repository.user.MemberRepository;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/cart")
public class CartController {
	
	@Autowired
	CartRepository cRepository;
	
	@Autowired
	MemberRepository mRepository;
	
	@Autowired
	ProductRepository pRepository;
	
	@GetMapping("/listCart")
	public ModelAndView listCartForm(HttpSession session, ModelAndView mav) {
		String userid = (String) session.getAttribute("userid");
		Member member = mRepository.findById(userid)
				.orElseThrow(() -> new RuntimeException("회원 정보를 찾을 수 없습니다."));
		
		List<Cart> cartList = cRepository.findAllByMember(member);
		/* 0개 일 때 로직 필요. */
		
		mav.addObject("cartList", cartList);
		mav.addObject("userid", userid);
		
		mav.setViewName("/cart/list");
		return mav;
	}
	
	@PostMapping("/insertCart")
	public ResponseEntity<Map<String, String>> insertCart(@RequestBody Map<String, Object> requestData,
			HttpSession session)	{
		String userid = (String) session.getAttribute("userid");
		String productCode = String.valueOf(requestData.get("productCode").toString());
		int amount = Integer.parseInt(requestData.get("stock").toString());
		
		Member member = mRepository.findById(userid)
				.orElseThrow(() -> new RuntimeException("회원 정보를 찾을 수 없습니다."));
		Product product = pRepository.findById(productCode)
				.orElseThrow(() -> new RuntimeException("상품 정보를 찾을 수 없습니다. "));
		
		Cart cart = cRepository.findByMemberAndProduct(member, product);
		/* 장바구니 중복 확인 */
		if (cart != null) {
			/* 기존 수량 증가. */
			cart.setAmount(cart.getAmount() + amount);
			cRepository.save(cart);
		} else {
			Cart newCart = new Cart();
			newCart.setMember(member);
			newCart.setProduct(product);
			newCart.setAmount(amount);
			cRepository.save(newCart);
		}
		
		/* 응답 반환 */
		Map<String, String> response = new HashMap<>();
		response.put("message", "장바구니에 추가되었습니다!");
		
		return ResponseEntity.ok(response);
	}
	
	
	@PostMapping("/deleteCart")
	public ResponseEntity<String> deleteCartItems(@RequestParam(name = "productCodes") List<String> productCodes,
			HttpSession session) {
		String userid = (String) session.getAttribute("userid");
		
		Member member = mRepository.findById(userid)
				.orElseThrow(() -> new RuntimeException(" 사용자 정보를 찾을 수 없습니다. "));
		
		/* 비어 있는 경우 처리 */
		
		if (productCodes == null || productCodes.isEmpty()) {
			return ResponseEntity.badRequest().body("선택된 상품이 없습니다.");
		}
		
		/* 선택된 상품을 장바구니에서 삭제 */
		List<Product> products = pRepository.findAllById(productCodes);
		
		List<Cart> cartList = cRepository.findByMemberAndProductIn(member, products);
		
		if (!cartList.isEmpty()) {
			cRepository.deleteAll(cartList);
		}
		
		return ResponseEntity.ok("선택한 상품이 삭제되었습니다.");
	}
	
	
	/* 단일 상품 재고 검사 */
	@PostMapping("/checkOneStock")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> checkStock(@RequestBody Map<String, Object> requestData) {
	    String productCode = (String) requestData.get("productCode");
	    int amount = (int) requestData.get("amount");

	    Product product = pRepository.findById(productCode)
	            .orElseThrow(() -> new RuntimeException("상품을 찾을 수 없습니다."));

	    Map<String, Object> response = new HashMap<>();
	    if (product.getStock() < amount) {
	        response.put("status", "fail");
	        response.put("message", "상품 [" + product.getProductName() + "]의 재고가 부족합니다! (남은 재고: " + product.getStock() + ")");
	        return ResponseEntity.ok(response);
	    }

	    response.put("status", "success");
	    response.put("price", product.getPrice());
	    return ResponseEntity.ok(response);
	}

	
	/* 장바구니에서 재고수 검사*/
	@PostMapping("/checkStock")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> checkStock(
			@RequestParam(name = "productCode") List<String> productCode,
			@RequestParam(name = "amount") List<Integer> amount) {
		
		Map<String, Object> response = new HashMap<>();
		
		for (int i = 0; i < productCode.size(); i++) {
			String code = productCode.get(i);
			int requestAmount = amount.get(i);
			
			/* 상품 조회 */
			Product product = pRepository.findById(code)
					.orElseThrow(() -> new RuntimeException("상품을 찾을 수 없습니다."));
			
			/* 재고 검사 */
			if (product.getStock() < requestAmount) {
				response.put("status", "fail");
				response.put("message", "상품 [" +product.getProductName() + "]의 재고가 부족합니다! (남은 재고 : " +product.getStock()+")");
				return ResponseEntity.ok(response);
			}
		}
		
		/* 모든 상품의 재고가 충분하면 success */
		
		response.put("status", "success");
		
		
		return ResponseEntity.ok(response);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
