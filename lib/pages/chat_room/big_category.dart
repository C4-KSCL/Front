import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/chat_room/socket_controller.dart';
import 'package:frontend_matching/theme/textStyle.dart';
import 'package:get/get.dart';

Widget bigCategory() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Opacity(
            // 투명한 IconButton을 추가하여 균형을 맞춤
            opacity: 0.0, // 완전 투명
            child: IconButton(
              onPressed: null, // 아무 동작도 하지 않음
              icon: Icon(Icons.close), // 실제 아이콘과 동일한 아이콘 사용
            ),
          ),
          const Expanded(
            // Text를 중앙 정렬하기 위해 Expanded 사용
            child: Text(
              "밸런스 게임 보내기",
              style: blackTextStyle2,
              textAlign: TextAlign.center, // Text 중앙 정렬
            ),
          ),
          IconButton(
            // 실제 사용할 IconButton
            onPressed: () {
              SocketController.to.clickAddButton.value = false;
              SocketController.to.clickQuizButtonIndex.value = -1;
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      Expanded(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: SocketController.to.bigCategories.length, // 예시를 위해 아이템 개수를 9개로 설정
          itemBuilder: (context, index) {
            var bigCategory=SocketController.to.bigCategories[index];
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 150,
                height: 150,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      // 모양 설정
                      borderRadius: BorderRadius.circular(10), // 둥근 모서리의 반지름
                    ),
                    minimumSize: Size(Get.width * 0.3, 30),
                  ),
                  onPressed: () {
                    SocketController.to.showSecondGridView.value = true;
                  },
                  child: Column(
                    children: [
                      Spacer(),
                      Image.asset("assets/icons/heart.png"),
                      SizedBox(height: 10,),
                      Text(
                        bigCategory,
                        style: blackTextStyle2,
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
