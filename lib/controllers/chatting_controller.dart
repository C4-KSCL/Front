import 'dart:async';
import 'dart:convert';

import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/models/big_category.dart';
import 'package:frontend_matching/models/chat.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

import '../models/chat_list.dart';
import '../models/event.dart';
import '../models/small_category.dart';

class ChattingController extends GetxController {
  static ChattingController get to => Get.find<ChattingController>();

  IO.Socket? _socket; //소켓IO 객체
  static const baseUrl = 'http://15.164.245.62:8000'; //서버 url
  RxList chats = [].obs; //채팅 객체를 담는 배열

  RxBool clickAddButton = false.obs; // +버튼 누름여부
  RxBool showSecondGridView = false.obs; // 두번째 카테고리 여부
  RxInt clickQuizButtonIndex = (-1).obs; // Quiz 버튼 누름 여부
  RxBool isReceivedRequest = true.obs; //받은 요청이면 true, 보낸 요청이면 false
  RxBool isChatEnabled = true.obs; //채팅 가능 여부(친구가 아니면 채팅X)
  RxBool isQuizAnswered = false.obs; //퀴즈 답변 여부

  RxString userChoice="".obs;
  RxString oppUserChoice="".obs;

  // 객체 dynamic 말고 Bigcategory 등으로 바꿔보기
  List<dynamic> bigCategories = [];
  List<dynamic> smallCategories = [];

  String? bigCategoryName;

  static const rooms = 'rooms';
  static const send = 'send';
  // static const chats = 'chats';
  static const delete = 'delete';
  static const events = 'events';

  static String accessToken = UserDataController.to.accessToken;

  static Map<String, String> headers = {
    "Content-type": "application/json",
    "accessToken": accessToken
  };

  //Socket.io 관련 함수
  //소켓 연결
  void init() {
    _socket ??= IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'], //전송 방식을 웹소켓으로 설정
      'autoConnect': false, //수동으로 연결해야함
      'auth': {'token': UserDataController.to.accessToken},
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

    // 소켓 'connect' 이벤트 listen
    socket.on("connect", (_) {
      print("소켓이 연결되었습니다.");
    });

    // 'user join in room' 이벤트 listen
    socket.on("user join in room", (data) {
      print(data);
      print(chats.length.toString());
      print("user join in room 도착");

      // 안 읽은 채팅 1->0 으로 변환
      String joinUserEmail = data['userEmail'];
      for(Chat chat in chats){
        if(chat.userEmail != joinUserEmail){
          chat.readCount.value=0;
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

    // 'delete message' 이벤트 listen
    socket.on("delete message", (data) {
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
    final url = Uri.parse('$baseUrl/chats/get-chats/$roomId?page=1&limit=20');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);

    final jsonData = json.decode(response.body);
    ChattingController.to.chats.value= jsonData['chats'].map((data)=>Chat.fromJson(data)).toList();
  }

  //채팅 방 삭제하기
  static Future<void> deleteRoom({
    required String roomId,
  }) async {
    final url = Uri.parse('$baseUrl/$rooms/leave/$roomId');

    final response = await http.delete(url, headers: headers);

    print(response.statusCode);
    print(response.body);
  }

  //속한 채팅 방들 리스트 가져오기
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
  }

  // 퀴즈 답변 하기
  static Future<String> updateQuizInfo({
    required int quizId,
    required String quizAnswer,
    required bool isSentQuiz,
  }) async {
    final url = Uri.parse('$baseUrl/$events/update-event-answer/$quizId');

    String data = '{"content":"$quizAnswer"}';

    final response = await http.patch(url, headers: headers, body: data);

    print(response.statusCode);
    print(response.body);

    final jsonData = json.decode(response.body);
    if(isSentQuiz){
      return jsonData['event']['user1Choice'];
    } else{
      return jsonData['event']['user2Choice'];
    }
  }
}
