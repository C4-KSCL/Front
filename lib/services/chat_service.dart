import 'dart:convert';
import 'dart:io';

import 'package:frontend_matching/models/chat_list.dart';
import 'package:frontend_matching/pages/chat_room/socket_controller.dart';
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
  static Future<void> getLastChatList() async {
    final url = Uri.parse('$baseUrl/$chats/get-last-chats');

    final response = await http.get(url, headers: headers);

    List<ChatList> chatLists = [];

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var lastChats = jsonDecode(response.body);
      if (lastChats['lastChats'] != null) {
        for (var lastChat in lastChats['lastChats']) {
          String roomId = lastChat['roomId'];
          String createdAt = lastChat['createdAt'];
          String content = lastChat['content'];
          int notReadCounts = lastChat['notReadCounts'];

          String nickname = "";
          String userImage = "";
          if (lastChat['room']['joinRoom'].isEmpty) {
            nickname = lastChat['room']['addRequest'][0]['receive']['nickname'];
            userImage =
                lastChat['room']['addRequest'][0]['receive']['userImage'];
          } else {
            nickname = lastChat['room']['joinRoom'][0]['user']['nickname'];
            userImage = lastChat['room']['joinRoom'][0]['user']['userImage'];
          }

          var chatList = ChatList(
            roomId: roomId,
            nickname: nickname,
            createdAt: createdAt,
            content: content,
            notReadCounts: notReadCounts,
            userImage: userImage,
          );

          chatLists.add(chatList);
        }
      }
      ChattingListController.to.chattingList.assignAll(chatLists);
    }
  }

  // 그 방 채팅내용 가져오기
  // 채팅 내역 반환
  static Future<dynamic> getRoomChats({required String roomId}) async {
    final url = Uri.parse('$baseUrl/$chats/get-chats/$roomId?page=1&limit=20');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);

    final jsonData = json.decode(response.body);
    final lastChats = jsonData['chats'];
    print(lastChats);

    return lastChats;
  }

  //채팅 방 삭제하기
  static Future<void> deleteRoom({
    required String roomId,
  }) async {
    final url = Uri.parse('$baseUrl/$rooms/leave/$roomId');

    final response = await http.delete(url, headers: headers);

    print(response.statusCode);
    print(response.body);
  }

  //속한 채팅 방들 리스트 가져오기
  static Future<void> getRoomList() async {
    final url = Uri.parse('$baseUrl/$rooms/get-list/');

    final response = await http.delete(url, headers: headers);

    print(response.statusCode);
    print(response.body);
  }

  // bigCategory 가져오기
  static Future<void> getBigCategories() async {
    final url = Uri.parse('$baseUrl/$chats/get-big/');

    final response = await http.get(url, headers: headers);

    print(response.body);

    final jsonData = json.decode(response.body);
    final bigCategories = jsonData['categories'];

    for (String bigCategory in bigCategories) {
      SocketController.to.bigCategories.add(bigCategory);
    }
  }

  // smallCategory 가져오기
  static Future<void> getSmallCategories({required String bigCategoryName,}) async {
    final url = Uri.parse('$baseUrl/$events/get-small/$bigCategoryName');

    final response = await http.get(url, headers: headers);

    print(response.body);
  }

  // 퀴즈 정보 불러오기
  static Future<void> getQuizInfo({required String quizId,}) async {
    final url = Uri.parse('$baseUrl/$events/get-event-page/$quizId');

    final response = await http.get(url, headers: headers);

    print(response.body);
  }

  // 퀴즈 답변 하기
  static Future<void> updateQuizInfo({required String quizId,required String quizAnswer,}) async {
    final url = Uri.parse('$baseUrl/$events/update-event-answer/$quizId');

    String data ='{"content":"$quizAnswer"}';

    final response = await http.patch(url, headers: headers,body: data);

    print(response.body);
  }

}
