import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend_matching/controllers/fcm_controller.dart';
import 'package:frontend_matching/pages/login/loginPage.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Android : 백그라운드일때, FCM을 받았을 때 실행
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print(
      "백그라운드 때 받은 FCM 내용: ${message.data} ${message.sentTime}");
}

// main 함수
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ///.env 파일 불러오기
  await dotenv.load(fileName: ".env");
  AppConfig.load();

  /// Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FcmController fcmController = Get.put(FcmController());
  await fcmController.initializeFcm();

  /// FCM : 종료 상태/백그라운드 알림 받을 때 실행
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  /// 한국 시간 설정
  await initializeDateFormatting('ko_KR', null);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  FcmController fcmController = Get.put(FcmController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: LoginPage(),
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
    );
  }
}
