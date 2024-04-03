class BigCategory {
  final String name;
  final String? imageId; // null이 가능하므로 nullable 타입으로 선언
  final String? eventImage; // 마찬가지로 null이 가능

  BigCategory({
    required this.name,
    this.imageId,
    this.eventImage,
  });

  // JSON에서 EventModel 객체로 변환하는 팩토리 생성자
  factory BigCategory.fromJson(Map<String, dynamic> json) {
    return BigCategory(
      name: json['name'],
      imageId: json['imageId'],
      eventImage: json['eventImage'],
    );
  }

  // EventModel 객체에서 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageId': imageId,
      'eventImage': eventImage,
    };
  }
}