class SmallCategory {
  final int id;
  final String name;
  final String bigName;
  final String selectOne; // 첫번째 답변
  final String selectTwo; // 두번째 답변
  final String? imageId; // 이미지 ID는 null일 수 있으므로 nullable 타입으로 선언

  SmallCategory({
    required this.id,
    required this.name,
    required this.bigName,
    required this.selectOne,
    required this.selectTwo,
    this.imageId,
  });

  // JSON에서 SmallModel 객체로 변환하는 팩토리 생성자
  factory SmallCategory.fromJson(Map<String, dynamic> json) {
    return SmallCategory(
      id: json['id'],
      name: json['name'],
      bigName: json['bigName'],
      selectOne: json['selectOne'],
      selectTwo: json['selectTwo'],
      imageId: json['imageId'],
    );
  }

  // SmallModel 객체에서 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bigName': bigName,
      'selectOne': selectOne,
      'selectTwo': selectTwo,
      'imageId': imageId,
    };
  }
}