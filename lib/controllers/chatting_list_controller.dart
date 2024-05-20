import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/chat_list.dart';
import 'package:get/get.dart';

import '../config.dart';

class ChattingListController extends GetxController {
  static ChattingListController get to => Get.find<ChattingListController>();

  static String? baseUrl=AppConfig.baseUrl;

  RxList<ChatList> chattingList = <ChatList>[].obs; //채팅 리스트

  static String accessToken = UserDataController.to.accessToken;

  static Map<String, String> headers = {
    "Content-type": "application/json",
    "accessToken": accessToken
  };

  // 채팅 리스트 비우기
  void resetData() {
    chattingList.clear();
  }

  //유저의 마지막 채팅들 가져오기 - 채팅방 리스트 구현
  static Future<void> getLastChatList() async {
    final url = Uri.parse('$baseUrl/chats/get-last-chats');

    final response = await http.get(url, headers: headers);

    List<ChatList> tempChatList = [];

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
          int friendRequestId = lastChat['room']['addRequest'].isNotEmpty
              ? lastChat['room']['addRequest'][0]['id']
              : -1;
          int notReadCounts = lastChat['notReadCounts'];
          bool isChatEnabled = lastChat['room']['publishing'] == "true";
          bool isReceivedRequest = lastChat['room']['addRequest'].isEmpty
              ? false
              : lastChat['room']['addRequest'][0]['reqUser'] !=
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
            friendRequestId: friendRequestId,
            userImage: userImage,
            isChatEnabled: isChatEnabled,
            isReceivedRequest: isReceivedRequest,
          );

          tempChatList.add(chatList);
        }
      }
      ChattingListController.to.chattingList.assignAll(tempChatList);
    }
  }

  //채팅 방 나가기
  static Future<void> leaveRoom({
    required String roomId,
  }) async {
    final url = Uri.parse('$baseUrl/rooms/leave/$roomId');

    final response = await http.patch(url, headers: headers);

    if(response.statusCode==200){
      print("${response.statusCode} 성공적으로 나가짐");
    } else{
      print("나가기 실패");
      print(response.body);
    }
  }

  /// 채팅방 참가하기
  static Future<void> rejoinRoom({
    required String oppEmail,
  }) async {
    final url = Uri.parse('$baseUrl/rooms/create');

    final body = jsonEncode({"oppEmail": oppEmail}) ;

    final response = await http.patch(url, headers: headers, body: body);

    print(response.statusCode);
    print(response.body);
  }
}
