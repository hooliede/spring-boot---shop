package com.example.sp.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import org.hibernate.internal.build.AllowSysOut;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.sp.dto.Member.AdminDTO;
import com.example.sp.dto.Member.MemberDTO;
import com.example.sp.dto.product.ProductAttributeDTO;
import com.example.sp.dto.product.ProductDTO;
import com.example.sp.dto.product.ProductUpdateDTO;
import com.example.sp.entity.order.OrderDetail;
import com.example.sp.entity.order.OrderItem;
import com.example.sp.entity.order.OrderStatus;
import com.example.sp.entity.product.Attribute;
import com.example.sp.entity.product.Category;
import com.example.sp.entity.product.CategoryAttribute;
import com.example.sp.entity.product.Product;
import com.example.sp.entity.product.ProductAttribute;
import com.example.sp.entity.user.Admin;
import com.example.sp.entity.user.Member;
import com.example.sp.repository.cart.OrderDetailRepository;
import com.example.sp.repository.cart.OrderItemRepository;
import com.example.sp.repository.product.AttributeRepository;
import com.example.sp.repository.product.CategoryAttributeRepository;
import com.example.sp.repository.product.CategoryRepository;
import com.example.sp.repository.product.ProductAttributeRepository;
import com.example.sp.repository.product.ProductRepository;
import com.example.sp.repository.user.AdminRepository;
import com.example.sp.repository.user.MemberRepository;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	AdminRepository adminRepository;
	
	@Autowired
	MemberRepository mRepository;
	
	@Autowired
	CategoryRepository cRepository;
	
	@Autowired
	ProductRepository pRepository;
	
	@Autowired
	AttributeRepository aRepository;
	
	@Autowired
	CategoryAttributeRepository caRepository;
	
	@Autowired
	ProductAttributeRepository paRepository;
	
	@Autowired
	OrderItemRepository oRepository;
	@Autowired
	OrderDetailRepository odRepository;
	
	@Autowired
	ModelMapper modelMapper;
	
	@Autowired
	RestTemplate restTemplate;
	
	private static final String PRODUCT_IMAGE_PATH = "C:/upload/product/"; // 상품 이미지 저장 경로
	private static final String DEFAULT_IMAGE =  "/product/default.jpg"; // 기본 이미지 파일명
	
	/* 로그인 기능 */
	/* select * from member where userid =? and passwd = ? */
	@PostMapping("/login")
	public ModelAndView login(AdminDTO dto, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		Optional<Admin> adminResult = adminRepository.findByUseridAndPasswd(dto.getUserid(), dto.getPasswd());
		int products = (int) pRepository.count();
		int users = (int) mRepository.count();
		if(adminResult.isPresent()) {
			/* entity -> jsp */
			Admin a = adminResult.get();
			String name = a.getName();
			session.setAttribute("userid", dto.getUserid());
			session.setAttribute("name", name);
			session.setAttribute("level", a.getLevel());
			session.setAttribute("result", name+"님 환영합니다.");
			session.setAttribute("products", products);
			session.setAttribute("users", users);
			mav.setViewName("redirect:/admin/dashboard");
		} else {
			mav.setViewName("/admin/admin_login");
			mav.addObject("message", "error");
		}
		return mav;
	}
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/admin";
	}
	
	
	@GetMapping("/dashboard")
	public ModelAndView adminDashboard(HttpSession session, ModelAndView mav) {
		int products = (int) pRepository.count();
		int users = (int) mRepository.count();
		mav.setViewName("admin/admin_result");
		/* 세션에서 관리자 정보 가져오기 */
		mav.addObject("userid", session.getAttribute("userid"));
		mav.addObject("name", session.getAttribute("name"));
		mav.addObject("level", session.getAttribute("level"));
		mav.addObject("result", session.getAttribute("result"));
		mav.addObject("users", users);
		mav.addObject("products", products);
		return mav;
	}
	
	/* --------------------------------상품----------------------------*/
	
	@GetMapping("/api/products")//react랑 연결하는 쪽
	@ResponseBody
	public List<Product> getProductListForApi() {
		return pRepository.findAll();
	}
	
	/* 상품 등록폼 */
	@GetMapping("/insertProduct")
	public String insertProdcutForm() {
		return "/admin/product/insert";
	}

	/* 상품 등록 */
	@PostMapping("/insertProduct")
	public String insertProduct(@ModelAttribute ProductDTO productDTO) {

	    /* entity에 값 삽입 */
	    Product product = new Product();
	    product.setProductCode(productDTO.getProductCode());
	    product.setProductName(productDTO.getProductName());
	    product.setManufacturer(productDTO.getManufacturer());
	    product.setPrice(productDTO.getPrice());
	    product.setStock(productDTO.getStock());

	    /* categoryId -> category entity -> product entity */
	    Optional<Category> category = cRepository.findByCategoryId(productDTO.getCategoryId());
	    if (category.isPresent()) {
	        product.setCategory(category.get());
	    }
	    
	    /* 이미지 업로드 */
	    String imageUrl = DEFAULT_IMAGE; // 기본 이미지 설정
	    MultipartFile file = productDTO.getProductImage();
	    if (file != null && !file.isEmpty()) {
            try {
                // ✅ 디렉토리 확인 및 생성
                File uploadDir = new File(PRODUCT_IMAGE_PATH);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // ✅ 파일명 생성 및 저장
                String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
                File targetFile = new File(PRODUCT_IMAGE_PATH + fileName);
                file.transferTo(targetFile);

                imageUrl = "/product/" + fileName;

            } catch (IOException e) {
                e.printStackTrace();
            }
        }
	    product.setImageUrl(imageUrl);
	    
	    pRepository.save(product);
	    
	    /* ProductAttribute 저장 (N개 레코드) */
	    if (productDTO.getProductAttributeList() != null) {
	        for (ProductAttributeDTO paDTO : productDTO.getProductAttributeList()) {
	            ProductAttribute pa = new ProductAttribute();
	            
	            /* product_code (product entity) 셋팅 */
	            pa.setProduct(product);
	            /* a-value 셋팅 */
	            pa.setAttributeValue(paDTO.getAttributeValue());
	            
	            Integer maxPaIdx = paRepository.findMaxPaIdx();
	            pa.setPaIdx((maxPaIdx == null) ? 1 : maxPaIdx + 1);
	            
	            /* a-id (attribute entity) 셋팅 */
	            try {
	                int attributeId = Integer.parseInt(paDTO.getAttributeId());
	                Optional<Attribute> attribute = aRepository.findByAttributeId(attributeId);

	                if (attribute.isPresent()) {
	                    pa.setAttribute(attribute.get());

	                    paRepository.save(pa); // 실제 저장 부분은 일단 주석 처리
	                } else {
	                    System.out.println("❌ 속성 ID " + attributeId + "에 해당하는 Attribute 없음");
	                }
	            } catch (NumberFormatException e) {
	                System.out.println("❌ 속성 ID 변환 오류: " + paDTO.getAttributeId());
	                continue;
	            }
	        }
	    }
	    
	    return "redirect:/admin/listProduct";
	}
	
	@GetMapping("/checkProductCode")
	public ResponseEntity<Map<String, Boolean>> checkProductCode(@RequestParam(name="productCode") String productCode) {
		/* DB 중복 조회 */
		boolean exists = pRepository.existsById(productCode);
		Map<String, Boolean> response = new HashMap<>();
		response.put("exists", exists);
		return ResponseEntity.ok(response);
	}
	
	
	@GetMapping("/listProduct")
	public ModelAndView listProduct(ModelAndView mav) {
		/* product table 리스트 */
		
		List<Product> productList = pRepository.findAll();
		
		mav.setViewName("/admin/product/list");
		mav.addObject("list", productList);
		return mav;
	}
	
	@GetMapping("/detailProduct")
	public ModelAndView productDetail(@RequestParam("productCode") String productCode,
			ModelAndView mav) {
		/* 1. product entity */
		Optional<Product> result = pRepository.findById(productCode);
		
		if (!result.isPresent()) {
			mav.setViewName("redirect:/admin/listProduct");
			return mav;
		}
		
		Product product = result.get();
		mav.addObject("product", product); // product enttiy 출력용
		
		/* 2. category-name */
		
		String categoryName = product.getCategory().getCategoryName();
		
		mav.addObject("categoryName", categoryName); //categoryName 출력용
		
		/* 3 attr-name List */
		int categoryId = product.getCategory().getCategoryId();
		
		List<Attribute> aList = aRepository.findAttributesByCategoryId(categoryId);
		
		
		mav.addObject("aList", aList); // attributeName List 출력용
		/* 4. attr-value List */
		List<ProductAttribute> paList = product.getProductAttribute();
		
		mav.addObject("paList", paList); // attributeValue List 출력용
		/* detail 페이지로 이동 */
		mav.setViewName("/admin/product/detail");
		return mav;
	}
	
	@PostMapping("/updateProduct")
	public ResponseEntity<String> updateProduct(@RequestBody ProductUpdateDTO updateDTO) {
		
		try {
			/* 1. product */
			
			String productCode = updateDTO.getProductCode();
			int price = updateDTO.getPrice();
			
			Optional<Product> result = pRepository.findById(productCode);
			if (result.isPresent()) {
				Product product = result.get();
				product.setPrice(price);
				//pRepository.save(product);
			} else {
				return ResponseEntity.status(HttpStatus.NOT_FOUND)
						.body("상품을 찾을 수 없습니다.");
			}
			
			/* 2. product_attribute */
			List<ProductAttributeDTO> paList = updateDTO.getAttributes();		
			
			for (ProductAttributeDTO dto : paList) {
				Optional<ProductAttribute> result2 = paRepository.findById(dto.getPaIdx());
				
				if (result2.isPresent()) {
					ProductAttribute pa = result2.get();
					pa.setAttributeValue(dto.getAttributeValue());
					//paRepository.save(pa);
				} else {
					return ResponseEntity.status(HttpStatus.NOT_FOUND)
							.body("속성 ID :" +dto.getPaIdx()+"을 찾을 수 없습니다.");
				}
			}
		
			return ResponseEntity.ok("업데이트 성공");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body("업데이트 실패 :" +e.getMessage());
		}
	}
	
	@PostMapping("/deleteProduct")
	public ResponseEntity<Map<String, Object>> deleteProduct(@RequestParam(name = "productCode") String productCode) {
		/* 자식 테이블 --> 부모 테이블 순으로 삭제 */
		
		Map<String, Object> response = new HashMap<>();
		/* 1. 자식 데이터 삭제 */
		paRepository.deleteAllByProduct_ProductCode(productCode);
		/* 2. 부모 데이터 삭제 */
		try {
			pRepository.deleteById(productCode);
			response.put("message", "success");
			return ResponseEntity.ok(response);
		} catch (Exception e) {
			response.put("message", "fail");
			response.put("error", "서버 오류 발생");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
		
	}
	
	/* 상품검색 */
	@GetMapping("/searchProduct")
	public ModelAndView searchProduct(@RequestParam(value="search_type", required = false) String categoryName,
			@RequestParam(value = "keyword", required = false) String keyword,
			ModelAndView mav) {
		
		System.out.println("서치타입 : " +categoryName);
		System.out.println("키워드 : " +keyword);
		
		List<Product> productList;
		
		/* 1. 카테고리 & 제품명 검색 */
		if (categoryName != null && !categoryName.isEmpty() && keyword != null && !keyword.isEmpty()) {
			productList = pRepository.findByCategoryCategoryNameAndProductNameContaining(categoryName, keyword);
		}
		/* 2. 카테고리 검색 */
		else if (categoryName != null && !categoryName.isEmpty()) {
			productList = pRepository.findByCategoryCategoryName(categoryName);
		}
		/* 제품명 검색 */
		else if (keyword != null && !keyword.isEmpty()) {
			productList = pRepository.findByProductNameContaining(keyword);
		}
		/* 전체 조회 */
		else {
			productList = pRepository.findAll();
		}
		mav.addObject("list", productList);
		mav.addObject("search_type", categoryName);
		mav.addObject("keyword", keyword);
		mav.setViewName("/admin/product/list");
		return mav;
	}
	
	/* --------------------------------연습----------------------------*/
	
	/* 연습용 */
	@GetMapping("/category_list")
	public ModelAndView category_list(ModelAndView mav) {
		
		System.out.println("HI");
		
		/* db에서 카테고리 값을 가져와서 entity-list 를 view에 쏘아버리기. */
		
		List<Category> category_list = cRepository.findAll();
		mav.addObject("list", category_list);
		mav.setViewName("/admin/category/list");
		return mav;
		
	}
	/* 연습용 */
	@GetMapping("/calist")
	public String calist() {
		return "/admin/category_attribute/input";
	}
	
	/* ---------------------------ResponseBody--------------------------*/
	
	/* 이 컨트롤러가 하는 일
	 *  사용자가 카테고리를 선택하면 /product/getAttributes?categoryId=1 요청을 보냄
	 *  컨트롤러에서 해당 카테고리에 속하는 attribute_name 리스트를 JSON 형태로 반환
	 *  AJAX에서 이 JSON 데이터를 받아서 속성 입력 필드를 동적으로 생성
	 * */
	@RequestMapping("/getAttributes")
	@ResponseBody
	public List<Attribute> getAttributesByCategoryId(@RequestParam(name="categoryId", defaultValue = "1") int categoryId) {
		System.out.println("categoryID : " +categoryId);
	    /* Step 1: 한 번의 쿼리로 CategoryAttribute와 Attribute 테이블을 JOIN하여 속성 리스트 가져오기 */
	    List<Attribute> attributeList = aRepository.findAttributesByCategoryId(categoryId);
	    System.out.println("🔥 반환할 attributeList 크기: " + attributeList.size());
	    for (Attribute attr : attributeList) {
	    	System.out.println("출력할 카테고리 이름 리스트 : " +attr.getAttributeName());
	    }
	    return attributeList;
	}

	
	
	/* --------------------------------유저----------------------------*/
	
	@GetMapping("/listUser")
	public ModelAndView listUser(ModelAndView mav) {
		List<Member> memberList = mRepository.findAll();
		
		mav.setViewName("/admin/user/list");
		mav.addObject("list", memberList);
		
		return mav;
	}
	
	
	@GetMapping("/detailUser")
	public ModelAndView detailUser(@RequestParam(name = "userid") String userid,
			ModelAndView mav) {
		
		System.out.println("유저 아이디 : " +userid);
		Optional<Member> result = mRepository.findByUserid(userid);
		if(result.isPresent()) {
			Member member = result.get();
			
			mav.addObject("member", member);
			mav.setViewName("/admin/user/detail");
		}
		return mav;
	}
	/* 회원 수정 */
	@PostMapping("/updateUser")
	public String updateUser(MemberDTO memberDto) {
		System.out.println("아이디: " +memberDto.getUserid());
		System.out.println("이름: " +memberDto.getName());
		System.out.println("닉네임: " +memberDto.getNickname());
		System.out.println("전화번호: " +memberDto.getPhone());
		System.out.println("주소: " +memberDto.getMainAddress());
		
		Optional<Member> result = mRepository.findById(memberDto.getUserid());
		
		if (result.isPresent()) {
			Member updateMember = result.get();
			updateMember.setName(memberDto.getName());
			updateMember.setNickname(memberDto.getNickname());
			updateMember.setPhone(memberDto.getPhone());
			updateMember.setMainAddress(memberDto.getMainAddress());
			updateMember.setSubAddress(memberDto.getSubAddress());
			
			mRepository.save(updateMember);
		}
		
		return "redirect:/admin/listUser";
	}
	/* 회원 등록 폼 */
	@GetMapping("/joinUser")
	public String joinUser() {
		return "admin/user/join";
	}
	/* 회원 등록 */
	@PostMapping("/insertUser")
	public String insertUser(MemberDTO dto) {
		Member m = modelMapper.map(dto, Member.class);
		mRepository.save(m);
		return "redirect:/admin/listUser";
	}
	/* 회원 삭제 */
	@PostMapping("/deleteUser")
	public ResponseEntity<Map<String, String>> deleteUser(@RequestParam(name = "userid") String userid) {
	    //만약 Order, Post 등의 테이블에서 userid를 참조하고 있다면, 먼저 자식 데이터를 삭제해야 합니다.
		
		Map<String, String> response = new HashMap<>();
	    
	    // 🔥 회원이 존재하는지 확인
	    if (!mRepository.existsById(userid)) {
	        response.put("message", "fail");
	        response.put("error", "해당 회원을 찾을 수 없습니다.");
	        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
	    }

	    try {
	        mRepository.deleteById(userid);  // ✅ 회원 삭제 실행
	        response.put("message", "success");
	        return ResponseEntity.ok(response); // ✅ 삭제 성공 시 JSON 응답 반환
	    } catch (DataIntegrityViolationException e) {
	        response.put("message", "fail");
	        response.put("error", "연관된 데이터가 있어 삭제할 수 없습니다.");
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
	    } catch (Exception e) {
	        response.put("message", "fail");
	        response.put("error", "서버 오류 발생");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}
	
	/*--------------------------------order--------------------------------------*/
	
	/* 결제 완료, 결제 취소 요청만 */
	@GetMapping("/listOrder")
	public ModelAndView listOrder(ModelAndView mav) {
		List<OrderItem> orderList = oRepository.findByStatusIn(List.of(OrderStatus.PAID, OrderStatus.CANCELING));
		mav.addObject("orderList", orderList);
		mav.addObject("isCheckOrders", true);
		mav.setViewName("admin/order/list");
		return mav;
	}
	
	/* 주문 내역 전체 리스트 */
	@GetMapping("/listAllOrder")
	public ModelAndView listAllOrder(ModelAndView mav) {
		List<OrderItem> orderList = oRepository.findAll();
		mav.addObject("orderList", orderList);
		mav.addObject("isAllOrders", true);
		mav.setViewName("admin/order/list");
		return mav;
	}
	
	/* 주문 취소 승인 */
	@PostMapping("/orderCancel/{orderIdx}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> cancelOrder(@PathVariable(name = "orderIdx") long orderIdx) {
		Map<String, Object> response = new HashMap<>();
		
		OrderItem order = oRepository.findById(orderIdx)
				.orElseThrow(() -> new RuntimeException("주문 정보가 없습니다 : "+orderIdx));
		
		if (order.getStatus().equals(OrderStatus.CANCELING)) {
			order.setStatus(OrderStatus.CANCELED);
			
			for (OrderDetail detail : order.getOrderDetailList()) {
				Product product = pRepository.findById(detail.getProductCode())
						.orElseThrow(() -> new RuntimeException("상품 정보를 찾을 수 없습니다 :" +detail.getProductCode()));
				product.setStock(product.getStock() + detail.getAmount());
				product.setSales(product.getSales() - detail.getAmount());
				pRepository.save(product);
			}
			
			
			oRepository.save(order);
			
			response.put("success", true);
			response.put("message", "주문이 취소되었습니다.");
			return ResponseEntity.ok(response);
		}
		
		response.put("success", false);
		response.put("message", "주문 취소를 승인할 수 없습니다.");
		return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
	}
	
	/* 주문 승인 */
	@PostMapping("/orderConfirm/{orderIdx}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> confirmOrder(@PathVariable(name = "orderIdx") long orderIdx){
		Map<String, Object> response = new HashMap<>();
		
		OrderItem order = oRepository.findById(orderIdx)
				.orElseThrow(() -> new RuntimeException("주문 정보가 없습니다 : "+orderIdx));
		
		if (order.getStatus().equals(OrderStatus.PAID)) {
			order.setStatus(OrderStatus.DELIVERED);
			oRepository.save(order);
			
			response.put("success", true);
			response.put("message", "주문이 승인되었습니다.");
			return ResponseEntity.ok(response);
		}
		response.put("success", false);
		response.put("message", "주문을 승인 할 수 없습니다.");
		return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
	}
	
	/* 배송 완료 삭제 */
	@PostMapping("/deleteAllDeliveredOrders")
	@ResponseBody
	@Transactional	
	public ResponseEntity<Map<String, Object>> deleteDeliveredOrder(){
		/* status == delivered 인 order 테이블 삭제  + 해당하는 orderIdx 인 orderDetail 테이블 삭제 */
		Map<String, Object> response = new HashMap<>();
		
		try {
			List<OrderItem> deliveredOrders = oRepository.findByStatus(OrderStatus.DELIVERED);
		
			if (deliveredOrders.isEmpty()) {
				response.put("success", false);
				response.put("message", "삭제할 주문이 없습니다.");
				return ResponseEntity.ok(response);
			}
			
			List<Long> orderIdxs = new ArrayList<>();
			for (OrderItem order : deliveredOrders) {
				orderIdxs.add(order.getOrderIdx());
			}
			
			/* 자식 테이블(OrderDetail) 선 삭제 */
			odRepository.deleteByOrderIdxIn(orderIdxs);
			/* 부모 테이블(OrderItem) 후 삭제 */
			oRepository.deleteAll(deliveredOrders);
			
			response.put("success", true);
			response.put("message", "모든 배송완료 주문이 삭제되었습니다.");
			return ResponseEntity.ok(response);
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	        response.put("success", false);
	        response.put("message", "배송 완료 주문 삭제중 오류가 발생했습니다.");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}
	
	/* 주문 취소 완료 삭제 */
	@PostMapping("/deleteAllCanceledOrders")
	@ResponseBody
	@Transactional
	public ResponseEntity<Map<String, Object>> deleteAllCanceledOrders() {
		Map<String, Object> response = new HashMap<>();
		
		try {
			List<OrderItem> canceledOrders = oRepository.findByStatus(OrderStatus.CANCELED);
			if (canceledOrders.isEmpty()) {
				response.put("success", false);
				response.put("message", "삭제할 주문이 없습니다.");
				return ResponseEntity.ok(response);
			}
			
			List<Long> orderIdxs = new ArrayList<>();
			for (OrderItem order : canceledOrders) {
				orderIdxs.add(order.getOrderIdx());
			}
			/* 자식 테이블(OrderDetail) 선 삭제*/
			odRepository.deleteByOrderIdxIn(orderIdxs);
			/* 부모 테이블(OrderItem) 후 삭제 */
			oRepository.deleteAll(canceledOrders);
			response.put("success", true);
			response.put("message", "모든 주문취소 주문이 삭제되었습니다.");
			return ResponseEntity.ok(response);
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	        response.put("success", false);
	        response.put("message", "주문 취소 삭제중 오류가 발생했습니다.");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}
	
	
	
	
	
	
	
	
		
	}
	
	
	
	
	
	
	
	
	