package com.example.sp.dto.Member;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberDTO {
	private String userid;
	private String passwd;
	private String nickname;
	private String name;
	private String phone;
	private String level;
	private String zipcode;
	private String mainAddress;
	private String subAddress;
	private String email;
}
