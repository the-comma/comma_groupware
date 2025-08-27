package com.example.comma_groupware.chat;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.comma_groupware.dto.ChatMessage;
import com.fasterxml.jackson.databind.ObjectMapper;

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

    @MessageMapping("/chat/send") // 클라에서 /pub/chat/send 로 보냄
    public void send(@Payload ChatMessage message) throws Exception {
        log.info("WS IN  : {}", message);

        // 필요하면 DB 저장 후 saved로 대체
        // ChatMessage saved = chatService.save(...);

        // 🔸 반드시 JSON 문자열로 변환해서 브로드캐스트
        String json = objectMapper.writeValueAsString(message);
        template.convertAndSend("/sub/room." + message.getChatRoomId(), json);

        log.info("WS OUT : /sub/room.{} {}", message.getChatRoomId(), json);
    }

    @GetMapping("/chat")
    public String chat() { return "chat2"; }
}
