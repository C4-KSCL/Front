import 'dart:convert';

import 'package:frontend_matching/models/request.dart';
import 'package:frontend_matching/pages/friend/friend_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/userDataController.dart';
import '../models/friend.dart';

class FriendService {
  static const baseUrl = 'http://15.164.245.62:8000';
  static const rooms = 'rooms';
  static const users = 'users';
  static const create = 'create';
  static const requests = 'requests';
  static const send = 'send';
  static const accept = 'accept';
  static const reject = 'reject';
  static const chats = 'chats';
  static const friends = 'friends';
  static const delete = 'delete';
  static const oppEmail = 'oppEmail';
  static const events = 'events';

  static String accessToken = UserDataController.to.accessToken;

  static Map<String, String> headers = {
    "Content-type": "application/json",
    "accessToken": accessToken
  };

  //친구 요청 보내기
  static void sendFriendRequest({
    required String oppEmail,
    required String content,
  }) async {
    final url = Uri.parse('$baseUrl/$requests/send');

    print(accessToken);

    String data = '{"oppEmail": "$oppEmail", "content":"$content"}';

    final response = await http.post(url, headers: headers, body: data);

    print(response.statusCode);
    print(response.body);
  }

  //받은 친구 요청 확인
  static void getFriendReceivedRequest() async {
    final url = Uri.parse('$baseUrl/$requests/get-received');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var sendedRequests = jsonDecode(response.body);
      FriendController.to.receivedRequests.clear();

      if (sendedRequests['requests'] != null) {
        for (var sendedRequest in sendedRequests['requests']) {
          int requestId = sendedRequest['id'];
          String myMBTI = sendedRequest['request']['myMBTI'];
          String myKeyword = sendedRequest['request']['myKeyword'];
          String nickname = sendedRequest['request']['nickname'];
          String userImage = sendedRequest['request']['userImage'];
          String age = sendedRequest['request']['age'];
          String createdAt = sendedRequest['room']['createdAt'];
          String chatContent = sendedRequest['room']['chatting'][0]['content'];
          String roomId = sendedRequest['roomId'];

          var request = Request(
            requestId: requestId,
            myMBTI: myMBTI,
            myKeyword: myKeyword,
            nickname: nickname,
            userImage: userImage,
            age: age,
            createdAt: createdAt,
            chatContent: chatContent,
            roomId: roomId,
          );

          FriendController.to.receivedRequests.add(request);
        }
      }
    }
  }

  //보낸 친구 요청 확인
  static void getFriendSendedRequest() async {
    final url = Uri.parse('$baseUrl/$requests/get-sended');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var sendedRequests = jsonDecode(response.body);
      if (sendedRequests['requests'] != null) {
        for (var sendedRequest in sendedRequests['requests']) {
          int requestId = sendedRequest['id'];
          String myMBTI = sendedRequest['receive']['myMBTI'];
          String myKeyword = sendedRequest['receive']['myKeyword'];
          String nickname = sendedRequest['receive']['nickname'];
          String userImage = sendedRequest['receive']['userImage'];
          String age = sendedRequest['receive']['age'];
          String createdAt = sendedRequest['room']['createdAt'];
          String chatContent = sendedRequest['room']['chatting'][0]['content'];
          String roomId = sendedRequest['roomId'];

          var request = Request(
            requestId: requestId,
            myMBTI: myMBTI,
            myKeyword: myKeyword,
            nickname: nickname,
            userImage: userImage,
            age: age,
            createdAt: createdAt,
            chatContent: chatContent,
            roomId: roomId,
          );

          FriendController.to.sendedRequests.add(request);
        }
      }
    }
  }

  //받은 친구 요청 수락
  //받은 친구 요청 확인을 할때 requestId를 저장해놓고 가져와야함
  static void acceptFriendRequest({
    required String requestId,
  }) async {
    final url = Uri.parse('$baseUrl/$requests/accept');

    String data = '{"requestId" :$requestId}';

    final response = await http.post(url, headers: headers, body: data);

    print(response.statusCode);
    print(response.body);
  }

  //받은 친구 요청 거절
  static void rejectFriendRequest({
    required String requestId,
  }) async {
    final url = Uri.parse('$baseUrl/$requests/reject');

    String data = '{"requestId" :$requestId}';

    final response = await http.patch(url, headers: headers, body: data);

    print(response.statusCode);
    print(response.body);
  }

  //보낸 친구 요청 삭제
  static void deleteFriendRequest({
    required String requestId,
  }) async {
    final url = Uri.parse('$baseUrl/$requests/$delete/$requestId');

    final response = await http.delete(url, headers: headers);

    print(response.statusCode);
    print(response.body);
  }

  //친구 리스트 가져오기
  static void getFriendList() async {
    final url = Uri.parse('$baseUrl/$friends/get-list');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var friendsData = jsonDecode(response.body);

      for (var friendData in friendsData['friends']) {
        String roomId = friendData['room']['id'];
        String myMBTI = friendData['friend']['myMBTI'];
        String nickname = friendData['friend']['nickname'];
        String myKeyword = friendData['friend']['myKeyword'];
        String age = friendData['friend']['age'];
        String userImage = friendData['friend']['userImage'];

        Friend friend = Friend(myMBTI: myMBTI, myKeyword: myKeyword, nickname: nickname, userImage: userImage, age: age, roomId: roomId);

        FriendController.to.friends.add(friend);
      }
    }
  }

  //친구 삭제
  static void deleteFriend({
    required String oppEmail,
  }) async {
    final url = Uri.parse('$baseUrl/$friends/$delete/$oppEmail');

    final response = await http.get(
      url,
      headers: headers,
    );

    print(response.statusCode);
    print(response.body);
  }
}
