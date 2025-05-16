package com.example.sp.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.example.sp.dto.Payment.OrderDetailDTO;
import com.example.sp.dto.Payment.PaymentDTO;
import com.example.sp.entity.order.OrderDetail;
import com.example.sp.entity.order.OrderItem;
import com.example.sp.entity.order.OrderStatus;
import com.example.sp.entity.product.Product;
import com.example.sp.entity.user.Member;
import com.example.sp.repository.cart.CartRepository;
import com.example.sp.repository.cart.OrderDetailRepository;
import com.example.sp.repository.cart.OrderItemRepository;
import com.example.sp.repository.product.ProductRepository;
import com.example.sp.repository.user.MemberRepository;

import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;

@Controller
@RequestMapping("/order")
public class OrderController {
	
	@Autowired
	MemberRepository mRepository;
	
	@Autowired
	OrderItemRepository oRepository;
	
	@Autowired
	OrderDetailRepository odRepository;
	
	@Autowired
	ProductRepository pRepository;
	
	@Autowired
	CartRepository cRepository;
	

	/* 다중 구매 폼 */
	@PostMapping("/goCardInsert")
	public ModelAndView goCardInsertForm(
			@RequestParam(name = "productCode") List<String> productCode,
			@RequestParam(name = "price") List<Integer> price,
			@RequestParam(name = "amount") List<Integer> amount,
			HttpSession session,
			ModelAndView mav) {
		String userid = (String) session.getAttribute("userid");

		Member member = mRepository.findById(userid)
				.orElseThrow(() -> new RuntimeException("사용자 정보를 찾을 수 없습니다. - " +userid));
		System.out.println("유저 주소값 :: " +member.getMainAddress());
		/* 총 결제금액 */
		int totalPrice = 0;
		for (int i = 0; i < price.size(); i++) {
			totalPrice += price.get(i) * amount.get(i);
		}
		mav.addObject("member", member);
		mav.addObject("productCodeList", productCode);
		mav.addObject("amountList", amount);
		mav.addObject("priceList", price);
		mav.addObject("totalPrice", totalPrice);
		mav.setViewName("order/cardInsert3");
		return mav;
	}
	
	@GetMapping("/success")
	public String orderSuccess(@RequestParam(name = "orderIdx") Long orderIdx,
			Model model) {
		model.addAttribute("orderIdx", orderIdx);
		return "order/success";
	}
	@GetMapping("/failure")
	public String orderFailure(@RequestParam(name = "message") String message,
			Model model) {
		model.addAttribute("message", message);
		return "order/failure";
	}
	
	
	@PostMapping("/payMent")
	@ResponseBody
	@Transactional
	public Map<String, Object> processPayment (
			@RequestBody PaymentDTO request,
			HttpSession session) {
		
		Map<String, Object> response = new HashMap<>();
		String userid = (String) session.getAttribute("userid");
		
		if(userid == null) {
			response.put("success", false);
			response.put("message", "로그인이 필요합니다.");
			return response;
		}
		try {
			/* OrderItem */
			OrderItem orderItem = new OrderItem();
			orderItem.setUserid(userid);
			orderItem.setTotalPrice(request.getTotalPrice());
			orderItem.setStatus(OrderStatus.PAID);
			orderItem.setDeliveryAddress(request.getDeliveryAddress());
			oRepository.save(orderItem);
			
			
			List<OrderDetail> orderDetailList = new ArrayList<>();
			List<Product> updatedProductList = new ArrayList<>();
			
			for (OrderDetailDTO product : request.getProducts()) {
				/* OrderDetail */
				OrderDetail orderDetail = new OrderDetail();
				orderDetail.setOrderItem(orderItem);
				orderDetail.setProductCode(product.getProductCode());
				orderDetail.setAmount(product.getAmount());
				orderDetail.setPrice(product.getPrice());
				
				orderDetailList.add(orderDetail);
				
				/* Product */
				Product product2 = pRepository.findById(product.getProductCode())
						.orElseThrow(() -> new RuntimeException("상품을 찾을 수 없습니다."+product.getProductCode()));
				
				if (product2.getStock() < product.getAmount()) {
					throw new RuntimeException("재고 부족: " +product.getProductCode());
				}
				product2.setStock(product2.getStock() - product.getAmount());
				product2.setSales(product2.getSales() + product.getAmount());
				updatedProductList.add(product2);
			}
			odRepository.saveAll(orderDetailList);
			pRepository.saveAll(updatedProductList);

			/* Cart */
			List<String> productCodes = new ArrayList<>();
			for (OrderDetailDTO product : request.getProducts()) {
				productCodes.add(product.getProductCode());
			}

			cRepository.deleteByMember_UseridAndProduct_ProductCodeIn(userid, productCodes);
			
			response.put("success", true);
			response.put("orderIdx", orderItem.getOrderIdx());
			return response;
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", e.getMessage());
			return response;
		}
	
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


}
