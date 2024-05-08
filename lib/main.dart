import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend_matching/controllers/bottomNavigationBar.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/controllers/find_friend_controller.dart';
import 'package:frontend_matching/controllers/infoModifyController.dart';
import 'package:frontend_matching/controllers/keyword_controller.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/controllers/userProfileController.dart';
import 'package:frontend_matching/pages/login/loginPage.dart';
import 'package:frontend_matching/services/fcm_token_service.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'controllers/friend_controller.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 앱이 백그라운드 상태에서 메시지를 받았을 때 실행할 로직
  print("Handling a background message: ${message.messageId} ${message.data} ${message.sentTime}");

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'SOUL MBTI_ID',
    'SOUL MBTI_NAME',
    channelDescription: 'SOUL MBTI_DESC',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // 알림 ID
    message.notification!.title, // 알림 제목
    message.notification!.body, // 알림 내용
    platformChannelSpecifics,
    payload: 'item x',
  );
}

// 안드로이드 알림 설정
void initializeNotifications() {

  // Notification plugin 초기화
  flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );

  // Android용 알림 채널 생성
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // 채널 ID
    'High Importance Notifications', // 채널 이름
    description: 'This channel is used for important notifications.', // 채널 설명
    importance: Importance.high, // 중요도
  );

  // 채널을 플러그인에 등록
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
}

// main 함수
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //.env 파일 불러오기
  await dotenv.load(fileName: ".env");

  initializeNotifications(); //안드로이드 알림 설정 초기화

  //Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //FCM 백그라운드 메세지 받기
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //FCM 포그라운드
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("포그라운드 메세지 수신 : $payloadData");
    if (message.notification != null) {}
  });

  //한국 시간 설정
  await initializeDateFormatting('ko_KR', null);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        popupMenuTheme: PopupMenuThemeData(
          color: greyColor3.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
        ),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(SignupController());
        Get.put(UserDataController());
        Get.put(BottomNavigationBarController());
        Get.put(UserProfileController());
        Get.put(InfoModifyController());
        Get.put(FindFriendController());
        Get.put(FriendController());
        Get.put(ChattingListController());
        Get.put(KeywordController());
      }),
    ),
  );
}
