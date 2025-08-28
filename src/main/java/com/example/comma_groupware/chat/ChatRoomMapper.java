package com.example.comma_groupware.chat;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.comma_groupware.dto.ChatRoom;

@Mapper
public interface ChatRoomMapper {

	// 채팅방 생성
	long createRoom(ChatRoom room);

	// 로그인한 사원정보의 참여 채팅방 조회
	List<Map<String, Object>> chatRoomList(int username);

	

}
