import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend_matching/controllers/bottomNavigationBar.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/controllers/fcm_controller.dart';
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

/// Andoroid : 백그라운드일때, FCM을 받았을 때 실행
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      "백그라운드 때 받은 FCM 내용: ${message.notification} ${message.data} ${message.sentTime}");

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

  if (message.data['route'] == 'chat') {
    String payload =
        message.notification!.title! + ',' + message.data['roomId'];

    await flutterLocalNotificationsPlugin.show(
      0, // 알림 ID
      message.notification!.title, // 알림 제목
      message.notification!.body, // 알림 내용
      platformChannelSpecifics,
      payload: payload,
    );
  } else if (message.data['route'] == 'friend') {
    await flutterLocalNotificationsPlugin.show(
      0, // 알림 ID
      message.notification!.title, // 알림 제목
      message.notification!.body, // 알림 내용
      platformChannelSpecifics,
      payload: 'friendPage',
    );
  }
}

// main 함수
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //.env 파일 불러오기
  await dotenv.load(fileName: ".env");
  AppConfig.load();

  /// Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// FCM : 종료 상태/백그라운드 알림 받을 때 실행
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  /// FCM : 종료 상태에서 알림 클릭시 실행
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    print("종료 상태에서 FCM 클릭 누름");
    print(initialMessage.data);
    Get.to(() => const LoginPage());
    BottomNavigationBarController.to.selectedIndex.value = 2;
    Get.to(() => ChatRoomPage(
          roomId: initialMessage.data['roomId'],
          oppUserName: initialMessage.notification!.title!,
          isChatEnabled: true,
          isReceivedRequest: false,
        ));
  }

  //한국 시간 설정
  await initializeDateFormatting('ko_KR', null);

  WidgetsFlutterBinding.ensureInitialized();
  Get.put(FindFriendController());
  Get.put(BottomNavigationBarController());
  Get.put(KeywordController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final FcmController fcmController = Get.put(FcmController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: fcmController.initializeFcm(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              print("FCM 초기화 성공적");
              return const LoginPage();
            } else if (snapshot.hasError) {
              return const Center(child: Text('서버 오류!'));
            } else {
              return Center(child: Image.asset('assets/images/mbti.png'));
            }
          },
        ),
      ),
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
    );
  }
}
