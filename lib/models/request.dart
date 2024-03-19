class Request {
  final int requestId;
  final String myMBTI;
  final String myKeyword;
  final String nickname;
  final String userImage;
  final String age;
  final String createdAt;
  final String chatContent;
  final String roomId;

  Request({
    required this.requestId,
    required this.myMBTI,
    required this.myKeyword,
    required this.nickname,
    required this.userImage,
    required this.age,
    required this.createdAt,
    required this.chatContent,
    required this.roomId,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      requestId: json['requestId'],
      myMBTI: json['myMBTI'],
      myKeyword: json['myKeyword'],
      nickname: json['nickname'],
      userImage: json['userImage'],
      age: json['age'],
      createdAt: json['createdAt'],
      chatContent: json['chatContent'],
      roomId: json['roomId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'myMBTI': myMBTI,
      'myKeyword': myKeyword,
      'nickname': nickname,
      'userImage': userImage,
      'age': age,
      'createdAt': createdAt,
      'chatContent': chatContent,
      'roomId': roomId,
    };
  }
}