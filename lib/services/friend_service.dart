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
      var sentRequests = jsonDecode(response.body);
      FriendController.to.receivedRequests.clear();

      if (sentRequests['requests'] != null) {
        for (var sentRequest in sentRequests['requests']) {
          int requestId = sentRequest['id'];
          String myMBTI = sentRequest['request']['myMBTI'];
          String myKeyword = sentRequest['request']['myKeyword'];
          String nickname = sentRequest['request']['nickname'];
          String userImage = sentRequest['request']['userImage'];
          String age = sentRequest['request']['age'];
          String gender = sentRequest['request']['gender'];
          String createdAt = sentRequest['room']['createdAt'];
          String chatContent = sentRequest['room']['chatting'][0]['content'];
          String roomId = sentRequest['roomId'];

          var request = Request(
            requestId: requestId,
            myMBTI: myMBTI,
            myKeyword: myKeyword,
            nickname: nickname,
            userImage: userImage,
            age: age,
            gender: gender,
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

  // 받는 json 형식
  // {
  //   "requests": [
  //     {
  //       "id": 6,
  //       "roomId": "1712388914296",
  //       "reqUser": "a@naver.com",
  //       "recUser": "c@naver.com",
  //       "status": "rejected",
  //       "createdAt": "2024-04-06T16:53:46.000Z",
  //       "room": {
  //         "id": "1712388914296",
  //         "name": "1712388914296",
  //         "createdAt": "2024-04-06T16:53:46.000Z",
  //         "publishing": "deleted",
  //         "chatting": [
  //           {"content": "hahaha"}
  //          ]
  //        },
  //       "receive": {
  //         "myMBTI": "ISTP",
  //         "myKeyword": "집순이,헬린이",
  //         "nickname": "c",
  //         "userImage": "https://matchingimage.s3.ap-northeast-2.amazonaws.com/defalut_user.png",
  //         "age": "21",
  //         "gender": "남"
  //        }
  //      }
  //    ]
  // }

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
          String gender = sendedRequest['receive']['gender'];
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
            gender: gender,
            createdAt: createdAt,
            chatContent: chatContent,
            roomId: roomId,
          );

          FriendController.to.sentRequests.add(request);
        }
      }
    }
  }

  //받은 친구 요청 수락
  //받은 친구 요청 확인을 할때 requestId를 저장해놓고 가져와야함
  static Future<void> acceptFriendRequest({
    required String requestId,
  }) async {
    final url = Uri.parse('$baseUrl/$requests/accept');

    String data = '{"requestId" :$requestId}';

    final response = await http.post(url, headers: headers, body: data);

    print(response.statusCode);
    print(response.body);
  }

  //받은 친구 요청 거절
  static Future<void> rejectFriendRequest({
    required String requestId,
  }) async {
    final url = Uri.parse('$baseUrl/$requests/reject');

    String data = '{"requestId" :$requestId}';

    final response = await http.patch(url, headers: headers, body: data);

    print(response.statusCode);
    print(response.body);
  }

  //보낸 친구 요청 삭제
  static Future<void> deleteFriendRequest({
    required String requestId,
  }) async {
    final url = Uri.parse('$baseUrl/$requests/$delete/$requestId');

    final response = await http.delete(url, headers: headers);

    print(response.statusCode);
    print(response.body);
  }

  //친구 리스트 가져오기
  static Future<void> getFriendList() async {
    final url = Uri.parse('$baseUrl/$friends/get-list');

    final response = await http.get(url, headers: headers);

    // 받는 json 형식
    // {
    //     "friends": [
    //       {
    //         "id": 1,
    //         "user1": "a@naver.com",
    //         "user2": "b@naver.com",
    //         "createdAt": "2024-04-06T15:53:49.000Z",
    //         "friend": {
    //           "myMBTI": "ISFJ",
    //           "myKeyword": "집순이,헬린이",
    //           "nickname": "b",
    //           "userImage": "https://matchingimage.s3.ap-northeast-2.amazonaws.com/profile/1712379300363-%EA%B0%95%EC%95%84%EC%A7%80%20%EC%82%AC%EC%A7%84.jpg",
    //           "age": "27",
    //           "gender": "남"
    //          },
    //         "room": null
    //        }
    //     ]
    // }

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var friendsData = jsonDecode(response.body);

      for (var friendData in friendsData['friends']) {
        int id=friendData['id'];
        String? roomId = friendData['room'] ==null ? null : friendData['room']['roomId'];
        String myMBTI = friendData['friend']['myMBTI'];
        String nickname = friendData['friend']['nickname'];
        String myKeyword = friendData['friend']['myKeyword'];
        String age = friendData['friend']['age'];
        String gender = friendData['friend']['gender'];
        String userImage = friendData['friend']['userImage'];

        Friend friend = Friend(
          myMBTI: myMBTI,
          myKeyword: myKeyword,
          nickname: nickname,
          userImage: userImage,
          age: age,
          gender: gender,
          roomId: roomId,
        );

        FriendController.to.friends.add(friend);
      }
    }
  }

  //친구 삭제
  static Future<void> deleteFriend({
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
