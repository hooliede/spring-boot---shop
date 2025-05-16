package com.example.sp.dto.util;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@AllArgsConstructor
@ToString
public class ResponseEntityDTO<T> {
	private boolean success;
	private String message;
	private T data;
	
	/* 성공 응답 정적 반환 */
	public static <T> ResponseEntityDTO<T> success(T data, String message) {
		return new ResponseEntityDTO<>(true, message, data);
	}
	/* 실패 응답 정적 반환 */
	public static <T> ResponseEntityDTO<T> error(String message) {
		return new ResponseEntityDTO<>(false, message, null);
	}
}
