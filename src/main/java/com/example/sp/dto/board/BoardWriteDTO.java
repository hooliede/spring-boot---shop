package com.example.sp.dto.board;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BoardWriteDTO {
	private int boardIdx;
	private String title;
	private String contents;
	private String boardType;
	private MultipartFile[] files;
}
