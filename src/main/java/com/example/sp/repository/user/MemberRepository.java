package com.example.sp.repository.user;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.sp.entity.user.Member;





/* Member entity에 대한 DB처리 */
/* <테이블명, primary key> */
public interface MemberRepository extends JpaRepository<Member, String>{
	
	/* null일 경우 안전하게 처리 위해 optional<>선언 */
	
	
	/* 아이디로 조회 */
	Optional<Member> findByUserid(String userid);
	/* 로그인 */
	Optional<Member> findByUseridAndPasswd(String userid, String passwd);
	
	boolean existsByNickname(String nickname);
	
	/* 아이디 찾기 */
	List<Member> findAllByNameAndPhone(String name, String phone);
	
	/*admin이 user를 아이디로 검색*/
	List<Member> findByUseridContaining(String userid);
	
	/*admin이 user를 이름으로 검색*/
	List<Member> findByNameContaining(String name);

	
}
