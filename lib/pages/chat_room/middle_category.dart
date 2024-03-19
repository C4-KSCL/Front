import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/chat_room/socket_controller.dart';

Widget middleCategory() {
  // 두 번째 GridView.builder를 구성하는 코드
  // 여기서는 단순화를 위해 동일한 구조를 사용했으나, 필요에 따라 다르게 구성할 수 있습니다.
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                SocketController.to.showSecondGridView.value = false;
              },
              icon: Icon(Icons.keyboard_arrow_left)),
          Text("밸런스 게임"),
          Text(""),
        ],
      ),
      Expanded(
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 9, // 예시를 위해 아이템 개수를 9개로 설정
            itemBuilder: (context, index) {
              return Container(
                child: TextButton(
                  onPressed: () {},
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo2.png',
                        width: 80,
                        height: 80,
                      ),
                      Text("깻잎")
                    ],
                  ), // 이미지 경로는 실제 프로젝트에 맞게 조정하세요.
                ),
              );
            }),
      ),
    ],
  );
}