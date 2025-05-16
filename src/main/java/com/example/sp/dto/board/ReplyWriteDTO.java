package com.example.sp.dto.board;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class ReplyWriteDTO {
	private int boardIdx;
	private String replyContent;
}
