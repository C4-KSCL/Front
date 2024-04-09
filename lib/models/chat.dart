import 'package:frontend_matching/models/event.dart';

class Chat {
  final int id;
  final String roomId;
  final String? nickName;
  final String? userEmail;
  final String createdAt;
  final String content;
  final int readCount;
  final String type;
  final Event? event;

  Chat({
    required this.id,
    required this.roomId,
    required this.nickName,
    required this.userEmail,
    required this.createdAt,
    required this.content,
    required this.readCount,
    required this.type,
    this.event,
  });

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