package com.example.comma_groupware.service;


import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import com.example.comma_groupware.util.OtpCode;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.time.Duration;
import java.time.Instant;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

import javax.crypto.SecretKey;

@Service
public class JwtEmailOtpService {

	  private final StringRedisTemplate redis;
	  private final Key hs256Key;

	  public JwtEmailOtpService(StringRedisTemplate redis,
	                            @Value("${app.email-otp.secret}") String secret) {
	    this.redis = redis;
	    this.hs256Key = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
	  }
	  
	  private String codeKey(String jti) {
		  return "otp:code:" + jti; 
	  }
	  
	  public record IssueResult(String token, long ttlSeconds, String jti, long expEpochSec, String code) {
		  
	  }
	  
	  public IssueResult issue(String email, String purpose, long ttlSeconds) {
		String jti = UUID.randomUUID().toString();
		String code = OtpCode.sixDigits();
		long exp = Instant.now().getEpochSecond() + ttlSeconds;
		
		redis.opsForValue().set(codeKey(jti), code, Duration.ofSeconds(ttlSeconds));
		  
		String token =  Jwts.builder()
				.subject(email)
				.claims(Map.of("purpose", purpose, "jti", jti))
				.expiration(Date.from(Instant.ofEpochSecond(exp)))
				.signWith(hs256Key)
				.compact();
		
		return new IssueResult(token, ttlSeconds, jti, exp, code);
	  }
	  
	  public boolean verify(String token, String submittedCode) {
		   	var payload = Jwts.parser().verifyWith((SecretKey) hs256Key).build()
		   	.parseSignedClaims(token).getPayload();
		   	
		   	String jti = payload.get("jti", String.class);
		   	
		   	String expected = redis.opsForValue().get(codeKey(jti));
		   	if (expected == null) return false;
		   	
		   	String code =  submittedCode.replaceAll("\\D", "");
		   	if (!expected.equals(code)) return false;
		   	
		   	// 1회용: 성공 시 즉시 삭제
		   	redis.delete(codeKey(jti));
		   	return true;
	  }
	  
}
