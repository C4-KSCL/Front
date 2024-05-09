import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/big_category.dart';
import 'package:frontend_matching/models/chat.dart';
import 'package:frontend_matching/services/time_convert_service.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

import '../models/event.dart';
import '../models/small_category.dart';

class ChattingController extends GetxController {
  static ChattingController get to => Get.find<ChattingController>();

  ChattingController(this.roomId);

  @override
  void onInit() {
    super.onInit();
    baseUrl = dotenv.env['SERVER_URL'];
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >
        scrollController.position.maxScrollExtent * 0.1) {
      print("채팅 가져오기 ");
      getRoomChats(roomId: roomId);
    }
  }

  static late final String? baseUrl;
  ScrollController scrollController = ScrollController();
  String roomId;

  IO.Socket? _socket; //소켓IO 객체
  RxList chats = [].obs; //채팅 객체를 담는 배열
  Rx<Event?> eventData = Rx<Event?>(null); // event 객체 하나를 담는 변수

  RxBool clickAddButton = false.obs; // +버튼 누름여부
  RxBool showSecondGridView = false.obs; // 두번째 카테고리 여부
  RxInt clickQuizButtonIndex = (-1).obs; // 퀴즈 페이지 button index
  RxBool isReceivedRequest = true.obs; //받은 요청이면 true, 보낸 요청이면 false
  RxBool isChatEnabled = false.obs; //채팅 가능 여부(친구가 아니면 채팅X)
  RxBool isQuizAnswered = false.obs; //퀴즈 답변 여부

  RxString userChoice = "".obs;
  RxString oppUserChoice = "".obs;

  List<dynamic> bigCategories = []; //퀴즈 상위 카테고리
  List<dynamic> smallCategories = []; // 퀴즈 하위 카테고리

  String? bigCategoryName;
  String? chatDate;

  static const rooms = 'rooms';
  static const send = 'send';
  static const delete = 'delete';
  static const events = 'events';

  static String accessToken = UserDataController.to.accessToken;

  static Map<String, String> headers = {
    "Content-type": "application/json",
    "accessToken": accessToken
  };

  // 챗 가능 여부 리셋
  void resetChatRoomData() {
    isChatEnabled.value = false;
    clickAddButton.value=false;
    showSecondGridView.value=false;
    clickQuizButtonIndex.value=-1;
  }

  //Socket.io 관련 함수
  //소켓 연결
  void init() {
    _socket ??= IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'], //전송 방식을 웹소켓으로 설정
      'autoConnect': false, //수동으로 연결해야함
      'auth': {'token': UserDataController.to.accessToken},
    });

    _socket!.onError((data) {
      print("Connection failed: $data");
    });
  }

  //초기 톡방 내용 가져오기
  void fetchInitialMessages({required String roomId}) async {
    chats.clear();
    // http.get을 통해 채팅방 내용 가져오기
    await getRoomChats(roomId: roomId);
  }

  void connect({required String roomId}) async {
    //소켓 연결
    _socket!.connect();
    //소켓 연결되면 소켓 이벤트 리스너 설정하기
    _socket!.onConnect((_) {
      _initSocketListeners();
    });
    //채팅방 내용 가져오기
    fetchInitialMessages(roomId: roomId);
    // 방 참여
    joinRoom(roomId: roomId);
  }

  // 소켓 리스너 초기 설정
  void _initSocketListeners() {
    final socket = _socket!;

    //리스너가 중복되어 실행되지 않게 설정
    socket.off("disconnect");
    socket.off("connect");
    socket.off("user join in room");
    socket.off("new message");
    socket.off("delete message");
    socket.off("new event");
    socket.off("answer to event");

    // 소켓 'connect' 이벤트 listen
    socket.on("connect", (_) {
      print("소켓이 연결되었습니다.");
    });

    // 'user join in room' 이벤트 listen
    socket.on("user join in room", (data) {
      print(data);
      print("user join in room 도착");

      // 안 읽은 채팅 1->0 으로 변환
      String joinUserEmail = data['userEmail'];
      for (Chat chat in chats) {
        if (chat.userEmail != joinUserEmail) {
          chat.readCount.value = 0;
        }
      }
    });

    // 'new message' 이벤트 listen
    socket.on("new message", (data) {
      print(data);
      print("new message 도착");
      chats.insert(0, Chat.fromJson(data['msg']));
    });

    // 'new event' 이벤트 listen
    socket.on("new event", (data) {
      print(data);
      print("밸런스 게임 성공적으로 전송");
      chats.insert(0, Chat.fromJson(data['msg']));
    });

    // 'answer to event' 이벤트 listen
    socket.on("answer to event", (data) {
      print(data);
      print("밸런스 게임 답변 받음");
      // 받은 이벤트 id가 컨트롤러 안에 있는 이벤트 id와 같으면 변경 -> UI 실시간 변경 가능
      if (eventData.value!.id == data['event']['id']) {
        eventData.value!.user1Choice.value = data['event']['user1Choice'];
        eventData.value!.user2Choice.value = data['event']['user2Choice'];
        ChattingController.to.isQuizAnswered.value = true;
      }
    });

    // 'delete message' 이벤트 listen
    socket.on("delete message", (data) {
      for(Chat chat in chats){
        if(chat.id==data['msg']['id']){
          chat.content.value=data['msg']['content'];
        }
      }
      print(data);
      print("delete message 도착");
    });

    // 'disconnect' 이벤트 listen
    socket.on("disconnect", (_) {
      print("소켓 연결 끊김");
    });
  }

  //소켓 연결 끊기
  void disconnect() {
    _socket!.disconnect();
  }

  // 채팅방 입장
  void joinRoom({required String roomId}) {
    final data = {
      "roomId": roomId,
    };
    _socket!.emit("join room", data);
  }

  //채팅 보내기
  void sendMessage({
    required String roomId,
    required String content,
  }) {
    final socket = _socket!;

    final data = {
      "roomId": roomId,
      "content": content,
    };
    socket.emit("send message", data);
  }

  //채팅 삭제
  void deleteMessage({
    required String roomId,
    required int chatId,
  }) {
    final socket = _socket!;

    final data = {
      "roomId": roomId,
      "chatId": chatId,
    };
    socket.emit("delete message", data);
  }

  // 새로운 이벤트(밸런스 게임)보내기
  void newEvent({
    required String smallCategoryName,
  }) {
    final socket = _socket!;

    final data = {
      "smallCategory": smallCategoryName,
    };
    socket.emit("new event", data);
  }

  // 이벤트(밸런스 게임) 답변 보내기
  void answerToEvent({
    required int eventId,
    required String selectedContent,
  }) {
    final socket = _socket!;

    final data = {
      "eventId": eventId,
      "content": selectedContent,
    };
    socket.emit("answer to event", data);
  }

  @override
  void onClose() {
    _socket!.disconnect();
    chats.clear();
    super.onClose();
  }

  void clickQuizButton(int index) {
    clickQuizButtonIndex.value = index;
  }

  // 채팅 관련 http 메소드

  // 그 방 채팅내용 가져오기
  // 채팅 내역 반환
  static Future<void> getRoomChats({required String roomId}) async {
    var url;

    // 채팅방 첫입장
    if(ChattingController.to.chats.isNotEmpty){
      final firstChatId = ChattingController.to.chats.last.id.toString();
      url = Uri.parse('$baseUrl/chats/get-chats/$roomId?chatId=$firstChatId');
    }
    // 채팅방 무한 스크롤
    else{
      url = Uri.parse('$baseUrl/chats/get-chats/$roomId');
    }

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);

    final jsonData = json.decode(response.body);
    for (var data in jsonData['chats']) {
      ChattingController.to.chats.add(Chat.fromJson(data)); // Chat.fromJson을 사용하여 객체 생성 및 추가
    }

    // ChattingController.to.chatDate =
    //     extractDate(ChattingController.to.chats[0].createdAt);
  }

  //속한 채팅 방들 리스트 받아오기
  static Future<void> getRoomList() async {
    final url = Uri.parse('$baseUrl/$rooms/get-list/');

    final response = await http.delete(url, headers: headers);

    print(response.statusCode);
    print(response.body);
  }

  // bigCategory 가져오기
  static Future<void> getBigCategories() async {
    final url = Uri.parse('$baseUrl/$events/get-big/');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);

    final jsonData = json.decode(response.body);
    ChattingController.to.bigCategories = jsonData['categories']
        .map((data) => BigCategory.fromJson(data))
        .toList();
  }

  // smallCategory 가져오기
  static Future<void> getSmallCategories({
    required String bigCategoryName,
  }) async {
    final url = Uri.parse('$baseUrl/$events/get-small/$bigCategoryName');

    final response = await http.get(url, headers: headers);

    print(response.body);

    final jsonData = json.decode(response.body);
    ChattingController.to.smallCategories = jsonData['categories']
        .map((data) => SmallCategory.fromJson(data))
        .toList();
  }

  // 퀴즈 정보 불러오기
  static Future<void> getQuizInfo({
    required String quizId,
  }) async {
    final url = Uri.parse('$baseUrl/$events/get-event-page/$quizId');

    final response = await http.get(url, headers: headers);

    print(response.body);

    final jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      ChattingController.to.eventData.value = Event.fromJson(jsonData['event']);
    }
  }

  // 퀴즈 답변 하기
  // static Future<String> updateQuizInfo({
  //   required int quizId,
  //   required String quizAnswer,
  //   required bool isSentQuiz,
  // }) async {
  //   final url = Uri.parse('$baseUrl/$events/update-event-answer/$quizId');
  //
  //   String data = '{"content":"$quizAnswer"}';
  //
  //   final response = await http.patch(url, headers: headers, body: data);
  //
  //   print(response.statusCode);
  //   print(response.body);
  //
  //   final jsonData = json.decode(response.body);
  //   if(isSentQuiz){
  //     return jsonData['event']['user1Choice'];
  //   } else{
  //     return jsonData['event']['user2Choice'];
  //   }
  // }
}
