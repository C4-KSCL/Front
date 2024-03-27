import 'package:flutter/material.dart';

Widget QuizPage({
  required VoidCallback voidCallback,
  required String imageUrl,
  required String content,
}) {
  return Container(
    padding: EdgeInsets.all(16), // 내부 여백을 조정합니다.
    height: 400, // BottomSheet의 높이를 설정합니다.
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // 요소들을 양 끝으로 분산시킵니다.
          children: [
            SizedBox(width: 24),
            // 'X' 버튼과 동일한 공간을 만들어 균형을 맞춥니다.
            Text("타이틀",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // 중앙에 타이틀 또는 공간을 배치할 수 있습니다.
            IconButton(
                icon: Icon(Icons.close),
                onPressed: voidCallback // 'X' 버튼을 누르면 BottomSheet을 종료합니다.
                ),
          ],
        ),
        Expanded(
          child: Center(
            child: Image.network(
                '이미지 URL'), // 중앙에 배치할 이미지입니다. 로컬 이미지나 네트워크 이미지를 사용할 수 있습니다.
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // 버튼을 균등하게 배치합니다.
          children: [
            ElevatedButton(
              onPressed: () => {},
              child: Text('버튼 1'),
            ),
            ElevatedButton(
              onPressed: () => {},
              child: Text('버튼 2'),
            ),
          ],
        ),
      ],
    ),
  );
}
