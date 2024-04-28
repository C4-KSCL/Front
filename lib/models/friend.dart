class Friend {
  final int id;
  final String userEmail; // 사용자 이메일
  final String oppEmail; // 친구 이메일
  final String myMBTI; //친구 mbti
  final String myKeyword; //친구 키워드
  final String nickname; // 친구 닉네임
  final String userImage; //친구 프로필 이미지
  final String age; // 친구 나이
  final String gender; // 친구 성별
  final String? roomId; // 친구와 연결된 채팅방 id

  Friend({
    required this.id,
    required this.userEmail,
    required this.oppEmail,
    required this.myMBTI,
    required this.myKeyword,
    required this.nickname,
    required this.userImage,
    required this.age,
    required this.gender,
     this.roomId,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] as int,
      userEmail:json['myMBTI'] as String,
      oppEmail: json['oppEmail'] as String,
      myMBTI: json['myMBTI'] as String,
      myKeyword: json['myKeyword'] as String,
      nickname: json['nickname'] as String,
      userImage: json['userImage'] as String,
      age: json['age'] as String,
      gender: json['gender'] as String,
      roomId: json['roomId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'userEmail':userEmail,
      'oppEmail':oppEmail,
      'myMBTI': myMBTI,
      'myKeyword': myKeyword,
      'nickname': nickname,
      'userImage': userImage,
      'age': age,
      'gender':gender,
      'roomId': roomId,
    };
  }
}
