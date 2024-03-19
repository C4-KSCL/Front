class ChatList {
  final String roomId;
  final String nickname;
  final String createdAt;
  final String content;
  final int notReadCounts;
  final String userImage;

  ChatList({
    required this.roomId,
    required this.nickname,
    required this.createdAt,
    required this.content,
    required this.notReadCounts,
    required this.userImage,
  });

  factory ChatList.fromJson(Map<String, dynamic> json) {
    return ChatList(
      roomId: json['roomId'],
      nickname: json['nickName'], // JSON 예시에 'receive' 대신 'nickName' 사용
      createdAt: json['createdAt'],
      content: json['content'],
      notReadCounts: json['notReadCounts'],
      userImage: json['userImage'], // 초기값 설정, 필요시 수정 가능
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'nickName': nickname,
      'createdAt': createdAt,
      'content': content,
      'notReadCounts': notReadCounts,
      'userImage': userImage,
    };
  }
}