import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/models/chat.dart';
import 'package:frontend_matching/pages/chatting_room/quiz_page.dart';
import 'package:frontend_matching/services/time_convert_service.dart';
import 'package:get/get.dart';

import '../../theme/colors.dart';
import '../../theme/textStyle.dart';

Widget SentTextChatBox({
  required Chat chat,
  required String? chatDate,
}) {
  return GestureDetector(
    onLongPress: () {
      Get.dialog(
        AlertDialog(
          title: const Text('채팅 삭제'),
          content: const Text('채팅을 삭제하시겠습니까?',),
          actions: [
            TextButton(
              child: const Text('취소',style: TextStyle(color: Colors.black)),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: const Text('삭제',style: TextStyle(color: Colors.red)),
              onPressed: () {
                ChattingController.to.deleteMessage(roomId: chat.roomId, chatId: chat.id);
                Get.back();
              },
            ),
          ],
        ),
      );
    },
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat.readCount.value == 1 ? "1" : "",style: const TextStyle(color:blueColor1),),
                Text(convertHourAndMinuteTime(
                    utcTimeString: chat.createdAt.toString())),
              ],
            ),
            const SizedBox(width: 4,),
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
                  chat.content.value,
                  style: whiteTextStyle2,
                ),
              ),
            ),
          ],
        ),
        // if(chatDate!=null)
        //   timeBox(chatDate: extractDate(chatDate)),
      ],
    ),
  );
}

Widget ReceiveTextChatBox({
  required Chat chat,
  required String? chatDate,
}) {
  return Column(
    children: [
      Row(
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
                chat.content.value,
                style: blackTextStyle4,
              ),
            ),
          ),
          const SizedBox(width: 4,),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(chat.readCount.value == 1 ? "1" : "",style: const TextStyle(color:blueColor1),),
              Text(convertHourAndMinuteTime(
                  utcTimeString: chat.createdAt.toString())),
            ],
          ),
        ],
      ),
      // if(chatDate!=null)
      //   timeBox(chatDate: extractDate(chatDate)),
    ],
  );
}

Widget SentQuizChatBox({
  required Chat chat,
  required String? chatDate,
}) {
  return GestureDetector(
    onLongPress: () {
      // _showPopupMenu(context: context, chatId: chat.id);
      Get.dialog(
        AlertDialog(
          title: const Text('채팅 삭제'),
          content: const Text('채팅을 삭제하시겠습니까?',),
          actions: [
            TextButton(
              child: const Text('취소',style: TextStyle(color: Colors.black)),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: const Text('삭제',style: TextStyle(color: Colors.red)),
              onPressed: () {

                Get.back();
              },
            ),
          ],
        ),
      );
    },
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat.readCount.value == 1 ? "1" : "",style: const TextStyle(color:blueColor1),),
                Text(convertHourAndMinuteTime(
                    utcTimeString: chat.createdAt.toString())),
              ],
            ),
            const SizedBox(width: 4,),
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
                    style: whiteTextStyle1,
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
                        QuizPage(
                          voidCallback: Get.back,
                          quizId: chat.event!.id.toString(),
                          isSentQuiz: true,
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
                      style: blackTextStyle1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // if(chatDate!=null)
        //   timeBox(chatDate: extractDate(chatDate)),
      ],
    ),
  );
}

Widget ReceiveQuizChatBox({
  required Chat chat,
  required String? chatDate,
}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: greyColor3,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
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
                      QuizPage(
                        voidCallback: Get.back,
                        quizId: chat.event!.id.toString(),
                        isSentQuiz: false,
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
                    style: blackTextStyle1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4,),
          // readCount와 시간 표시
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(chat.readCount.value == 1 ? "1" : "",style: const TextStyle(color:blueColor1),),
              Text(convertHourAndMinuteTime(
                  utcTimeString: chat.createdAt.toString())),
            ],
          ),
        ],
      ),
      // if(chatDate!=null)
      //   timeBox(chatDate: extractDate(chatDate)),
    ],
  );
}

Widget timeBox({required String chatDate}) {
  return Center(
    child: Column(
      children: [
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: greyColor1,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              chatDate,
              style: whiteTextStyle2,
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    ),
  );
}
