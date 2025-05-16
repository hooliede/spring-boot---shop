package com.example.sp.dto.Payment;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class OrderDetailDTO {
	private String productCode;
	private int amount;
	private int price;
}
