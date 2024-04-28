import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_matching/components/button.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/models/chat.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:get/get.dart';

import '../../theme/colors.dart';
import '../../theme/textStyle.dart';

Widget QuizPage({
  required VoidCallback voidCallback,
  required String quizId,
  required bool isSentQuiz,
}) {
  return Container(
    padding: EdgeInsets.all(16), // 내부 여백을 조정합니다.
    height: Get.height * 0.85, // BottomSheet의 높이를 설정합니다.
    child: FutureBuilder(
      future: ChattingController.getQuizInfo(quizId: quizId),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 데이터를 기다리는 동안 로딩 인디케이터를 보여줌
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // 에러 발생 시
          return Text("Error: ${snapshot.error}");
        } else {
          //초기화
          ChattingController.to.isQuizAnswered.value = false;

          String? oppUserChoice;

          if (isSentQuiz) {
            oppUserChoice =
                ChattingController.to.eventData.value!.user2Choice.value;
          } else {
            oppUserChoice =
                ChattingController.to.eventData.value!.user1Choice.value;
          }

          if (isSentQuiz) {
            if (ChattingController.to.eventData.value!.user1Choice.value !=
                null) {
              ChattingController.to.isQuizAnswered.value = true;
            }
          } else {
            if (ChattingController.to.eventData.value!.user2Choice.value !=
                null) {
              ChattingController.to.isQuizAnswered.value = true;
            }
          }
          print(ChattingController.to.eventData.value!.id);

          return Column(
            children: [
              //QuizPage 소제목, 'x' 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  // 'X' 버튼과 동일한 공간을 만들어 균형을 맞춥니다.
                  Text(
                      ChattingController.to.eventData.value!.smallCategory.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  // 중앙에 타이틀 또는 공간을 배치할 수 있습니다.
                  IconButton(
                      icon: const Icon(Icons.close),
                      // 'X' 버튼을 누르면 BottomSheet을 종료합니다.
                      onPressed: () {
                        voidCallback();
                      }),
                ],
              ),
              // Quiz 관련 이미지
              Center(
                child: Image.network(ChattingController
                    .to.eventData.value!.smallCategory.eventImage!.filepath),
              ),
              const SizedBox(
                height: 20,
              ),
              //Quiz 관련 컨텐츠 내용
              Text(
                ChattingController.to.eventData.value!.smallCategory.content,
                style: blackTextStyle3,
              ),
              const SizedBox(
                height: 20,
              ),
              // Quiz의 답변 여부에 따라 답변을 선택하는 버튼들 or 상대의 답변을 보여주는 화면
              Obx(() => ChattingController.to.isQuizAnswered.value
                  ? Column(
                      children: [
                        //
                        Align(
                          alignment: Alignment.centerLeft,
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
                              child: Text(
                                oppUserChoice == null
                                    ? '"아직 선택하지 않았습니다."'
                                    : isSentQuiz
                                        ? '"${ChattingController.to.eventData.value!.user2Choice.toString()}"'
                                        : '"${ChattingController.to.eventData.value!.user1Choice.toString()}"',
                                style: blackTextStyle6,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment:
                              Alignment.centerRight, // 두 번째 Container를 우측으로 정렬
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: Get.width * 0.75),
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
                                isSentQuiz
                                    ? '"${ChattingController.to.eventData.value!.user1Choice.value}"'
                                    : '"${ChattingController.to.eventData.value!.user2Choice.value}"',
                                style: whiteTextStyle3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        ColorBottomButton(
                          text: ChattingController
                              .to.eventData.value!.smallCategory.selectOne,
                          backgroundColor: blueColor1,
                          onPressed: () {
                            ChattingController.to.answerToEvent(
                              eventId:
                                  ChattingController.to.eventData.value!.id,
                              selectedContent: ChattingController
                                  .to.eventData.value!.smallCategory.selectOne,
                            );
                          },
                          textStyle: blackTextStyle1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ColorBottomButton(
                          text: ChattingController
                              .to.eventData.value!.smallCategory.selectTwo,
                          backgroundColor: pinkColor1,
                          onPressed: () {
                            ChattingController.to.answerToEvent(
                              eventId:
                                  ChattingController.to.eventData.value!.id,
                              selectedContent: ChattingController
                                  .to.eventData.value!.smallCategory.selectTwo,
                            );
                          },
                          textStyle: blackTextStyle1,
                        ),
                      ],
                    ))
            ],
          );
        }
      },
    ),
  );
}
