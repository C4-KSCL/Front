import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/config.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FcmService{
  static String? baseUrl=AppConfig.baseUrl;

  // 알림 설정 관련 권한 물어보기
  static void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    String? fcmToken = await messaging.getToken();
    await initUserFcmTokenTable();
    await uploadUserFcmToken(fcmToken: fcmToken.toString());
    // String? hasRequestedPermission = await AppConfig.storage.read(key: "hasRequestedPermission");
    //
    // if (hasRequestedPermission == null || hasRequestedPermission != 'true') {
    //
    //
    //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //     print('User granted permission');
    //     await AppConfig.storage.write(key: "hasRequestedPermission", value: 'true');
    //
    //   } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    //     print('User granted provisional permission');
    //     await AppConfig.storage.write(key: "hasRequestedPermission", value: 'true'); // Optional: Adjust based on desired behavior
    //   } else {
    //     print('User declined or has not accepted permission');
    //     await AppConfig.storage.write(key: "hasRequestedPermission", value: 'false');
    //   }
    // } else {
    //   print("Permission has already been requested");
    // }
  }
  
  // 유저의 디바이스 Token 정보를 담을 테이블을 만드는 함수
  static Future<void> initUserFcmTokenTable() async {
    final url=Uri.parse("$baseUrl/alarms/init-user-token");

    var response = await UserDataController.postRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도");
      print(response.body);
      response = await UserDataController.postRequestWithRefreshToken(
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

        response = await UserDataController.postRequest(
          url: url,
          accessToken: UserDataController.to.accessToken,
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
    if(response.statusCode==201){
      print("테이블 생성");
    }
  }

  // 유저의 디바이스 Token 정보를 저장
  static Future<void> uploadUserFcmToken({required String fcmToken}) async{
    final url=Uri.parse("$baseUrl/alarms/upload-fcm-token");

    final body=jsonEncode({'fcmToken':fcmToken});

    var response = await UserDataController.patchRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
      body: body,
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도");
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
    if(response.statusCode==200){
      AppConfig.storage.write(key:"tokenValue", value: fcmToken);
      print("$fcmToken 등록 완료");
    }
  }

  // 유저의 디바이스 Token 정보를 삭제
  static Future<void> deleteUserFcmToken() async{
    final url=Uri.parse("$baseUrl/alarms/delete-fcm-token");

    var response = await UserDataController.patchRequest(
      url: url,
      accessToken: UserDataController.to.accessToken,
    );

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도");
      print(response.body);
      response = await UserDataController.patchRequestWithRefreshToken(
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

        response = await UserDataController.patchRequest(
          url: url,
          accessToken: UserDataController.to.accessToken,
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
    if(response.statusCode==200){
      print("fcm 토큰 삭제 완료");
    }
  }
}