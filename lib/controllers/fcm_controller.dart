import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/pages/login/loginPage.dart';
import 'package:get/get.dart';
import '../firebase_options.dart';

import '../pages/chatting_room/chatting_room_page.dart';
import '../pages/init_page.dart';
import 'bottomNavigationBar.dart';
import 'chatting_controller.dart';
import 'chatting_list_controller.dart';

class FcmController extends GetxController {
  static FcmController get to => Get.find();

  Future<bool> initializeFcm() async {
    /// Firebase 초기화
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// 알림 허락 여부 물어보는 창
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    /// iOS 포그라운드에서 heads up display 표시를 위해 alert, sound true로 설정
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    /// FCM : 종료 상태에서 알림 클릭시 실행
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("종료 상태에서 FCM 클릭 누름");
      print(initialMessage.data);
      Get.to(()=>const LoginPage());
      BottomNavigationBarController.to.selectedIndex.value = 2;
      Get.to(() => ChatRoomPage(
            roomId: initialMessage.data['roomId'],
            oppUserName: initialMessage.notification!.title!,
            isChatEnabled: true,
            isReceivedRequest: false,
          ));
    }

    /// Android용 알림 채널 생성
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // 채널 ID
      'High Importance Notifications', // 채널 이름
      description: 'This channel is used for important notifications.', // 채널 설명
      importance: Importance.high, // 중요도
    );

    /// iOS foreground에서 heads up display 표시를 위해 alert, sound true로 설정
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    /// 채널을 플러그인에 등록
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Notification plugin 초기화
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),

      /// Android : 포그라운드일때, FCM 클릭시 핸들링 코드
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        print("포그라운드일때 FCM 클릭");
        print("페이로드 값 : ${details.payload}");
        // 친구 관련 알림
        if (details.payload == "friendPage") {
          FriendController.getFriendSentRequest();
          FriendController.getFriendReceivedRequest();
          FriendController.getFriendList();
          BottomNavigationBarController.to.selectedIndex.value = 1;
        }
        // 채팅 알림
        else {
          List<String> chatData = details.payload!.split(',');
          BottomNavigationBarController.to.selectedIndex.value = 2;
          // 채팅방 입장되어 있는 경우
          if (Get.isRegistered<ChattingController>()) {
            print("채팅방 입장되어 있는거 확인 roomId ${chatData[1]}로 변경");
            ChattingController.to.roomId=chatData[1];
            ChatRoomPage
            // Get.back();
            // Get.to(() => ChatRoomPage(
            //   roomId: chatData[1],
            //   oppUserName: chatData[0],
            //   isChatEnabled: true,
            //   isReceivedRequest: false,
            // ));
          }
          else{
            Get.to(() => ChatRoomPage(
              roomId: chatData[1],
              oppUserName: chatData[0],
              isChatEnabled: true,
              isReceivedRequest: false,
            ));
          }
        }
      },
    );

    /// FCM : 포그라운드 알림 받기
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("포그라운드 메세지 수신 : ${message.data}");

      // 채팅 관련 알림
      if (message.data['route'] == "chat") {
        // 채팅 리스트 받아오기
        ChattingListController.getLastChatList();

        // FCM의 roomId
        String? incomingRoomId = message.data['roomId'];

        // ChattingController의 인스턴스가 등록되어 있는지 확인
        if (Get.isRegistered<ChattingController>()) {
          // 등록된 컨트롤러 사용
          final ChattingController chatRoomController = Get.find();

          // 받은 알림의 roomId가 현재 채팅방의 roomId가 같지 않으면 알림뜸
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

    /// IOS(포그라운드), Android(백그라운드) : 푸시알림 클릭시 실행,
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("IOS(포그라운드), Android(백그라운드) FCM 클릭: ${message.data}");

      if (message.data.containsKey('route')) {
        switch (message.data['route']) {
          case "chat":
            {
              Get.off(const InitPage());
              BottomNavigationBarController.to.selectedIndex.value = 2;
              print("룸 아이디: ${message.data['roomId']}");
              print("채팅 페이지로 기기");
              Get.to(() => ChatRoomPage(
                    roomId: message.data['roomId'],
                    oppUserName: message.notification!.title!,
                    isChatEnabled: true,
                    isReceivedRequest: false,
                  ));
            }
            break;
          case "friend":
            {
              Get.off(const InitPage());
              FriendController.getFriendSentRequest();
              FriendController.getFriendReceivedRequest();
              FriendController.getFriendList();
              BottomNavigationBarController.to.selectedIndex.value = 1;
              print("친구 페이지로 기기");
            }
            break;
          default:
            print("라우팅 Route not recognized: ${message.data['route']}");
            break;
        }
      } else {
        print("No route specified in the data");
      }
    });

    return true;
  }
}
