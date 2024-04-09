import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_matching/components/button.dart';
import 'package:frontend_matching/models/chat.dart';
import 'package:get/get.dart';

import '../../theme/colors.dart';
import '../../theme/textStyle.dart';

Widget QuizPage({
  required VoidCallback voidCallback,
  required Chat chat,
}) {
  return Container(
    padding: EdgeInsets.all(16), // 내부 여백을 조정합니다.
    height: Get.height * 0.85, // BottomSheet의 높이를 설정합니다.
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // 요소들을 양 끝으로 분산시킵니다.
          children: [
            SizedBox(width: 24),
            // 'X' 버튼과 동일한 공간을 만들어 균형을 맞춥니다.
            Text(chat.event!.smallCategory.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // 중앙에 타이틀 또는 공간을 배치할 수 있습니다.
            IconButton(
                icon: Icon(Icons.close),
                onPressed: voidCallback // 'X' 버튼을 누르면 BottomSheet을 종료합니다.
                ),
          ],
        ),
        Center(
          child: Image.network(
              chat.event!.smallCategory.eventImage!.filepath),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          chat.event!.smallCategory.content,
          style: blackTextStyle3,
        ),
        const SizedBox(
          height: 20,
        ),
        ColorBottomButton(
          text: chat.event!.smallCategory.selectOne,
          backgroundColor: blueColor1,
          onPressed: () {},
          textStyle: blackTextStyle1,
        ),
        const SizedBox(
          height: 10,
        ),
        ColorBottomButton(
          text: chat.event!.smallCategory.selectTwo,
          backgroundColor: pinkColor1,
          onPressed: () {},
          textStyle: blackTextStyle1,
        ),
        Align(
            alignment: Alignment.centerLeft, // 첫 번째 Container를 좌측으로 정렬
            child: Container(
              constraints: BoxConstraints(
                maxWidth: Get.width * 0.75,
              ),
              decoration: const BoxDecoration(
                color: greyColor3,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(chat.event!.user2Choice ==null ?
                  '"아직 선택하지 않았습니다."' : '"${chat.event!.user2Choice.toString()}"',
                  style: blackTextStyle6,
                ),
              ),
            )),
        const SizedBox(
          height: 20,
        ),
        Align(
            alignment: Alignment.centerRight, // 두 번째 Container를 우측으로 정렬
            child: Container(
              constraints: BoxConstraints(maxWidth: Get.width * 0.75),
              decoration: const BoxDecoration(
                color: blueColor1,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  chat.event!.user1Choice ==null ?
                  '"아직 선택하지 않았습니다."' : '"${chat.event!.user1Choice.toString()}"',
                  style: whiteTextStyle3,
                ),
              ),
            )),
      ],
    ),
  );
}
