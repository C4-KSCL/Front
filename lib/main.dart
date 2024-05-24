import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend_matching/controllers/bottomNavigationBar.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/controllers/find_friend_controller.dart';
import 'package:frontend_matching/controllers/infoModifyController.dart';
import 'package:frontend_matching/controllers/keyword_controller.dart';
import 'package:frontend_matching/controllers/service_center_controller.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/controllers/userImageController.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/controllers/userProfileController.dart';
import 'package:frontend_matching/pages/chatting_list/chatting_list_page.dart';
import 'package:frontend_matching/pages/chatting_room/chatting_room_page.dart';
import 'package:frontend_matching/pages/init_page.dart';
import 'package:frontend_matching/pages/login/loginPage.dart';
import 'package:frontend_matching/pages/matching/mainPage.dart';
import 'package:frontend_matching/services/fcm_token_service.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'config.dart';
import 'controllers/friend_controller.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// 앱이 백그라운드 상태에서 FCM메세지를 받았을 때 실행할 로직
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      "Handling a background message: ${message.messageId} ${message.data} ${message.sentTime}");

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

  if(message.data['route']=='chat'){
    String payload =
        message.notification!.title! + ',' + message.data['roomId'];

    await flutterLocalNotificationsPlugin.show(
      0, // 알림 ID
      message.notification!.title, // 알림 제목
      message.notification!.body, // 알림 내용
      platformChannelSpecifics,
      payload: payload,
    );
  } else if(message.data['route']=='friend'){
    await flutterLocalNotificationsPlugin.show(
      0, // 알림 ID
      message.notification!.title, // 알림 제목
      message.notification!.body, // 알림 내용
      platformChannelSpecifics,
      payload: 'friendPage',
    );
  }


}

// 알림 설정
void initializeNotifications() async {
  // Notification plugin 초기화
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),

    /// 안드로이드에서 FCM 클릭시 핸들링 코드
    onDidReceiveNotificationResponse: (NotificationResponse details) async {
      print("페이로드 값 : ${details.payload}");
      // 채팅 관련 알림
      if (details.payload == "friendPage") {
        BottomNavigationBarController.to.selectedIndex.value = 1;
      }
      // 친구 관련 알림
      else {
        List<String> chatData = details.payload!.split(',');
        BottomNavigationBarController.to.selectedIndex.value = 2;
        Get.to(() => ChatRoomPage(
              roomId: chatData[1],
              oppUserName: chatData[0],
              isChatEnabled: true,
            ));
      }
    },
  );

  // Android용 알림 채널 생성
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // 채널 ID
    'High Importance Notifications', // 채널 이름
    description: 'This channel is used for important notifications.', // 채널 설명
    importance: Importance.high, // 중요도
  );

  // 채널을 플러그인에 등록
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

// main 함수
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //.env 파일 불러오기
  await dotenv.load(fileName: ".env");
  AppConfig.load();

  initializeNotifications(); //안드로이드 알림 설정 초기화

  //Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //FCM 백그라운드 알림 받기
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //FCM 포그라운드
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("포그라운드 메세지 수신 : ${message.data}");

    // 채팅 관련 알림
    if (message.data['route'] == "chat") {
      // 채팅 리스트 받아오기
      ChattingListController.getLastChatList();

      String? incomingRoomId = message.data['roomId'];

      // ChattingController의 인스턴스가 등록되어 있는지 확인
      if (Get.isRegistered<ChattingController>()) {
        // 등록된 컨트롤러 사용
        final ChattingController chatRoomController = Get.find();

        // 해당 채팅방에 입장되어있으면 알림 안오게 세팅
        if (chatRoomController.roomId != incomingRoomId) {
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

          String payload =
              message.notification!.title! + ',' + message.data['roomId'];
          print("페이로드 값 : $payload");

          await flutterLocalNotificationsPlugin.show(
              0, // 알림 ID
              message.notification!.title, // 알림 제목
              message.notification!.body, // 알림 내용
              platformChannelSpecifics,
              payload: payload // 알림 눌렀을 때 사용할 데이터
              );
        }
      }
      // ChattingController의 인스턴스가 등록이 안되어 있을때
      else {
        // 친구 관련이나 다른거 등등
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

        String payload =
            message.notification!.title! + ',' + message.data['roomId'];
        print("페이로드 값 : $payload");

        await flutterLocalNotificationsPlugin.show(
          0, // 알림 ID
          message.notification!.title, // 알림 제목
          message.notification!.body, // 알림 내용
          platformChannelSpecifics,
          payload: payload,
        );
      }
    }
    // 다른 알림 관련
    else {
      // 친구 관련이나 다른거 등등
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
        payload: 'friendPage',
      );
    }
  });

  void navigateToChat(RemoteMessage message) {
    // String roomId = message.data['roomId'] ?? 'default_room_id';
    // ChattingController.to.roomId = roomId;
    print("룸 아이디: ${message.data['roomId']}");
    Get.offAllNamed('/chatList');
  }

  void navigateToFriendPage() {
    Get.offAll(const InitPage());
    BottomNavigationBarController.to.selectedIndex.value = 2;
    print("친구 페이지로 기기");
  }

  void handleRouteNavigation(String route, RemoteMessage message) {
    switch (route) {
      case "chat":
        navigateToChat(message);
        break;
      case "friend":
        navigateToFriendPage();
        break;
      default:
        print("라우팅 Route not recognized: $route");
        break;
    }
  }

  /// IOS : 포그라운드 상태일때 푸시알림 클릭시 실행,
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("FCM 클릭: ${message.data}");

    if (message.data.containsKey('route')) {
      handleRouteNavigation(message.data['route'], message);
    } else {
      print("No route specified in the data");
    }
  });

  //한국 시간 설정
  await initializeDateFormatting('ko_KR', null);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
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
        AppConfig.putGetxControllerDependency();
      }),
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
      ],
    ),
  );
}
