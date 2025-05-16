package com.example.sp.entity.user;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.annotations.ColumnDefault;

import com.example.sp.entity.board.Board;
import com.example.sp.entity.board.Reply;
import com.example.sp.entity.order.Cart;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PrePersist;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


@Getter
@Setter
@NoArgsConstructor
@Entity
public class Member {
	/* 계정 */
	@Id
	private String userid;
	
	private String passwd;
	private String name;
	private String nickname;
	
	/* 레벨 */
	@ColumnDefault("'USER'")
	private String level;
	
	/* 주소 */
	private String mainAddress;
	private String subAddress;
	
	private String phone;
	private String email;
	
	/* cascade = CascadeType.ALL:    회원이 삭제되면 관련된 장바구니 항목도 자동 삭제됨 */
	/* orphanRemoval = true:   회원이 장바구니에서 항목을 제거하면, 해당 항목도 삭제됨 */
	@OneToMany(mappedBy = "member", cascade = CascadeType.ALL, orphanRemoval = true)
	private List<Cart> cartItems = new ArrayList<>();
	
	@ToString.Exclude
	@OneToMany(mappedBy = "member")
	List<Board> boardList = new ArrayList<>();
	
	@ToString.Exclude
	@OneToMany(mappedBy = "member")
	List<Reply> replyList = new ArrayList<>();
	
	
	public Member(String userid) {
		this.userid = userid;
	}
	
	/* 저장전 호출 (초기화or유효성 검사)*/
	@PrePersist
	public void prePersist() {
		level = level == null || level.isEmpty() ? "USER" : level;
	}
}
