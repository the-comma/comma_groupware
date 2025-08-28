package com.example.comma_groupware.chat;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ChatRoomUserMapper {

	// 채팅방 User 정보 삽입
	void insertUser(@Param("username") int username, @Param("roomId") long  roomId);

	// 방 존재 여부 확인
	int existChatRoom(@Param("chatTargetId") int chatTargetId, @Param("username") int username);

}
