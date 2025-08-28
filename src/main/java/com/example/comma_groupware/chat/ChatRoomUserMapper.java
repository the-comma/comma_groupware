package com.example.comma_groupware.chat;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ChatRoomUserMapper {

	void insertUser(@Param("username") int username, @Param("roomId") long  roomId);

}
