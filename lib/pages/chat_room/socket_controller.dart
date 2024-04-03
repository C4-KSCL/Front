import 'dart:async';

import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/models/big_category.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../services/chat_service.dart';

class SocketController extends GetxController {
  static SocketController get to => Get.find<SocketController>();

  IO.Socket? _socket; //소켓IO 객체
  var serverUrl = 'http://15.164.245.62:8000'; //서버 url
  RxList<dynamic> chats = [].obs; //채팅 객체를 담는 배열
  RxList readCounts = [].obs; //채팅의 읽음 여부를 담는 배열

  var clickAddButton = false.obs; // +버튼 누름여부
  var showSecondGridView = false.obs; // 두번째 카테고리 여부
  var clickQuizButtonIndex = (-1).obs; // Quiz 버튼 누름 여부
  var isReceivedRequest = true.obs; //받은 요청이면 true, 보낸 요청이면 false
  var isChatEnabled = true.obs; //채팅 가능 여부(친구가 아니면 채팅X)

  // 객체 dynamic 말고 Bigcategory 등으로 바꿔보기
  List<dynamic> bigCategories = [];
  List<dynamic> smallCategories = [];

  String? bigCategoryName;

  //소켓 연결
  void init() {
    _socket ??= IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'], //전송 방식을 웹소켓으로 설정
      'autoConnect': false, //수동으로 연결해야함
      'auth': {'token': UserDataController.to.accessToken},
    });
  }

  //초기 톡방 내용 가져오기
  void fetchInitialMessages({required String roomId}) async {
    chats.clear();
    readCounts.clear();
    // http.get을 통해 채팅방 내용 가져오기
    var initMessages = await ChatService.getRoomChats(roomId: roomId);
    for (var chat in initMessages) {
      chats.add(chat);
      readCounts.add(chat['readCount']);
    }
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

    // 소켓 'connect' 이벤트 listen
    socket.on("connect", (_) {
      print("소켓이 연결되었습니다.");
    });

    // 'user join in room' 이벤트 listen
    socket.on("user join in room", (data) {
      print(data);
      print(chats.length.toString());
      for (int i = 0; i < chats.length; i++) {
        if (chats[i]['userEmail'] != data['userEmail']) {
          readCounts[i] = 0;
        }
      }
      print("user join in room 도착");
    });

    // 'new message' 이벤트 listen
    socket.on("new message", (data) {
      print(data);
      print("new message 도착");
      chats.insert(0, data['msg']);
      readCounts.insert(0, data['msg']['readCount']);
    });

    // 'new event' 이벤트 listen
    socket.on("new event", (data) {
      print(data);
      print("밸런스 게임 성공적으로 전송");
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
}
