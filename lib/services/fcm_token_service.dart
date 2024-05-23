import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/config.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FcmService{
  static String? baseUrl=AppConfig.baseUrl;
  static String accessToken = UserDataController.to.accessToken;

  static Map<String, String> headers = {
    "Content-type": "application/json",
    "accessToken": accessToken
  };

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

    final response = await http.post(url, headers: headers);

    print(response.statusCode);
    print(response.body);
    if(response.statusCode==201){
      print("테이블 생성");
    }
  }

  // 유저의 디바이스 Token 정보를 저장
  static Future<void> uploadUserFcmToken({required String fcmToken}) async{
    final url=Uri.parse("$baseUrl/alarms/upload-fcm-token");

    final body=jsonEncode({'fcmToken':fcmToken});

    final response = await http.patch(url, headers: headers,body: body);

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

    final response = await http.patch(url, headers: headers);

    if(response.statusCode==200){
      print("fcm 토큰 삭제 완료");
    }
  }
}