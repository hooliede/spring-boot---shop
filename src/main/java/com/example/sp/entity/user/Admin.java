package com.example.sp.entity.user;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class Admin {
	@Id
	private String userid;
	
	private String passwd;
	private String name;
	private String level;
	
}
