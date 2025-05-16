package com.example.sp.controller;

import java.security.SecureRandom;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.sp.dto.Member.MemberDTO;
import com.example.sp.dto.Payment.OrderDetailDTO;
import com.example.sp.dto.util.ResponseEntityDTO;
import com.example.sp.entity.board.Board;
import com.example.sp.entity.order.OrderDetail;
import com.example.sp.entity.order.OrderItem;
import com.example.sp.entity.order.OrderStatus;
import com.example.sp.entity.user.Member;
import com.example.sp.repository.cart.OrderDetailRepository;
import com.example.sp.repository.cart.OrderItemRepository;
import com.example.sp.repository.user.MemberRepository;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;

@Controller
@RequestMapping("/member")
public class MemberController {
	/* repository : DB 기능 호출클래스 */
	@Autowired
	MemberRepository memberRepository;

	@Autowired
	ModelMapper modelMapper;
	
	@Autowired
	OrderItemRepository oRepository;
	@Autowired
	OrderDetailRepository odRepository;
	@Autowired
	PasswordEncoder passwordEncoder;
	
	@GetMapping("/login") /* 로그인폼 */
	public String login() {
		return "user/login";
	}
	@GetMapping("/join") /* 회원가입폼 */
	public String join() {
		return "user/join";
	}
	@GetMapping("/findId") /* 아이디찾기 폼 */
	public String findIdForm() {
		return "user/findId";
	}
	@GetMapping("/findPwd")
	public String findPwdForm() {
		return "user/findPwd";
	}
	
	/* 아이디 중복검사 */
	@PostMapping("/check_userid")
	public ResponseEntity<Map<String, String>> check_userid(@RequestParam("userid") String userid) {
		Map<String, String> response = new HashMap<>();
		
		boolean result = memberRepository.existsById(userid);
		
		if (result) {
			response.put("message", "이미 사용중인 아이디입니다.");
		} else {
			response.put("message", "사용 가능한 아이디입니다.");
		}
		
		return ResponseEntity.ok(response);
	}
	
	/* 닉네임 중복검사 */
	@PostMapping("/check_nickname")
	public ResponseEntity<Map<String, String>> check_nickname(@RequestParam("nickname") String nickname) {
		Map<String, String> response = new HashMap<>();
		boolean result = memberRepository.existsByNickname(nickname);
		
		if (result) {
			response.put("message", "이미 존재하는 닉네임입니다.");
		} else {
			response.put("message", "사용 가능한 닉네임입니다.");
		}
		return ResponseEntity.ok(response);
	}
	
	/* 회원가입 */
	@PostMapping("/insert")
	public String insert(MemberDTO dto) {
		/* dto --> entity */
		Member m = modelMapper.map(dto, Member.class);
		
		String encryptedPasswd = passwordEncoder.encode(dto.getPasswd());
		m.setPasswd(encryptedPasswd);
		
		memberRepository.save(m);
		
		return "redirect:/member/login";
	}
	
	/* 로그인 */
	@PostMapping("/login_check")
	public ModelAndView login_check(MemberDTO dto, HttpSession session,
			HttpServletRequest request,
			ModelAndView mav) {
		Optional<Member> result = memberRepository.findByUserid(dto.getUserid());
		
		if (result.isPresent()) {
			 System.out.println("✅ DB에서 찾은 사용자 정보: " + result.get());
			Member m = result.get();
			
			if(!passwordEncoder.matches(dto.getPasswd(), m.getPasswd())) {
				System.out.println("❌ 비밀번호 불일치: " + dto.getPasswd() + " vs " + m.getPasswd());
				mav.setViewName("/user/login");
				mav.addObject("message", "비밀번호가 일치하지 않습니다.");
				return mav;
			} 
			/* 로그인 성공 -> 기존 세션 제거 후 새 세션 생성 */
			session.invalidate();
			session = request.getSession(true);
			
			session.setAttribute("userid", dto.getUserid());
			session.setAttribute("nickName", m.getNickname());
			session.setAttribute("name", m.getName());
			session.setAttribute("level", m.getLevel());
			session.setAttribute("result", m.getName()+"님 환영합니다.");
			mav.setViewName("/main");
		} else {
			mav.setViewName("/user/login");
			mav.addObject("message", "아이디가 존재하지 않습니다.");
		}
		
		return mav;
	}
	
	/* 아이디 찾기 */
	@GetMapping("/findIdCheck")
	public ModelAndView findIdCheck(MemberDTO dto, ModelAndView mav) {
		
		List<Member> memberList = memberRepository.findAllByNameAndPhone(dto.getName(), dto.getPhone());
		
		/* 0 개*/
		if(memberList.size() == 0) {
			mav.addObject("message", "일치하는 아이디가 없습니다.");
			mav.setViewName("/user/findId");
		} else if (memberList.size() == 1) {
			mav.addObject("member", memberList.get(0));//고침
			mav.setViewName("/user/findIdResult");
		} else if (memberList.size() > 1) {
			List<String> maskedIdList = new ArrayList<>();
			for (Member member : memberList) {
				maskedIdList.add(maskId(member.getUserid())); /* 아이디마스킹 */
			}
			mav.addObject("maskedIdList", maskedIdList);
			mav.setViewName("/user/findIdResult");
		}
		
		 
		return mav;
	}
	/* 아이디 마스킹 */
	private String maskId(String userid) {
		if (userid.length() <= 2) {
			return "**";
		}
		int maskLength = userid.length() - 2;
		String mask = "*".repeat(maskLength);
		return userid.substring(0, 1) + mask + userid.substring(userid.length() - 1);
	}
	
	/* 비밀번호 찾기 */
	@GetMapping("/findPwdCheck")
	public ModelAndView findPwdCheck(MemberDTO dto, ModelAndView mav) {
		
		/* 일치하는 정보 없을 때 */
		Optional<Member> result = memberRepository.findById(dto.getUserid());
		if(result.isEmpty()) {
			mav.addObject("message", "일치하는 계정이 없습니다");
			mav.setViewName("/user/findPwd");
		}
		
		/* 임시 비밀번호 생성 */
		String tempPassword = generateTempPassword();
		
		/* 암호화 후 저장 */
		Member member = result.get();
		member.setPasswd(passwordEncoder.encode(tempPassword));
		memberRepository.save(member);
		
		mav.addObject("tempPassword", tempPassword);
		mav.setViewName("/user/findPwdResult");
		return mav;
	}
	
	/* 랜덤한 임시 비밀번호 생성 */
    private String generateTempPassword() {
        String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder();
        
        for (int i = 0; i < 10; i++) { // 10자리 랜덤 비밀번호
            int index = random.nextInt(CHARACTERS.length());
            password.append(CHARACTERS.charAt(index));
        }
        
        return password.toString();
    }
	
	/* 비밀번호 변경 */
	@PostMapping("/changePwd")
	public ResponseEntity<ResponseEntityDTO<?>> changePassword(
			HttpSession session,
			@RequestBody Map<String, String> request
			) {
		String passwd = request.get("passwd");
		String newPasswd = request.get("newPasswd");
		String userid = request.get("userid");
		Member member = memberRepository.findById(userid).orElse(null);
		if (member == null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ResponseEntityDTO.error("사용자 정보를 찾을 수 없습니다."));
		}
		
		/* 1. 기존 비밀번호 검사 */
		if(!passwordEncoder.matches(passwd, member.getPasswd())) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
					.body(ResponseEntityDTO.error("기존 비밀번호가 일치하지 않습니다."));
		}
		
		/* 2. 새 비밀번호 - 기존 비밀번호 */
		if (passwd.equals(newPasswd)) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST)
					.body(ResponseEntityDTO.error("새 비밀번호는 기존 비밀번호와 다르게 설정해야 합니다."));
		}
		
		/* 새 비밀번호 암호화 저장 */
		member.setPasswd(passwordEncoder.encode(newPasswd));
		memberRepository.save(member);
		
		
		return ResponseEntity.ok(ResponseEntityDTO.success(null, "비밀번호가 변경되었습니다."));
		
		
	}
	
	/* 닉네임 변경 */
	@PostMapping("/changeNickname")
	public ResponseEntity<ResponseEntityDTO<?>> changeNickname(
	        HttpSession session,
	        @RequestBody Map<String, String> request
	) {
		String userid = (String) session.getAttribute("userid");
	    String newNickname = request.get("newNickname");

	    Member member = memberRepository.findById(userid).orElse(null);
	    if (member == null) {
	        return ResponseEntity.status(HttpStatus.NOT_FOUND)
	                .body(ResponseEntityDTO.error("사용자 정보를 찾을 수 없습니다.(세션 확인)"+userid));
	    }

	    // 기존 닉네임과 동일한 경우 오류 반환
	    if (member.getNickname().equals(newNickname)) {
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
	                .body(ResponseEntityDTO.error("새 닉네임은 기존 닉네임과 다르게 설정해야 합니다."));
	    }

	    // 닉네임 중복 검사
	    boolean isNicknameExists = memberRepository.existsByNickname(newNickname);
	    if (isNicknameExists) {
	        return ResponseEntity.status(HttpStatus.CONFLICT)
	                .body(ResponseEntityDTO.error("이미 사용 중인 닉네임입니다."));
	    }

	    // 닉네임 변경 후 저장
	    member.setNickname(newNickname);
	    memberRepository.save(member);

	    // 🔹 세션 정보 업데이트 (중요!)
	    session.setAttribute("member", member);

	    return ResponseEntity.ok(ResponseEntityDTO.success(null, "닉네임이 변경되었습니다."));
	}


	
	
	/* 로그아웃 */
	@GetMapping("/logout")
	public String logout(HttpSession session, RedirectAttributes redirectAttribute) {
		session.invalidate();
		/* 일회성 메세지 전송 */
		redirectAttribute.addFlashAttribute("message", "logout");
		return "redirect:/";
	}
	
	
	
	
	/* 마이페이지 폼 */
	@GetMapping("/mypage")
	public ModelAndView mypageForm(HttpSession session, ModelAndView mav) {
		String userid = (String) session.getAttribute("userid");
		
		Member member = memberRepository.findById(userid)
				.orElseThrow(() -> new RuntimeException("존재하지 않는 아이디 입니다 : " +userid));
		
		mav.addObject("member", member);
		mav.setViewName("/user/mypage");
		
		return mav;
		
	}
	
	/* 주문 내역 */
	@GetMapping("/loadOrderList")
	@ResponseBody
	public ModelAndView getOrderList(HttpSession session, ModelAndView mav) {
		String userid = (String) session.getAttribute("userid");
		if (userid == null) {
			return new ModelAndView("redirect:/user/login");
		}
		Member member = memberRepository.findById(userid)
				.orElseThrow(() -> new RuntimeException("사용자 정보가 없습니다."+userid));
		mav.addObject("member", member);
		
		
		List<OrderItem> orderList = oRepository.findByUserid(userid);
		
		
		 // 날짜 포맷 지정
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	    
	    // 주문 목록의 날짜 포맷을 변경하여 새로운 리스트 생성
	    List<Map<String, Object>> formattedOrderList = orderList.stream().map(order -> {
	        Map<String, Object> map = new HashMap<>();
	        map.put("orderIdx", order.getOrderIdx());
	        map.put("userid", order.getUserid());
	        map.put("totalPrice", order.getTotalPrice());
	        map.put("deliveryAddress", order.getDeliveryAddress());
	        map.put("status", order.getStatus());
	        map.put("createdAt", order.getCreatedAt().format(formatter)); // 날짜 포맷 변경
	        
	     // orderDetailList 안의 productCode 및 amount 추출
	        List<Map<String, Object>> productList = order.getOrderDetailList().stream()
	            .map(detail -> {
	                Map<String, Object> productMap = new HashMap<>();
	                productMap.put("productCode", detail.getProductCode());
	                productMap.put("amount", detail.getAmount());
	                return productMap;
	            })
	            .collect(Collectors.toList());

	        // 주문 정보에 상품 목록 추가
	        map.put("products", productList);
	        
	        return map;
	    }).collect(Collectors.toList());
		
		
	    mav.addObject("orders", formattedOrderList);
	    mav.setViewName("include/order/orderList2");
		return mav;
	}
	
	/* 주문 취소 요청 */
	@PostMapping("/requestCancelOrder/{orderIdx}")
	@ResponseBody
	@Transactional
	public ResponseEntity<Map<String, Object>> requestCancelOrder(
			@PathVariable(name = "orderIdx") long orderIdx){
		Map<String, Object> response = new HashMap<>();
		
		OrderItem order = oRepository.findById(orderIdx)
				.orElseThrow(() -> new RuntimeException("주문 정보가 없습니다."+orderIdx));
		
		if (order.getStatus().equals(OrderStatus.PAID)) {
			order.setStatus(OrderStatus.CANCELING);
			oRepository.save(order);
			
			response.put("success", true);
			response.put("message", "주문 취소 요청이 접수되었습니다.");
			response.put("newStatus", order.getStatus().toString());
			
			return ResponseEntity.ok(response);
		}
		
		response.put("success", false);
		response.put("message", "취소 요청을 할 수 없습니다. (이미 배송 중이거나 완료된 주문!)");
		return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
	}
	

	
	
	
	
	
	
	
	
	
}
