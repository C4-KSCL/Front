class UserImage {
  int imageNumber;
  int userNumber;
  String imagePath;
  DateTime imageCreated;

  UserImage({
    required this.imageNumber,
    required this.userNumber,
    required this.imagePath,
    required this.imageCreated,
  });

  // Dart 객체 -> JSON
  Map<String, dynamic> toJson() {
    return {
      'imageNumber': imageNumber,
      'userNumber': userNumber,
      'imagePath': imagePath,
      'imageCreated': imageCreated.toIso8601String(),
    };
  }

  // JSON -> Dart 객체
  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      imageNumber: json['imageNumber'],
      userNumber: json['userNumber'],
      imagePath: json['imagePath'],
      imageCreated: DateTime.parse(json['imageCreated']),
    );
  }
}
