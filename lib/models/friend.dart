class Friend {
  final String myMBTI;
  final String myKeyword;
  final String nickname;
  final String userImage;
  final String age;

  Friend({
    required this.myMBTI,
    required this.myKeyword,
    required this.nickname,
    required this.userImage,
    required this.age,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      myMBTI: json['myMBTI'] as String,
      myKeyword: json['myKeyword'] as String,
      nickname: json['nickname'] as String,
      userImage: json['userImage'] as String,
      age: json['age'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'myMBTI': myMBTI,
      'myKeyword': myKeyword,
      'nickname': nickname,
      'userImage': userImage,
      'age': age,
    };
  }
}