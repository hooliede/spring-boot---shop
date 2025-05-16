package com.example.sp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.example.sp.entity.board.Board;
import com.example.sp.entity.board.BoardType;
import com.example.sp.repository.board.BoardRepository;


@Controller
public class HomeController {
	@Autowired
	BoardRepository boardRepository;
	
	@GetMapping("/")
	public String main(Model model, @ModelAttribute("message") String message) {
		List<Board> noticeList = boardRepository.findByBoardType(BoardType.NOTICE);
		System.out.println("공지사항 갯수:" + noticeList.size());
		model.addAttribute("welcome", "welcome!");
		model.addAttribute("message", message);
		model.addAttribute("noticeList", noticeList);
		return "main";
	}
	
	@GetMapping("/admin")
	public String admin_main() {
		
		return "admin/admin_login";
	}
	
	@GetMapping("/board")
	public String mainBoard() {
		return "board/main";
	}
	
}
