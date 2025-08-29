package com.example.comma_groupware.chat;

import java.util.List;
import java.util.Map;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.comma_groupware.dto.ChatMessage;
import com.example.comma_groupware.service.DepartmentService;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class ChatController {

    private final SimpMessagingTemplate template;
    private final ChatService chatService;
    private final ObjectMapper objectMapper;   // 🔸 주입
    private final DepartmentService departmentService;
    private final ChatRoomUserService chatRoomUserService;
    private final ChatRoomService chatRoomService;
    
    
    @MessageMapping("/chat/send") // 클라에서 /pub/chat/send 로 보냄
    public void send(@Payload ChatMessage message) throws Exception {
        log.info("WS IN  : {}", message);
        
        chatService.save(message);
        
        // 필요하면 DB 저장 후 saved로 대체
        // ChatMessage saved = chatService.save(...);

        // 🔸 반드시 JSON 문자열로 변환해서 브로드캐스트
        String json = objectMapper.writeValueAsString(message);
        template.convertAndSend("/sub/room." + message.getChatRoomId(), json);

        log.info("WS OUT : /sub/room.{} {}", message.getChatRoomId(), json);
    }

    @GetMapping("/chat")
    public String chat(Model model, HttpSession session) { 
        List<Map<String,Object>> deptTeamList = departmentService.getDeptTeamList();
        String sessionUsername = (String) session.getAttribute("username");
        int username = Integer.parseInt(sessionUsername);
        
        List<Map<String,Object>> chatRoomList =  chatRoomService.chatRoomList(username);									
        
        
    	
        model.addAttribute("deptTeamList", deptTeamList);
        model.addAttribute("chatRoomList", chatRoomList);
    	
        return "chat2"; 
    	}
    
    @PostMapping("/chat/rooms/one-to-one")
    public String createPersonalRoom(@RequestParam int chatTargetId, HttpSession session) {
    	log.info("값이 넘어옴." + chatTargetId);
    	String sessionUsername = (String) session.getAttribute("username");
    	int username = Integer.parseInt(sessionUsername);
    	long roomId = chatService.createRoom(chatTargetId, username);
    
    	if(roomId == 0) {
    		return "redirect:/chat";
    	}
    		
    	int result = chatRoomUserService.insertUser(roomId, chatTargetId, username);
    	return "redirect:/chat";
    }
    
}
