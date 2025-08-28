package com.example.comma_groupware.chat;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional
public class ChatRoomUserService {
	
	private final ChatRoomUserMapper chatRoomUserMapper;

	public int insertUser(long roomId, int chatTargetId, int username) {
	
		chatRoomUserMapper.insertUser(username, roomId); 
		chatRoomUserMapper.insertUser(chatTargetId, roomId); 
		
		log.info("톡 참가자 완료");
		
		return 1;
	}
	
	
	
}
