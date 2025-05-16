package com.example.sp.dto.Payment;

import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class PaymentDTO {
	
	private List<OrderDetailDTO> products;
	private int totalPrice;
	private String deliveryAddress;
}
