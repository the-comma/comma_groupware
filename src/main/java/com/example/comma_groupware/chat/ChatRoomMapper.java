package com.example.comma_groupware.chat;

import org.apache.ibatis.annotations.Mapper;

import com.example.comma_groupware.dto.ChatRoom;

@Mapper
public interface ChatRoomMapper {

	long createRoom(ChatRoom room);

}
