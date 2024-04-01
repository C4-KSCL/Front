import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/chat_room/quiz_page.dart';
import 'package:get/get.dart';

import '../../theme/colors.dart';
import '../../theme/textStyle.dart';

Widget SendTextChatBox({
  required String text,
}){
  return Container(
    constraints: BoxConstraints(
        maxWidth: Get.width * 0.75),
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
        text,
        style: whiteTextStyle2,
      ),
    ),
  );
}

Widget ReceiveTextChatBox({
  required String text,
}){
  return Container(
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
        text,
        style: blackTextStyle4,
      ),
    ),
  );
}

Widget SendQuizChatBox(){
  return Container(
    decoration: const BoxDecoration(
      color: blueColor1,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8)),
    ),
    child: Column(
      children: [
        Text("",style: blackTextStyle1,),
        SizedBox(
          width: Get.width * 0.4,
          height: Get.width * 0.4,
          child: Image.asset("assets/images/똥맛카레.png"),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder( // 모양 설정
              borderRadius: BorderRadius.circular(10), // 둥근 모서리의 반지름
            ),
            minimumSize: Size(Get.width * 0.3, 30),
          ),
          onPressed: () {
            Get.bottomSheet(
              //quizId 를 통해서 api로 정보 받아오고 나면 QuizPage 열기
              QuizPage(voidCallback: Get.back, imageUrl: 'assets/images/똥맛카레.png', content: '이뻐?'),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              isScrollControlled: true,
            );
          },
          child: Text("확인하기",style: blackTextStyle5,),
        ),
      ],
    ),
  );
}

Widget ReceiveQuizChatBox(){
  return Container(
    decoration: const BoxDecoration(
      color: greyColor3,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8)),
    ),
    child: Column(
      children: [
        SizedBox(
          width: Get.width * 0.4,
          height: Get.width * 0.4,
          child: Image.asset("assets/images/logo2.png"),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder( // 모양 설정
              borderRadius: BorderRadius.circular(10), // 둥근 모서리의 반지름
            ),
            minimumSize: Size(Get.width * 0.3, 30),
          ),
          onPressed: () {
            Get.bottomSheet(
              //quizId 를 통해서 api로 정보 받아오고 나면 QuizPage 열기
              QuizPage(voidCallback: Get.back, imageUrl: 'https://matchingimage.s3.ap-northeast-2.amazonaws.com/defalut_user.png', content: '이뻐?'),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            );
          },
          child: Text("확인하기",style: blackTextStyle5,),
        ),
      ],
    ),
  );
}