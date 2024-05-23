import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/friend.dart';
import 'package:frontend_matching/models/request.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:frontend_matching/models/userImage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class FriendController extends GetxController {
  static FriendController get to => Get.find();

  static String? baseUrl = AppConfig.baseUrl;

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

  void resetData() {
    friends.clear();
    sentRequests.clear();
    receivedRequests.clear();
    blockedFriends.clear();
  }

  //친구 요청 보내기
  static Future<void> sendFriendRequest({
    required String oppEmail,
    required String content,
  }) async {
    final url = Uri.parse('$baseUrl/$requests/send');

    final body = json.encode({"oppEmail": oppEmail, "content": content});

    var response = await UserDataController.postRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
      body: body,
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도");
      print(response.body);
      response = await UserDataController.postRequestWithRefreshToken(
        url: url,
        accessToken: UserDataController.to.accessToken,
        refreshToken: UserDataController.to.refreshToken,
        body: body,
      );

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신 후 요청
        print("새로운 토큰을 받아서 갱신 및 요청");
        print(response.body);

        final newTokens = jsonDecode(response.body);
        UserDataController.to
            .updateTokens(newTokens['accessToken'], newTokens['refreshToken']);

        response = await UserDataController.postRequest(
          url: url,
          accessToken: UserDataController.to.accessToken,
          body: body,
        );
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('리프레시 토큰 만료, 재로그인');
        print(response.body);
        Get.snackbar('실패', '로그인이 필요합니다.');
        UserDataController.to.logout();
        return;
      }
    }

    // 이미 친구인 경우, 받은 요청이 있을 경우, 보낸 요청이 있을 경우
    if (response.statusCode == 400) {
      var errMsg = jsonDecode(response.body);
      // 이미 친구인 경우
      if (errMsg['msg'] == "already friend : request") {
        Get.snackbar("알림", "등록된 친구입니다.");
      }
      // 받은 요청이거나 보낸 요청이 있을 경우
      else if (errMsg['msg']['error_msg'] == "already exist : request") {
        // 보낸 요청이 있을 경우
        String requestId = errMsg['msg']['requestId'];
        if (errMsg['msg']['reqUser'] ==
            UserDataController.to.user.value!.email) {
          // 보낸 요청이 있다고 알려주기
          Get.snackbar("알림", "보낸 요청이 있습니다.");
        }
        // 받은 요청이 있을 경우 요청을 수락
        else {
          await acceptFriendRequest(requestId: requestId);
        }
      }
    }
    // 삭제된 유저일 경우
    // else if (response.statusCode == 404) {
    //   Get.snackbar("알림", "삭제된 사용자입니다.");
    // }

    print(response.statusCode);
    print(response.body);
  }

  /// 받은 친구 요청 리스트 받아오기
  static Future<void> getFriendReceivedRequest() async {
    final url = Uri.parse('$baseUrl/$requests/get-received');
    List<Request> tempReceivedRequests = [];

    var response = await UserDataController.getRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("401 RefreshToken을 사용하여 AccessToken 갱신 시도");
      print(response.body);
      response = await UserDataController.getRequestWithRefreshToken(
        url: url,
        accessToken: UserDataController.to.accessToken,
        refreshToken: UserDataController.to.refreshToken,
      );

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신 후 요청
        print("새로운 토큰을 받아서 갱신 및 요청");
        print(response.body);

        final newTokens = jsonDecode(response.body);
        UserDataController.to
            .updateTokens(newTokens['accessToken'], newTokens['refreshToken']);

        response = await UserDataController.getRequest(
          url: url,
          accessToken: newTokens['accessToken'],
        );
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('리프레시 토큰 만료, 재로그인');
        print(response.body);
        Get.snackbar('실패', '로그인이 필요합니다.');
        UserDataController.to.logout();
        return;
      }
    }

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

  /// 보낸 친구 요청 리스트 받아오기
  static Future<void> getFriendSentRequest() async {
    final url = Uri.parse('$baseUrl/$requests/get-sended');
    List<Request> tempSentRequests = [];

    var response = await UserDataController.getRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("401 RefreshToken을 사용하여 AccessToken 갱신 시도");
      print(response.body);
      response = await UserDataController.getRequestWithRefreshToken(
        url: url,
        accessToken: UserDataController.to.accessToken,
        refreshToken: UserDataController.to.refreshToken,
      );

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신 후 요청
        print("새로운 토큰을 받아서 갱신 및 요청");
        print(response.body);

        final newTokens = jsonDecode(response.body);
        UserDataController.to
            .updateTokens(newTokens['accessToken'], newTokens['refreshToken']);

        response = await UserDataController.getRequest(
          url: url,
          accessToken: newTokens['accessToken'],
        );
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('리프레시 토큰 만료, 재로그인');
        print(response.body);
        Get.snackbar('실패', '로그인이 필요합니다.');
        UserDataController.to.logout();
        return;
      }
    }

    print(response.statusCode);
    print(response.body);

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

  /// 받은 친구 요청 수락
  static Future<void> acceptFriendRequest({
    required String requestId,
  }) async {
    final url = Uri.parse('$baseUrl/$requests/accept');

    final body = jsonEncode({"requestId": requestId});

    var response = await UserDataController.postRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
      body: body,
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도");
      print(response.body);
      response = await UserDataController.postRequestWithRefreshToken(
        url: url,
        accessToken: UserDataController.to.accessToken,
        refreshToken: UserDataController.to.refreshToken,
        body: body,
      );

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신 후 요청
        print("새로운 토큰을 받아서 갱신 및 요청");
        print(response.body);

        final newTokens = jsonDecode(response.body);
        UserDataController.to
            .updateTokens(newTokens['accessToken'], newTokens['refreshToken']);

        response = await UserDataController.postRequest(
          url: url,
          accessToken: UserDataController.to.accessToken,
          body: body,
        );
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('리프레시 토큰 만료, 재로그인');
        print(response.body);
        Get.snackbar('실패', '로그인이 필요합니다.');
        UserDataController.to.logout();
        return;
      }
    }

    print(response.statusCode);
    print(response.body);
  }

  //받은 친구 요청 거절
  static Future<void> rejectFriendRequest({
    required String requestId,
  }) async {
    final url = Uri.parse('$baseUrl/$requests/reject');

    final body = jsonEncode({"requestId": requestId});

    var response = await UserDataController.patchRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
      body: body,
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("401 RefreshToken을 사용하여 AccessToken 갱신 시도");
      print(response.body);
      response = await UserDataController.patchRequestWithRefreshToken(
        url: url,
        accessToken: UserDataController.to.accessToken,
        refreshToken: UserDataController.to.refreshToken,
        body: body,
      );

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신 후 요청
        print("새로운 토큰을 받아서 갱신 및 요청");
        print(response.body);

        final newTokens = jsonDecode(response.body);
        UserDataController.to
            .updateTokens(newTokens['accessToken'], newTokens['refreshToken']);

        response = await UserDataController.patchRequest(
          url: url,
          accessToken: newTokens['accessToken'],
          body: body,
        );
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('리프레시 토큰 만료, 재로그인');
        print(response.body);
        Get.snackbar('실패', '로그인이 필요합니다.');
        UserDataController.to.logout();
        return;
      }
    }

    print(response.statusCode);
    print(response.body);
  }

  /// 보낸 친구 요청 삭제
  static Future<void> deleteFriendRequest({
    required String requestId,
  }) async {
    final url = Uri.parse('$baseUrl/$requests/$delete/$requestId');

    var response = await UserDataController.deleteRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("401 RefreshToken을 사용하여 AccessToken 갱신 시도");
      print(response.body);
      response = await UserDataController.deleteRequestWithRefreshToken(
        url: url,
        accessToken: UserDataController.to.accessToken,
        refreshToken: UserDataController.to.refreshToken,
      );

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신 후 요청
        print("새로운 토큰을 받아서 갱신 및 요청");
        print(response.body);

        final newTokens = jsonDecode(response.body);
        UserDataController.to
            .updateTokens(newTokens['accessToken'], newTokens['refreshToken']);

        response = await UserDataController.deleteRequest(
          url: url,
          accessToken: newTokens['accessToken'],
        );
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('리프레시 토큰 만료, 재로그인');
        print(response.body);
        Get.snackbar('실패', '로그인이 필요합니다.');
        UserDataController.to.logout();
        return;
      }
    }

    print(response.statusCode);
    print(response.body);
  }

  /// 친구 리스트 받아오기
  static Future<void> getFriendList() async {
    final url = Uri.parse('$baseUrl/friends/get-list');
    List<Friend> tempFriendList = [];

    var response = await UserDataController.getRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("401 RefreshToken을 사용하여 AccessToken 갱신 시도");
      print(response.body);
      response = await UserDataController.getRequestWithRefreshToken(
        url: url,
        accessToken: UserDataController.to.accessToken,
        refreshToken: UserDataController.to.refreshToken,
      );

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신 후 요청
        print("새로운 토큰을 받아서 갱신 및 요청");
        print(response.body);

        final newTokens = jsonDecode(response.body);
        UserDataController.to
            .updateTokens(newTokens['accessToken'], newTokens['refreshToken']);

        response = await UserDataController.getRequest(
          url: url,
          accessToken: newTokens['accessToken'],
        );
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('리프레시 토큰 만료, 재로그인');
        print(response.body);
        Get.snackbar('실패', '로그인이 필요합니다.');
        UserDataController.to.logout();
        return;
      }
    }

    print(response.statusCode);
    print(response.body);

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
        bool isJoinRoom = friendData['room']['join'];
        print(isJoinRoom);

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
          isJoinRoom: isJoinRoom,
        );

        tempFriendList.add(friend);
      }
      FriendController.to.friends.assignAll(tempFriendList);
    }
  }

  /// 친구 삭제
  static Future<void> deleteFriend({
    required String oppEmail,
  }) async {
    final url = Uri.parse('$baseUrl/friends/$delete/$oppEmail');

    var response = await UserDataController.getRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("401 RefreshToken을 사용하여 AccessToken 갱신 시도");
      print(response.body);
      response = await UserDataController.getRequestWithRefreshToken(
        url: url,
        accessToken: UserDataController.to.accessToken,
        refreshToken: UserDataController.to.refreshToken,
      );

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신 후 요청
        print("새로운 토큰을 받아서 갱신 및 요청");
        print(response.body);

        final newTokens = jsonDecode(response.body);
        UserDataController.to
            .updateTokens(newTokens['accessToken'], newTokens['refreshToken']);

        response = await UserDataController.getRequest(
          url: url,
          accessToken: newTokens['accessToken'],
        );
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('리프레시 토큰 만료, 재로그인');
        print(response.body);
        Get.snackbar('실패', '로그인이 필요합니다.');
        UserDataController.to.logout();
        return;
      }
    }

    print(response.statusCode);
    print(response.body);
  }

  /// 친구 차단
  static Future<void> blockFriend({
    required String oppEmail,
  }) async {
    final url = Uri.parse('$baseUrl/friends/blocking');

    final body = jsonEncode({"oppEmail": oppEmail});

    final response = await UserDataController.patchRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
      body: body,
    );

    print(response.statusCode);
    print(response.body);
  }

  /// 친구 차단 해제
  static Future<void> unblockFriend({
    required String oppEmail,
  }) async {
    final url = Uri.parse('$baseUrl/friends/unblocking');

    final body = jsonEncode({"oppEmail": oppEmail});

    final response = await UserDataController.patchRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
      body: body,
    );

    print(response.statusCode);
    print(response.body);
  }

  /// 차단한 친구 리스트 불러오기
  static Future<void> getBlockedFriendList() async {
    final url = Uri.parse('$baseUrl/friends/get-blocking-friend');
    List<Friend> tempBlockedFriendList = [];

    var response = await UserDataController.getRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("401 RefreshToken을 사용하여 AccessToken 갱신 시도");
      print(response.body);
      response = await UserDataController.getRequestWithRefreshToken(
        url: url,
        accessToken: UserDataController.to.accessToken,
        refreshToken: UserDataController.to.refreshToken,
      );

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신 후 요청
        print("새로운 토큰을 받아서 갱신 및 요청");
        print(response.body);

        final newTokens = jsonDecode(response.body);
        UserDataController.to
            .updateTokens(newTokens['accessToken'], newTokens['refreshToken']);

        response = await UserDataController.getRequest(
          url: url,
          accessToken: newTokens['accessToken'],
        );
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('리프레시 토큰 만료, 재로그인');
        print(response.body);
        Get.snackbar('실패', '로그인이 필요합니다.');
        UserDataController.to.logout();
        return;
      }
    }

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
        bool isJoinRoom = friendData['room']['join'];

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
          isJoinRoom: isJoinRoom,
        );

        tempBlockedFriendList.add(friend);
      }
      FriendController.to.blockedFriends.assignAll(tempBlockedFriendList);
    }
  }

  /// 친구 정보(유저객체 + 이미지) 받아오기 - 프로필 페이지
  static Future<void> getFriendData({
    required String friendEmail,
  }) async {
    final url = Uri.parse('$baseUrl/findfriend/getimage');

    final body = jsonEncode({"friendEmail": friendEmail});

    var response = await UserDataController.postRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
      body: body,
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도");
      print(response.body);
      response = await UserDataController.postRequestWithRefreshToken(
        url: url,
        accessToken: UserDataController.to.accessToken,
        refreshToken: UserDataController.to.refreshToken,
        body: body,
      );

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신 후 요청
        print("새로운 토큰을 받아서 갱신 및 요청");
        print(response.body);

        final newTokens = jsonDecode(response.body);
        UserDataController.to
            .updateTokens(newTokens['accessToken'], newTokens['refreshToken']);

        response = await UserDataController.postRequest(
          url: url,
          accessToken: UserDataController.to.accessToken,
          body: body,
        );
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('리프레시 토큰 만료, 재로그인');
        print(response.body);
        Get.snackbar('실패', '로그인이 필요합니다.');
        UserDataController.to.logout();
        return;
      }
    }

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      FriendController.to.friendData.value = User.fromJson(jsonData['user']);
      FriendController.to.friendImageData = RxList<UserImage>.from(
          jsonData['images'].map((data) => UserImage.fromJson(data)).toList());
    }
  }
}
