package com.example.comma_groupware.util;

import java.security.SecureRandom;

import lombok.Data;

@Data
public class OtpCode {

	private static final SecureRandom rnd  = new SecureRandom();
	
	private OtpCode() {
		
	}
	
	public static String sixDigits() {
		return String.format( "%06d", rnd.nextInt(1_000_000)); // 000000~999999
	}
	
}


