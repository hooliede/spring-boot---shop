package com.example.sp.dto.Member;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class AdminDTO {
	private String userid;
	private String passwd;
	private String name;
	private String level;
}
