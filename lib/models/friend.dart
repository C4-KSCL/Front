class Friend {
  final int id;
  final String userEmail;
  final String myMBTI;
  final String myKeyword;
  final String nickname;
  final String userImage;
  final String age;
  final String gender;
  final String? roomId;

  Friend({
    required this.id,
    required this.userEmail,
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
