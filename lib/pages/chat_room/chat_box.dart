import 'package:flutter/material.dart';
import 'package:frontend_matching/models/chat.dart';
import 'package:frontend_matching/pages/chat_room/quiz_page.dart';
import 'package:frontend_matching/services/time_convert_service.dart';
import 'package:get/get.dart';

import '../../theme/colors.dart';
import '../../theme/textStyle.dart';

Widget SentTextChatBox({
  required Chat chat,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(chat.readCount == 1 ? "1" : ""),
          Text(convertHourAndMinuteTime(
              utcTimeString: chat.createdAt.toString())),
        ],
      ),
      Container(
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
            chat.content,
            style: whiteTextStyle2,
          ),
        ),
      ),
    ],
  );
}

Widget ReceiveTextChatBox({
  required Chat chat,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
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
          child: Text(
            chat.content,
            style: blackTextStyle4,
          ),
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(chat.readCount == 1 ? "1" : ""),
          Text(convertHourAndMinuteTime(
              utcTimeString: chat.createdAt.toString())),
        ],
      ),
    ],
  );
}

Widget SentQuizChatBox({
  required Chat chat,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(chat.readCount == 1 ? "1" : ""),
          Text(convertHourAndMinuteTime(
              utcTimeString: chat.createdAt.toString())),
        ],
      ),
      Container(
        decoration: const BoxDecoration(
          color: blueColor1,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8)),
        ),
        child: Column(
          children: [
            Text(
              chat.event!.smallCategory.name,
              style: blackTextStyle1,
            ),
            SizedBox(
              width: Get.width * 0.4,
              height: Get.width * 0.4,
              child:
                  Image.network(chat.event!.smallCategory.eventImage!.filepath),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  // 모양 설정
                  borderRadius: BorderRadius.circular(10), // 둥근 모서리의 반지름
                ),
                minimumSize: Size(Get.width * 0.3, 30),
              ),
              onPressed: () {
                Get.bottomSheet(
                  //quizId 를 통해서 api로 정보 받아오고 나면 QuizPage 열기
                  QuizPage(
                    voidCallback: Get.back,
                    chat: chat, isSentQuiz: true,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  isScrollControlled: true,
                );
              },
              child: const Text(
                "확인하기",
                style: blackTextStyle5,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget ReceiveQuizChatBox({
  required Chat chat,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        decoration: const BoxDecoration(
          color: greyColor3,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8)),
        ),
        child: Column(
          children: [
            Text(
              chat.event!.smallCategory.name,
              style: blackTextStyle1,
            ),
            SizedBox(
              width: Get.width * 0.4,
              height: Get.width * 0.4,
              child:
              Image.network(chat.event!.smallCategory.eventImage!.filepath),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  // 모양 설정
                  borderRadius: BorderRadius.circular(10), // 둥근 모서리의 반지름
                ),
                minimumSize: Size(Get.width * 0.3, 30),
              ),
              onPressed: () {
                Get.bottomSheet(
                  //quizId 를 통해서 api로 정보 받아오고 나면 QuizPage 열기
                  QuizPage(
                    voidCallback: Get.back,
                    chat: chat, isSentQuiz: false,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  isScrollControlled: true,
                );
              },
              child: const Text(
                "확인하기",
                style: blackTextStyle5,
              ),
            ),
          ],
        ),
      ),
      // readCount와 시간 표시
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(chat.readCount == 1 ? "1" : ""),
          Text(convertHourAndMinuteTime(
              utcTimeString: chat.createdAt.toString())),
        ],
      ),
    ],
  );
}
