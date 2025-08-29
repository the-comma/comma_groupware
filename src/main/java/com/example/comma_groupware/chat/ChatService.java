package com.example.comma_groupware.chat;

import java.util.List;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.comma_groupware.dto.ChatMessage;
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

	public void save(ChatMessage message) { // 메세지 저장
		 chatMapper.save(message);
		
	}


    public List<ChatMessage> getMessages(long roomId, int limit, Long beforeId, Long afterId) {

        if (afterId != null) {
            // afterId 보다 "큰" (더 최신) 메시지 → ASC 로 내려줌
            return chatMapper.findAfter(roomId, afterId, limit);
        }

        if (beforeId != null) {
            // beforeId 보다 "작은" (더 과거) 메시지 → DESC 로 내려줌
            return chatMapper.findBefore(roomId, beforeId, limit);
        }

        // 초기 로드: 최신 N개 → DESC
        return chatMapper.findLatest(roomId, limit);
    }
 
}
