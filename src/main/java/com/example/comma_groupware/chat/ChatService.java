package com.example.comma_groupware.chat;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.comma_groupware.dto.ChatRoom;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional
public class ChatService {
	
	private final ChatRoomMapper chatRoomMapper;
	private final ChatMapper chatMapper;
	private final ChatRoomUserMapper chatRoomUserMapper;
	
	
	public long createRoom(int chatTargetId, int username) {
		
		int existChatRoom = chatRoomUserMapper.existChatRoom(chatTargetId, username);
		
		if(existChatRoom >= 1) {
			return 0;
		}
		
		ChatRoom room = new ChatRoom();
		room.setChatRoomType("DIRECT");
		 
		chatRoomMapper.createRoom(room);
		Long roomId =	room.getChatRoomId();
		
		
		log.info("방생성 방번호:"+ roomId);
		

		
		return roomId;
		
	}
 
}
