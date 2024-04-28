import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // 기기의 FCM 토큰 출력
  Future<void> init() async {
    String? token = await _firebaseMessaging.getToken();
    print("Firebase Messaging Token: $token");

    // 필요하다면 서버에 토큰을 저장하거나 로그인을 할 때 사용자 정보와 함께 보내기
  }

  // 알림과 관련된 설정 허용 창
  void requestPermission() async {
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

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}