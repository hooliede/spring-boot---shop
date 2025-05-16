package com.example.sp.repository.board;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.sp.entity.board.Board;
import com.example.sp.entity.board.BoardType;

public interface BoardRepository extends JpaRepository<Board, Integer>{
	/* 제목 검색 */
	List<Board> findByTitleContaining(String keyword);
	Page<Board> findByTitleContaining(String keyword, Pageable pageable);
	/* 내용 검색 */
	List<Board> findByContentsContaining(String keyword);
	Page<Board> findByContentsContaining(String keyword, Pageable pageable);
	/* 제목+내용 검색 */
	List<Board> findByTitleContainingOrContentsContaining(String keyword, String keyword2);
	Page<Board> findByTitleContainingOrContentsContaining(String keyword, String keyword2, Pageable pageable);
	/*작성자로 검색*/
	@Query("SELECT b FROM Board b JOIN b.member m WHERE m.nickname LIKE CONCAT('%', :keyword, '%')")
	Page<Board> findByNickname(@Param("keyword") String keyword, Pageable pageable);
	
	
	/*게시글 타입으로 분류*/
	List<Board> findByBoardType(BoardType boardType);
	Page<Board> findByBoardType(BoardType boardType, Pageable pageable);


}
