package com.example.sp.controller;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.sp.dto.board.ReplyWriteDTO;
import com.example.sp.entity.board.Board;
import com.example.sp.entity.board.Reply;
import com.example.sp.entity.user.Member;
import com.example.sp.repository.board.BoardRepository;
import com.example.sp.repository.board.ReplyRepository;
import com.example.sp.repository.user.MemberRepository;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/reply")
public class ReplyController {
	@Autowired
	MemberRepository mRepository;
	@Autowired
	ReplyRepository rRepository;
	@Autowired
	BoardRepository bRepository;
	
	/* 댓글 등록 */
	@PostMapping("/insert")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> replyInsert(@RequestBody ReplyWriteDTO dto, HttpSession session) {
	    Map<String, Object> response = new HashMap<>();

	    try {
	        String userid = (String) session.getAttribute("userid");
	        if (userid == null) {
	            throw new RuntimeException("로그인이 필요합니다.");
	        }

	        Member member = mRepository.findById(userid).orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));
	        Board board = bRepository.findById(dto.getBoardIdx()).orElseThrow(() -> new RuntimeException("게시글을 찾을 수 없습니다."));

	        Reply reply = new Reply();
	        reply.setMember(member);
	        reply.setBoard(board);
	        reply.setReplyContent(dto.getReplyContent());
	        reply.setRegdate(LocalDateTime.now());

	        rRepository.save(reply);

	        response.put("success", true);
	        response.put("message", "댓글이 등록되었습니다.");
	        return ResponseEntity.ok()
	                .contentType(MediaType.APPLICATION_JSON)
	                .body(response);
	    } catch (Exception e) {
	        response.put("success", false);
	        response.put("message", "서버 오류 발생: " + e.getMessage());
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}
	
	/* 댓글 삭제 */
	@PostMapping("/delete/{replyIdx}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteReply(
			@PathVariable(name = "replyIdx") int replyIdx,
			HttpSession session){
		String userid = (String) session.getAttribute("userid");
		if (userid == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
					.body(Map.of("success", "false", "message", "로그인이 필요합니다."));
		}
		
		/* 삭제할 댓글 정보 */
		Reply reply = rRepository.findById(replyIdx)
				.orElseThrow(() -> new RuntimeException("해당 댓글을 찾을 수 없습니다."));
		
		String replyUserid = reply.getMember().getUserid(); /* 댓글 작성자의 userid */
		Member member = mRepository.findById(userid) /* 현재 로그인한 사용자 정보 */
				.orElseThrow(() -> new RuntimeException("사용자 정보를 찾을 수 없습니다 :" +userid));
		
		if (userid.equals(replyUserid) || "ADMIN".equals(member.getLevel())) {
			rRepository.delete(reply);
			return ResponseEntity.ok(Map.of("success", true, "message", "댓글이 삭제되었습니다."));
		}
		return ResponseEntity.status(HttpStatus.FORBIDDEN)
				.body(Map.of("success", false, "message", "댓글 삭제 권한이 없습니다."));
	}
	
	/* 댓글 수정 */
	@PostMapping("/update/{replyIdx}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateReply(
			@PathVariable(name = "replyIdx") int replyIdx,
			@RequestBody Map<String, Object> requestData,
			HttpSession session) {
		String userid = (String) session.getAttribute("userid");
		/* map -> String */
		String replyContent = String.valueOf(requestData.get("replyContent"));
		
		if (userid == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }
		
		/* 수정할 댓글 정보 */
		Reply reply = rRepository.findById(replyIdx)
				.orElseThrow(() -> new RuntimeException("해당 댓글을 찾을 수 없습니다 : "+replyIdx));
		
		/* 댓글 작성자 더블 체크 */
		if (!reply.getMember().getUserid().equals(userid)) {
			 return ResponseEntity.status(HttpStatus.FORBIDDEN)
	                    .body(Map.of("success", false, "message", "댓글 수정 권한이 없습니다."));
		}
		
		/* 댓글 내용 수정 */
		reply.setReplyContent(replyContent);
		reply.setEdited(true); /* 수정 여부 */
		rRepository.save(reply);
		
		return ResponseEntity.ok(Map.of("success", true, "message", "댓글이 수정되었습니다."));
	}
}
