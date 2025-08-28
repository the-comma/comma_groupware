package com.example.comma_groupware.chat;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatRoomService {
	
	private final ChatRoomMapper chatRoomMapper;
	
	public List<Map<String,Object>> chatRoomList(int username) { //
		return chatRoomMapper.chatRoomList(username);
		
	}

}

