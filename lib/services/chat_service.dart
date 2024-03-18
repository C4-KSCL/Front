import 'dart:convert';
import 'dart:io';

import 'package:frontend_matching/models/chat_list.dart';
import 'package:frontend_matching/pages/chatting_list/chatting_list_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/userDataController.dart';

class ChatService {
  static const baseUrl = 'http://15.164.245.62:8000';
  static const rooms = 'rooms';
  static const send = 'send';
  static const chats = 'chats';
  static const delete = 'delete';
  static const events = 'events';

  static String accessToken = UserDataController.to.accessToken;

  static Map<String, String> headers = {
    "Content-type": "application/json",
    "accessToken": accessToken
  };

  //유저의 마지막 채팅들 가져오기 - 채팅방 리스트 구현
  static void getLastChatList() async {
    final url = Uri.parse('$baseUrl/$chats/get-last-chats');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var lastChats = jsonDecode(response.body);
      if (lastChats['lastChats'] != null) {
        for (var lastChat in lastChats['lastChats']) {
          String roomId = lastChat['roomId'];
          String createdAt = lastChat['createdAt'];
          String content = lastChat['content'];
          int notReadCounts=lastChat['notReadCounts'];

          String nickname="";
          String userImage="";
          if(lastChat['room']['joinRoom'].isEmpty){
            nickname = lastChat['room']['addRequest'][0]['receive']['nickname'];
            userImage=lastChat['room']['addRequest'][0]['receive']['userImage'];
          }
          else{
            nickname = lastChat['room']['joinRoom'][0]['user']['nickname'];
            userImage = lastChat['room']['joinRoom'][0]['user']['userImage'];
          }

          var chatList=ChatList(roomId: roomId, nickname: nickname, createdAt: createdAt, content: content, notReadCounts: notReadCounts, userImage: userImage,);

          ChattingListController.to.chattingList.add(chatList);
          print(ChattingListController.to.chattingList.length.toString());
        }
      }
    }
  }

  // 그 방 채팅내용 가져오기
  // 채팅 내역 반환
  static dynamic getRoomChats({required String roomId}) async {
    final url = Uri.parse('$baseUrl/$chats/get-chats/$roomId?page=1&limit=20');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);

    final jsonData = json.decode(response.body);
    final lastChats = jsonData['chats'];
    print(lastChats);

    return lastChats;
  }

  //채팅 방 나가기
  static void leaveRoom({
    required String roomId,
  }) async {
    final url = Uri.parse('$baseUrl/$rooms/leave/$roomId');

    final response = await http.delete(url, headers: headers);

    print(response.statusCode);
    print(response.body);
  }

  //속한 채팅 방들 리스트 가져오기
  static void getRoomList() async {
    final url = Uri.parse('$baseUrl/rooms/get-list/');

    final response = await http.delete(url, headers: headers);

    print(response.statusCode);
    print(response.body);
  }
}
