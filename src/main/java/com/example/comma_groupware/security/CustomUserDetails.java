package com.example.comma_groupware.security;

import java.util.ArrayList;
import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.example.comma_groupware.dto.Employee;

import lombok.Data;

@Data
public class CustomUserDetails implements UserDetails{
	private final Employee employee;
	
	public CustomUserDetails(Employee employee) {
		this.employee = employee;
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		Collection<GrantedAuthority> roleList = new ArrayList<>();
		GrantedAuthority grantedAuthority = new GrantedAuthority() {
			
			@Override
			public String getAuthority() {
				return employee.getRole();
			}
		}; 
		
		roleList.add(grantedAuthority);
		return roleList;
	}

	@Override
	public String getPassword() {
		return employee.getPassword();
	}

	@Override
	public String getUsername() {
		return employee.getUsername();
	}

}
