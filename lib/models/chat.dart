import 'package:frontend_matching/models/event.dart';
import 'package:get/get.dart';

class Chat {
  final int id;
  final String roomId;
  final String? nickName;
  final String? userEmail;
  final String createdAt;
  final Rx<String> content;
  final Rx<int> readCount;
  final String type;
  final Event? event;

  Chat({
    required this.id,
    required this.roomId,
    this.nickName,
    this.userEmail,
    required this.createdAt,
    required String content,
    required int readCount,
    required this.type,
    this.event,
  }) : readCount = readCount.obs, content= content.obs;

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      roomId: json['roomId'],
      nickName: json['nickName'],
      userEmail: json['userEmail'],
      createdAt: json['createdAt'],
      content: json['content'],
      readCount: json['readCount'],
      type: json['type'],
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
    );
  }
}