import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/chat_room/socket_controller.dart';

Widget bigCategory() {
  return Column(
    children: [
      const Text("퀴즈"),
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
                onPressed: () {
                  SocketController.to.showSecondGridView.value = true;
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo1.png',
                      width: 80,
                      height: 80,
                    ),
                    Text("밸런스게임")
                  ],
                ), // 이미지 경로는 실제 프로젝트에 맞게 조정하세요.
              ),
            );
          },
        ),
      ),
    ],
  );
}