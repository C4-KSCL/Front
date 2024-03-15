class UserImage {
  int imageNumber;
  int userNumber;
  String imagePath;
  String imageKey;
  DateTime imageCreated;

  UserImage({
    required this.imageNumber,
    required this.userNumber,
    required this.imagePath,
    required this.imageKey,
    required this.imageCreated,
  });

  // Dart 객체 -> JSON
  Map<String, dynamic> toJson() {
    return {
      'imageNumber': imageNumber,
      'userNumber': userNumber,
      'imagePath': imagePath,
      'imageKey': imageKey,
      'imageCreated': imageCreated.toIso8601String(),
    };
  }

  // JSON -> Dart 객체
  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      imageNumber: json['imageNumber'],
      userNumber: json['userNumber'],
      imagePath: json['imagePath'],
      imageKey: json['imageKey'],
      imageCreated: DateTime.parse(json['imageCreated']),
    );
  }
}
