package com.example.comma_groupware.chat;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.comma_groupware.dto.ChatMessage;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
public class ChatRestController {

	private final ChatService chatService;
	private final ChatRoomService chatRoomService;
	
	@GetMapping("/api/chat/rooms/{roomId}/messages")
	public List<ChatMessage> getMessages(@PathVariable Long roomId,
			@RequestParam(required = false) Integer limit,
			@RequestParam(required = false) Long beforeId,
			@RequestParam(required = false) Long afterId)
	{
		log.info("limit"+ limit);
		log.info("roomId"+ roomId);
		log.info("beforeId"+ beforeId);
		log.info("afterId"+ afterId);
		int pageSize = (limit == null ? 50: Math.min(limit, 200));
		return chatService.getMessages(roomId, pageSize, beforeId, afterId);
		
	}
	
	@GetMapping("/api/chat/rooms/summary")
    public List<Map<String,Object>> summaries(HttpSession session) {
        // 세션에서 사용자 아이디 얻는 방식 그대로 재사용
        String sessionUsername = (String) session.getAttribute("username");
        int username = Integer.parseInt(sessionUsername);
        return chatRoomService.chatRoomList(username);
    }
}
	

