package com.example.comma_groupware.chat;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.data.domain.Pageable;

import com.example.comma_groupware.dto.ChatMessage;

@Mapper
public interface ChatMapper {

	// 채팅메세지 저장
	void save(ChatMessage message);
	
	
    List<ChatMessage> findLatest(@Param("roomId") long roomId,
	            @Param("limit") int limit);
	
	List<ChatMessage> findBefore(@Param("roomId") long roomId,
	            @Param("beforeId") long beforeId,
	            @Param("limit") int limit);
	
	List<ChatMessage> findAfter(@Param("roomId") long roomId,
	           @Param("afterId") long afterId,
	           @Param("limit") int limit);
}
