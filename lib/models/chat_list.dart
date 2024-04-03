class ChatList {
  final String roomId;
  String nickname;
  String createdAt;
  String content;
  int notReadCounts;
  String userImage;
  bool isChatEnabled;
  bool isReceivedRequest;

  ChatList({
    required this.roomId,
    required this.nickname,
    required this.createdAt,
    required this.content,
    required this.notReadCounts,
    required this.userImage,
    this.isChatEnabled = false,
    this.isReceivedRequest = false,
  });

  factory ChatList.fromJson(Map<String, dynamic> json) {
    return ChatList(
      roomId: json['roomId'],
      nickname: json['nickname'], // 키 값을 올바르게 수정
      createdAt: json['createdAt'],
      content: json['content'],
      notReadCounts: json['notReadCounts'],
      userImage: json['userImage'],
      isChatEnabled: json['isChatEnabled'] ?? false, // JSON에 없는 경우 기본값 사용
      isReceivedRequest: json['isReceivedRequest'] ?? false, // JSON에 없는 경우 기본값 사용
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'nickname': nickname,
      'createdAt': createdAt,
      'content': content,
      'notReadCounts': notReadCounts,
      'userImage': userImage,
      'isChatEnabled': isChatEnabled,
      'isReceivedRequest': isReceivedRequest,
    };
  }
}
