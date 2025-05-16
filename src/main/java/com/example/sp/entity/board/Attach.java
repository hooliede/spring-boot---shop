package com.example.sp.entity.board;


import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@ToString
public class Attach {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long attachId;
	
	private String fileName;
	private String filePath;
	
	@ToString.Exclude
	@ManyToOne(fetch = FetchType.LAZY)//지연 로딩
	//attach랑 board select 쿼리문을 두개로 나눠서 쓰는 거
	@JoinColumn(name = "board_idx")//board에 있는 외래키 idx로 조인한 거 
	private Board board;
	
}
