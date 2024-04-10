import 'dart:convert';
import 'dart:io';

import 'package:frontend_matching/models/big_category.dart';
import 'package:frontend_matching/models/chat_list.dart';
import 'package:frontend_matching/models/small_category.dart';
import 'package:frontend_matching/pages/chat_room/socket_controller.dart';
import 'package:frontend_matching/pages/chatting_list/chatting_list_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/userDataController.dart';
import '../models/chat.dart';

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

    // 받는 json 형식
    //   {
    //     "lastChats": [
    //       {
    //         "id": 57,
    //         "roomId": "1712559680697",
    //         "nickName": "b",
    //         "userEmail": "b@naver.com",
    //         "createdAt": "2024-04-08T20:07:18.000Z",
    //         "content": "hohohoho",
    //         "readCount": 1,
    //         "type": "text",
    //         "room": {
    //         "id": "1712559680697",
    //         "name": "1712559680697",
    //         "createdAt": "2024-04-08T16:01:21.000Z",
    //         "publishing": "true",
    //         "joinRoom": [
    //           {
    //             "join": true,
    //             "user": {
    //               "email": "c@naver.com",
    //               "nickname": "c",
    //               "userImage": "https://matchingimage.s3.ap-northeast-2.amazonaws.com/defalut_user.png",
    //               "gender": "여"
    //             }
    //           }
    //         ],
    //         "addRequest": [],
    //         "joinCount": 2
    //         },
    //         "notReadCounts": 1
    //       },
    //     {
    //       //삭제된 유저
    //       "id": 14,
    //       "roomId": "1712386390259",
    //       "nickName": null,
    //       "userEmail": null,
    //       "createdAt": "2024-04-07T19:24:24.000Z",
    //       "content": "a@naver.com님이 방을 떠났습니다.",
    //       "readCount": 1,
    //       "type": "text",
    //       "room": {
    //         "id": "1712386390259",
    //         "name": "1712386390259",
    //         "createdAt": "2024-04-06T15:53:10.000Z",
    //         "publishing": "true",
    //         "joinRoom": [],
    //         "addRequest": [],
    //         "joinCount": 1
    //         },
    //       "notReadCounts": 3
    //     }
    //   ]
    // }

    if (response.statusCode == 200) {
      var lastChats = jsonDecode(response.body);
      if (lastChats['lastChats'] != null) {
        for (var lastChat in lastChats['lastChats']) {
          String roomId = lastChat['roomId'];
          String userEmail = lastChat['userEmail'] ??= "삭제된 유저";
          String createdAt = lastChat['createdAt'];
          String content = lastChat['content'];
          String type = lastChat['type'];
          int notReadCounts = lastChat['notReadCounts'];
          bool isChatEnabled = lastChat['room']['publishing'] == "true";
          //
          bool isReceivedRequest = lastChat['room']['addRequest'].isEmpty ? false : lastChat['room']['addRequest'][0]
                  ['reqUser'] !=
              UserDataController.to.user.value!.email;

          String nickname = "";
          String userImage = "";
          if (lastChat['room']['joinRoom'].isNotEmpty) {
            nickname = lastChat['room']['joinRoom'][0]['user']['nickname'];
            userImage = lastChat['room']['joinRoom'][0]['user']['userImage'];
          } else if (lastChat['room']['joinRoom'].isEmpty &&
              lastChat['room']['addRequest'].isEmpty) {
            nickname = "삭제된 유저";
            userImage =
                "https://matchingimage.s3.ap-northeast-2.amazonaws.com/defalut_user.png";
          }

          var chatList = ChatList(
            roomId: roomId,
            userEmail: userEmail,
            nickname: nickname,
            createdAt: createdAt,
            content: content,
            type: type,
            notReadCounts: notReadCounts,
            userImage: userImage,
            isChatEnabled: isChatEnabled,
            isReceivedRequest: isReceivedRequest,
          );

          chatLists.add(chatList);
        }
      }
      ChattingListController.to.chattingList.assignAll(chatLists);
    }
  }

  // 그 방 채팅내용 가져오기
  // 채팅 내역 반환
  static Future<void> getRoomChats({required String roomId}) async {
    final url = Uri.parse('$baseUrl/$chats/get-chats/$roomId?page=1&limit=20');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);

    final jsonData = json.decode(response.body);
    SocketController.to.chats.value= jsonData['chats'].map((data)=>Chat.fromJson(data)).toList();
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
    final url = Uri.parse('$baseUrl/$events/get-big/');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);

    final jsonData = json.decode(response.body);
    SocketController.to.bigCategories = jsonData['categories']
        .map((data) => BigCategory.fromJson(data))
        .toList();
  }

  // smallCategory 가져오기
  static Future<void> getSmallCategories({
    required String bigCategoryName,
  }) async {
    final url = Uri.parse('$baseUrl/$events/get-small/$bigCategoryName');

    final response = await http.get(url, headers: headers);

    print(response.body);

    final jsonData = json.decode(response.body);
    SocketController.to.smallCategories = jsonData['categories']
        .map((data) => SmallCategory.fromJson(data))
        .toList();
  }

  // 퀴즈 정보 불러오기
  static Future<void> getQuizInfo({
    required String quizId,
  }) async {
    final url = Uri.parse('$baseUrl/$events/get-event-page/$quizId');

    final response = await http.get(url, headers: headers);

    print(response.body);
  }

  // 퀴즈 답변 하기
  static Future<void> updateQuizInfo({
    required String quizId,
    required String quizAnswer,
  }) async {
    final url = Uri.parse('$baseUrl/$events/update-event-answer/$quizId');

    String data = '{"content":"$quizAnswer"}';

    final response = await http.patch(url, headers: headers, body: data);

    print(response.body);
  }
}
