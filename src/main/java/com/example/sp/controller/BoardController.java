package com.example.sp.controller;

import java.io.File;
import java.io.IOException;
import org.springframework.ui.Model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.sp.dto.board.BoardWriteDTO;
import com.example.sp.entity.board.Attach;
import com.example.sp.entity.board.Board;
import com.example.sp.entity.board.BoardType;
import com.example.sp.entity.board.Reply;
import com.example.sp.entity.user.Member;
import com.example.sp.repository.board.AttachRepository;
import com.example.sp.repository.board.BoardRepository;
import com.example.sp.repository.user.MemberRepository;

/*import ch.qos.logback.core.model.Model;*/
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board")
public class BoardController {
	
	@Autowired
	BoardRepository boardRepository;
	@Autowired
	AttachRepository attachRepository;
	@Autowired
	MemberRepository mRepository;
	
	@GetMapping("/notice/notice1")
	public String showNotice1() {
		return "include/board/notice/notice1";
	}
	@GetMapping("/notice/notice2")
	public String showNotice2() {
		return "include/board/notice/notice2";
	}
	@GetMapping("/notice/notice3")
	public String showNotice3() {
		return "include/board/notice/notice3";
	}
	@GetMapping("/notice/notice4")
	public String showNotice4() {
		return "include/board/notice/notice4";
	}
	@GetMapping("/notice/notice5")
	public String showNotice5() {
		return "include/board/notice/notice5";
	}
	
	//공지사항이 이제 main.jsp에 noticeList로 받아서 뜨게 해주는 
	@GetMapping("/notice/list")
	public String showNoticeList(Model model) {
	    List<Board> noticeList = boardRepository.findByBoardType(BoardType.NOTICE);
	    model.addAttribute("noticeList", noticeList);
	    return "include/main/3_floor/noticeHeader";
	}

	/* 전체리스트 */
	@RequestMapping("/listAll")
	public ModelAndView listAllBoard(
			@RequestParam(name = "page", defaultValue = "0") int page,
			@RequestParam(name = "size", defaultValue = "10") int size,
			ModelAndView mav) {
		
		Pageable pageable = PageRequest.of(page, size, Sort.by("boardIdx").descending());
		Page<Board> boardPage = boardRepository.findAll(pageable);
		
		
		/* 날짜 포맷팅 */
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	    for (Board board : boardPage.getContent()) {
	        board.setFormattedRegdate(board.getRegdate().format(formatter)); // 변환 적용
	    }
	    
	    int totalPages = boardPage.getTotalPages();
	    if (totalPages == 0) {
	    	totalPages = 1;
	    }
	    
	    mav.addObject("boardPage", boardPage);
	    mav.addObject("currentPage", page);
	    mav.addObject("totalPages", totalPages);
	    mav.addObject("pageSize", size);
		mav.addObject("boardList", boardPage.getContent());
		mav.setViewName("board/boardMain");
		return mav;
	}
	
	@GetMapping("/boardType")
	public ModelAndView typeList(ModelAndView mav,
			@RequestParam(name = "type") String type,
			@RequestParam(name = "page", defaultValue = "0") int page,
			@RequestParam(name = "size", defaultValue = "10") int size) {
		
		BoardType boardType = BoardType.valueOf(type);
		Pageable pageable = PageRequest.of(page, size, Sort.by("boardIdx").descending());
		/* enum 타입 따라 데이터 조회 */
		Page<Board> boardPage = boardRepository.findByBoardType(boardType, pageable);
		
		/* 날짜 포맷팅 */
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-M-dd HH:mm:ss");
		for (Board board : boardPage.getContent()) {
			board.setFormattedRegdate(board.getRegdate().format(formatter));
		}
		/* totalPages 초기값 설정 */
		int totalPages = boardPage.getTotalPages();
		if (totalPages == 0) {
			totalPages = 1;
		}
		
		mav.addObject("boardPage", boardPage);
		mav.addObject("currentPage", page);
		mav.addObject("totalPages", totalPages);
		mav.addObject("pageSize", size);
		mav.addObject("boardList", boardPage.getContent());
		
		mav.setViewName("board/boardMain");
		return mav;
	}
	
	/* 입력 폼 */
	@GetMapping("/writeBoard")
	public String writeBoardForm() {
		return "board/write";
	}
	
	/* 게시글 등록 */
	@PostMapping("/insertBoard")
	public ResponseEntity<?> insertBoard(HttpSession session,
			@ModelAttribute BoardWriteDTO dto) {
		String userid = (String) session.getAttribute("userid");
		
		Member member = mRepository.findById(userid)
				.orElseThrow(() -> new RuntimeException("사용자 정보를 찾을 수 없습니다 :" +userid));
		
		Board board = new Board();
		board.setMember(member);
		try {
			board.setBoardType(BoardType.valueOf(dto.getBoardType().toUpperCase()));
		} catch (IllegalArgumentException e) {
			return ResponseEntity.badRequest().body(Map.of("error", "잘못된 게시판 유형입니다: " +dto.getBoardType()));
		}
		board.setTitle(dto.getTitle());
		board.setContents(dto.getContents());
		board.setRegdate(LocalDateTime.now());
		boardRepository.save(board);
		
		
		/* 파일 업로드 처리 */
		List<Attach> attachList = new ArrayList<>();
		
		if (dto.getFiles() != null && dto.getFiles().length > 0) {
	        for (MultipartFile file : dto.getFiles()) {
	            if (!file.isEmpty()) {
	                try {
	                    // ✅ 파일 저장 디렉토리
	                    String uploadDir = "C:/upload/board/";
	                    File uploadDirectory = new File(uploadDir);
	                    if (!uploadDirectory.exists()) {
	                        uploadDirectory.mkdirs(); // 디렉토리 생성
	                    }

	                    // ✅ 파일명 생성 및 저장
	                    String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
	                    File targetFile = new File(uploadDir + fileName);
	                    file.transferTo(targetFile);

	                    // ✅ BoardImage 엔티티 생성 후 리스트에 추가
	                    Attach attach = new Attach();
	                    attach.setFileName(fileName);
	                    attach.setFilePath("/board/" + fileName);
	                    attach.setBoard(board);
	                    attachRepository.save(attach);
	                   
	                } catch (IOException e) {
	                	return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	                            .body(Map.of("error", "파일 업로드 중 오류 발생: " + e.getMessage()));
	                }
	            }
	        }
	    }
		
		/* boardRepository.save(board); */
		
		return ResponseEntity.ok(Map.of(
				"message", "게시글이 성공적으로 등록되었습니다.",
				"redirectUrl", "/board/listAll"));
		
	}
	
	/* 상세보기 */
	@GetMapping("/detail")
	public ModelAndView detailBoard(@RequestParam(name="boardIdx") int boardIdx,
			ModelAndView mav,
			HttpSession session) {
		Board board = boardRepository.findById(boardIdx)
				.orElseThrow(() -> new RuntimeException("게시글 정보를 찾을 수 없습니다 :"+boardIdx));
		
		
		/* 조회수 증가(중복 방지) */
		String sessionKey = "Viewed_"+boardIdx;
		if (session.getAttribute(sessionKey) == null) {
			board.setHit(board.getHit()+1);
			boardRepository.save(board);
			session.setAttribute(sessionKey, true); /* 세션에 기록 */
		}
		List<Reply> replyList = board.getReplyList();
		List<Attach> attachList = board.getAttachList();
		if (attachList == null) {
	        attachList = new ArrayList<>();
	    }

		/* 날짜 포맷팅 */
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	    board.setFormattedRegdate(board.getRegdate().format(formatter)); // 변환 적용
	    
		board.setContents(board.getContents().replace("\n", "<br>"));
		
		mav.addObject("board", board);
		mav.addObject("replyList", replyList);
		mav.addObject("attachList", attachList);
		
		mav.setViewName("board/detail");
		
		return mav;
	}
	
	/* 게시글 수정 폼 */
	@GetMapping("/edit/{boardIdx}")
	public ModelAndView editBoardForm(@PathVariable(name="boardIdx") int boardIdx,
			ModelAndView mav, HttpSession session) {
		String userid = (String) session.getAttribute("userid");
		
		Board board = boardRepository.findById(boardIdx)
				.orElseThrow(() -> new RuntimeException("게시글을 찾을 수 없습니다 :" +boardIdx));
		
		/* 본인 확인 더블 체크 */
		if(!board.getMember().getUserid().equals(userid)) {
			throw new RuntimeException("게시글 수정 권한이 없습니다.");
		}
		
		mav.addObject("board", board);
		mav.setViewName("board/edit");
		return mav;
	}
	
	/* 게시글 수정 */
	@PostMapping("/updateBoard")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateBoard(
			@RequestBody BoardWriteDTO dto,
			HttpSession session)  {
		Map<String, Object> response = new HashMap<>();
		String userid = (String) session.getAttribute("userid");
		
		if (userid == null) {
			response.put("success", false);
			response.put("message", "로그인이 필요합니다.");
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
		}
		
		Board board = boardRepository.findById(dto.getBoardIdx())
				.orElseThrow(() -> new RuntimeException("게시글을 찾을 수 없습니다 :" +dto.getBoardIdx()));
		if(!board.getMember().getUserid().equals(userid)) {
			response.put("success", false);
			response.put("message", "게시글 수정 권한이 없습니다.");
			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
		}
		
		board.setTitle(dto.getTitle());
		board.setContents(dto.getContents());
		boardRepository.save(board);
		
		response.put("success", true);
		response.put("message", "게시글이 수정되었습니다.");
		return ResponseEntity.ok(response);
		
	}
	
	/* 게시글 검색 */
	@GetMapping("/search")
	public ModelAndView searchBoard(
	        @RequestParam(name = "searchOption") String searchOption,
	        @RequestParam(name = "keyword") String keyword,
	        @RequestParam(name = "page", defaultValue = "0") int page,
	        @RequestParam(name = "size", defaultValue = "10") int size,
	        ModelAndView mav) {

	    Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "regdate"));
	    Page<Board> boardPage;

	    switch (searchOption) {
	        case "title":
	            boardPage = boardRepository.findByTitleContaining(keyword, pageable);
	            break;
	        case "contents":
	            boardPage = boardRepository.findByContentsContaining(keyword, pageable);
	            break;
	        case "titleAndContents":
	            boardPage = boardRepository.findByTitleContainingOrContentsContaining(keyword, keyword, pageable);
	            break;
	        case "nickname":
	        	boardPage = boardRepository.findByNickname(keyword, pageable);
	        	break;
	        default:
	            boardPage = boardRepository.findAll(pageable);
	            break;
	    }

	    // 날짜 포맷팅
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	    boardPage.forEach(board -> board.setFormattedRegdate(board.getRegdate().format(formatter)));
	    
	    int totalPages = boardPage.getTotalPages();
	    
	    if (totalPages == 0) {
	    	totalPages = 1;
	    }
	    
	    mav.addObject("boardList", boardPage.getContent()); // 현재 페이지의 데이터
	    mav.addObject("currentPage", page);
	    mav.addObject("totalPages", totalPages);
	    mav.addObject("pageSize", size);
	    mav.addObject("searchOption", searchOption);
	    mav.addObject("keyword", keyword);

	    mav.setViewName("board/boardMain");
	    return mav;
	}
	
	/* 게시글 삭제 */
	@PostMapping("/delete/{boardIdx}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteBoard(
	        @PathVariable(name = "boardIdx") int boardIdx,
	        HttpSession session) {

	    Map<String, Object> response = new HashMap<>();
	    String userid = (String) session.getAttribute("userid");

	    if (userid == null) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
	                .body(Map.of("success", false, "message", "로그인이 필요합니다."));
	    }

	    /* 게시글 정보 */
	    Board board = boardRepository.findById(boardIdx)
	            .orElse(null);
	    if (board == null) {
	        return ResponseEntity.status(HttpStatus.NOT_FOUND)
	                .body(Map.of("success", false, "message", "게시글을 찾을 수 없습니다."));
	    }

	    /* 현재 로그인한 사용자 정보 */
	    Member member = mRepository.findById(userid)
	            .orElse(null);
	    if (member == null) {
	        return ResponseEntity.status(HttpStatus.NOT_FOUND)
	                .body(Map.of("success", false, "message", "사용자 정보를 찾을 수 없습니다."));
	    }

	    /* 본인 또는 관리자만 삭제 가능 */
	    if (!userid.equals(board.getMember().getUserid()) && !"ADMIN".equals(member.getLevel())) {
	        return ResponseEntity.status(HttpStatus.FORBIDDEN)
	                .body(Map.of("success", false, "message", "게시글 삭제 권한이 없습니다."));
	    }

	    boardRepository.delete(board);
	    response.put("success", true);
	    response.put("message", "게시글이 삭제되었습니다.");
	    return ResponseEntity.ok(response);
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
