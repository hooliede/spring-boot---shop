package com.example.sp.repository.cart;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.sp.entity.order.Cart;
import com.example.sp.entity.product.Product;
import com.example.sp.entity.user.Member;



public interface CartRepository extends JpaRepository<Cart, Long>{
	
	/* member(userid) 엔티티와 product(productCode) 엔티티로 장바구니 객체 보기 */
	Cart findByMemberAndProduct(Member member, Product product);
	
	/* member 엔티티와 product엔티티 리스트로 장바구니 리스트 보기*/
	List<Cart> findByMemberAndProductIn(Member member, List<Product> products);
	
	/* member 엔티티로 장바구니 리스트 보기 */
	List<Cart> findAllByMember(Member member);
	
	
	/* userid와 productcodeList에 매칭된 레코드 삭제 */
	void deleteByMember_UseridAndProduct_ProductCodeIn(String userid, List<String> productCodes);

	
	
	
}
