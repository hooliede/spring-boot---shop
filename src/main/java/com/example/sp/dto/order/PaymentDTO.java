package com.example.sp.dto.order;

import java.util.List;

import lombok.Data;


@Data
public class PaymentDTO {
	private List<String> productCode;
	private List<Integer> amount;
	
	private int totalPrice;
}
