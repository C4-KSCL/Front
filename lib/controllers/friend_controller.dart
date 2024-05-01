import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/friend.dart';
import 'package:frontend_matching/models/request.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:frontend_matching/models/userImage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FriendController extends GetxController {
  static FriendController get to => Get.find();

  static late final String? baseUrl;

  @override
  void onInit() async {
    super.onInit();
    baseUrl = dotenv.env['SERVER_URL'];
  }

  Rx<int> pageNumber = 0.obs;
  RxList<Friend> friends = RxList<Friend>(); // 친구 리스트
  RxList<Request> sentRequests = RxList<Request>(); // 보낸 요청 리스트
  RxList<Request> receivedRequests = RxList<Request>(); // 받은 요청 리스트
  RxList<Friend> blockedFriends = RxList<Friend>(); // 차단된 친구 리스트

  Rxn<User> friendData = Rxn<User>(null); // 친구 정보
  RxList<UserImage> friendImageData = RxList<UserImage>(); // 친구 이미지 담는 파일

  static const requests = 'requests';
  static const send = 'send';
  static const accept = 'accept';
  static const reject = 'reject';
  static const delete = 'delete';

  static String accessToken = UserDataController.to.accessToken;

  static Map<String, String> headers = {
    "Content-type": "application/json",
    "accessToken": accessToken
  };

  //친구 요청 보내기
  static Future<void> sendFriendRequest({
    required String oppEmail,
    required String content,
  }) async {
    final url = Uri.parse('$baseUrl/$requests/send');

    String data = '{"oppEmail": "$oppEmail", "content":"$content"}';

    final response = await http.post(url, headers: headers, body: data);

    // 이미 친구인 경우, 받은 요청이 있을 경우, 보낸 요청이 있을 경우
    if (response.statusCode == 400) {
      var errMsg = jsonDecode(response.body);
      // 이미 친구인 경우
      if (errMsg['msg'] == "already friend : request") {
      }
      // 받은 요청이거나 보낸 요청이 있을 경우
      else if (errMsg['msg']['error_msg'] == "already exist : request") {
        // 보낸 요청이 있을 경우
        String requestId = errMsg['msg']['requestId'];
        if (errMsg['msg']['reqUser'] ==
            UserDataController.to.user.value!.email) {
          // 보낸 요청이 있다고 알려주기
          print("보낸 요청 있음");
        }
        // 받은 요청이 있을 경우 요청을 수락
        else {
          await acceptFriendRequest(requestId: requestId);
        }
      }
    } // 삭제된 유저일 경우
    else if (response.statusCode == 404) {
      // 삭제된 유저라고 알려주기
    }

    print(response.statusCode);
    print(response.body);
  }

  //받은 친구 요청 확인
  static Future<void> getFriendReceivedRequest() async {
    final url = Uri.parse('$baseUrl/$requests/get-received');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);

    List<Request> tempReceivedRequests = [];

    if (response.statusCode == 200) {
      var receivedRequests = jsonDecode(response.body);

      if (receivedRequests['requests'] != null) {
        for (var receivedRequest in receivedRequests['requests']) {
          int requestId = receivedRequest['id'];
          String userEmail = receivedRequest['reqUser'];
          String myMBTI = receivedRequest['request']['myMBTI'];
          String myKeyword = receivedRequest['request']['myKeyword'];
          String nickname = receivedRequest['request']['nickname'];
          String userImage = receivedRequest['request']['userImage'];
          String age = receivedRequest['request']['age'];
          String gender = receivedRequest['request']['gender'];
          String createdAt = receivedRequest['room']['createdAt'];
          String roomId = receivedRequest['roomId'];

          var request = Request(
            requestId: requestId,
            userEmail: userEmail,
            myMBTI: myMBTI,
            myKeyword: myKeyword,
            nickname: nickname,
            userImage: userImage,
            age: age,
            gender: gender,
            createdAt: createdAt,
            roomId: roomId,
          );

          tempReceivedRequests.add(request);
        }
      }
      FriendController.to.receivedRequests.assignAll(tempReceivedRequests);
    }
  }

  //보낸 친구 요청 확인
  static Future<void> getFriendSentRequest() async {
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
    //       "updatedAt":null
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

    List<Request> tempSentRequests = [];

    if (response.statusCode == 200) {
      var sentRequests = jsonDecode(response.body);
      if (sentRequests['requests'] != null) {
        for (var sentRequest in sentRequests['requests']) {
          int requestId = sentRequest['id'];
          String userEmail = sentRequest['recUser'];
          String myMBTI = sentRequest['receive']['myMBTI'];
          String myKeyword = sentRequest['receive']['myKeyword'];
          String nickname = sentRequest['receive']['nickname'];
          String userImage = sentRequest['receive']['userImage'];
          String age = sentRequest['receive']['age'];
          String gender = sentRequest['receive']['gender'];
          String createdAt = sentRequest['room']['createdAt'];
          String roomId = sentRequest['roomId'];

          var request = Request(
            requestId: requestId,
            userEmail: userEmail,
            myMBTI: myMBTI,
            myKeyword: myKeyword,
            nickname: nickname,
            userImage: userImage,
            age: age,
            gender: gender,
            createdAt: createdAt,
            roomId: roomId,
          );

          tempSentRequests.add(request);
        }
      }
      FriendController.to.sentRequests.assignAll(tempSentRequests);
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
    final url = Uri.parse('$baseUrl/friends/get-list');

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
    //         "room": "1712735768037"
    //        }
    //     ]
    // }

    print(response.statusCode);
    print(response.body);

    List<Friend> tempFriendList = [];

    if (response.statusCode == 200) {
      var friendsData = jsonDecode(response.body);

      for (var friendData in friendsData['friends']) {
        int id = friendData['id'];
        String userEmail = friendData['userEmail'];
        String oppEmail = friendData['oppEmail'];
        String? roomId =
            friendData['room'] == null ? null : friendData['room']['roomId'];
        String myMBTI = friendData['friend']['myMBTI'];
        String nickname = friendData['friend']['nickname'];
        String myKeyword = friendData['friend']['myKeyword'];
        String age = friendData['friend']['age'];
        String gender = friendData['friend']['gender'];
        String userImage = friendData['friend']['userImage'];

        Friend friend = Friend(
          id: id,
          userEmail: userEmail,
          oppEmail: oppEmail,
          myMBTI: myMBTI,
          myKeyword: myKeyword,
          nickname: nickname,
          userImage: userImage,
          age: age,
          gender: gender,
          roomId: roomId,
        );

        tempFriendList.add(friend);
      }
      FriendController.to.friends.assignAll(tempFriendList);
    }
  }

  //친구 삭제
  static Future<void> deleteFriend({
    required String oppEmail,
  }) async {
    final url = Uri.parse('$baseUrl/friends/$delete/$oppEmail');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);
  }

  // 친구 차단
  static Future<void> blockFriend({
    required String oppEmail,
  }) async {
    final url = Uri.parse('$baseUrl/friends/blocking');

    String data = '{"oppEmail" :"$oppEmail"}';
    print(data);

    final response = await http.patch(url, headers: headers, body: data);

    print(response.statusCode);
    print(response.body);
  }

  // 친구 차단 해제
  static Future<void> unblockFriend({
    required String oppEmail,
  }) async {
    final url = Uri.parse('$baseUrl/friends/unblocking');

    String data = '{"oppEmail" :"$oppEmail"}';

    final response = await http.patch(url, headers: headers, body: data);

    print(response.statusCode);
    print(response.body);
  }

  // 차단한 친구 리스트 불러오기
  static Future<void> getBlockedFriendList() async {
    final url = Uri.parse('$baseUrl/friends/get-blocking-friend');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);

    FriendController.to.blockedFriends.clear(); //초기화

    if (response.statusCode == 200) {
      var blockedFriendsData = jsonDecode(response.body);

      for (var friendData in blockedFriendsData) {
        int id = friendData['id'];
        String userEmail = friendData['userEmail'];
        String oppEmail = friendData['oppEmail'];
        String? roomId =
            friendData['room'] == null ? null : friendData['room']['roomId'];
        String myMBTI = friendData['friend']['myMBTI'];
        String nickname = friendData['friend']['nickname'];
        String myKeyword = friendData['friend']['myKeyword'];
        String age = friendData['friend']['age'];
        String gender = friendData['friend']['gender'];
        String userImage = friendData['friend']['userImage'];

        Friend friend = Friend(
          id: id,
          userEmail: userEmail,
          oppEmail: oppEmail,
          myMBTI: myMBTI,
          myKeyword: myKeyword,
          nickname: nickname,
          userImage: userImage,
          age: age,
          gender: gender,
          roomId: roomId,
        );

        FriendController.to.blockedFriends.add(friend);
      }
    }
  }

  // 친구 정보 받아오기 - 프로필 페이지
  static Future<void> getFriendData({
    required String friendEmail,
  }) async {
    final url = Uri.parse('$baseUrl/findfriend/getimage');

    String data = '{"friendEmail" :"$friendEmail"}';

    final response = await http.post(url, headers: headers, body: data);

    // 받는 데이터
    //   {
    //     "user": {
    //       "userNumber": 7,
    //       "email": "ch@naver.com",
    //       "password": "ch",
    //       "nickname": "chovy",
    //       "phoneNumber": "1234",
    //       "age": "12",
    //       "gender": "여",
    //       "myMBTI": "INFP",
    //       "friendMBTI": "INFP",
    //       "myKeyword": "먹보",
    //       "friendKeyword": "우동추d",
    //       "userCreated": "2024-04-08 14:54:06",
    //       "suspend": 0,
    //       "manager": 0,
    //       "friendGender": "여",
    //       "friendMaxAge": "100",
    //       "friendMinAge": "1",
    //       "requestTime": "2024-04-15 20:07:48",
    //       "userImage": "https://matchingimage.s3.ap-northeast-2.amazonaws.com/profile/1712729048538-chovy3.jpg",
    //       "userImageKey": "profile/1712729048538-chovy3.jpg",
    //       "deleteTime": null
    //     },
    //   "images": [
    //     {
    //       "imageNumber": 7,
    //       "userNumber": 7,
    //       "imagePath": "https://matchingimage.s3.ap-northeast-2.amazonaws.com/image/1712555678093-chovy1.jpg",
    //       "imageCreated": "2024-04-08 14:54:38",
    //       "imageKey": "image/1712555678093-chovy1.jpg"
    //     },
    //     {
    //       "imageNumber": 8,
    //       "userNumber": 7,
    //       "imagePath": "https://matchingimage.s3.ap-northeast-2.amazonaws.com/image/1712555678094-chovy2.jpg",
    //       "imageCreated": "2024-04-08 14:54:38",
    //       "imageKey": "image/1712555678094-chovy2.jpg"
    //     },
    //     {
    //       "imageNumber": 9,
    //       "userNumber": 7,
    //       "imagePath": "https://matchingimage.s3.ap-northeast-2.amazonaws.com/image/1712555678125-chovy3.jpg",
    //       "imageCreated": "2024-04-08 14:54:38",
    //       "imageKey": "image/1712555678125-chovy3.jpg"
    //     }
    //   ]
    // }

    print(response.statusCode);
    print(response.body);

    var jsonData = jsonDecode(response.body);

    FriendController.to.friendData.value = User.fromJson(jsonData['user']);
    FriendController.to.friendImageData = RxList<UserImage>.from(
        jsonData['images'].map((data) => UserImage.fromJson(data)).toList());
  }
}
