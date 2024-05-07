import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_matching/components/button.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/models/friend.dart';
import 'package:frontend_matching/models/request.dart';
import 'package:frontend_matching/models/userImage.dart';
import 'package:frontend_matching/pages/chatting_room/chatting_room_page.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/textStyle.dart';
import 'package:get/get.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:path/path.dart';

Widget FriendProfilePage({
  required Friend userData,
  required VoidCallback voidCallback,
}) {
  final pageController = PageController();
  Get.put(ChattingController(userData.roomId!));

  return Padding(
    padding: EdgeInsets.fromLTRB(0, Get.height * 0.1, 0, Get.height * 0.1),
    child: FutureBuilder(
      future: FriendController.getFriendData(friendEmail: userData.oppEmail),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // http를 통해 정보를 불러오지 못했을 때
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
          ;
        }
        // 에러 발생 시
        else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        // 성공적으로 친구의 정보를 불러왔을 경우
        else {
          print(FriendController.to.friendImageData.length);

          return Container(
            padding: EdgeInsets.all(10),
            width: Get.width * 0.6,
            height: Get.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.7),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              FriendController.to.friendData.value!.userImage!),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  userData.nickname,
                                  style: blackTextStyle1,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 40,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: blueColor1,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                      child: Text(
                                    userData.age + "세",
                                    style: whiteTextStyle2,
                                  )),
                                ),
                              ],
                            ),
                            Text(
                              userData.myMBTI,
                              style: const TextStyle(color: greyColor4),
                            ),
                          ],
                        )
                      ],
                    ),
                    IconButton(
                      onPressed: voidCallback,
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                // 친구의 사진 보여주는 슬라이더
                // http 요청을 통해 이미지 정보 못받으면 검정 화면
                Expanded(
                  child: PageIndicatorContainer(
                    align: IndicatorAlign.bottom,
                    length: FriendController.to.friendImageData.length,
                    indicatorSpace: 10.0,
                    // 인디케이터 간의 공간
                    padding: const EdgeInsets.all(10),
                    indicatorColor: Colors.white,
                    indicatorSelectorColor: Colors.blue,
                    shape: IndicatorShape.circle(size: 8),
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: FriendController.to.friendImageData.length,
                      itemBuilder: (context, index) {
                        var friendImage =
                            FriendController.to.friendImageData[index];
                        return Image.network(friendImage.imagePath);
                      },
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 8.0, // 수평 간격
                  runSpacing: 4.0, // 수직 간격
                  children: userData.myKeyword
                      .split(',')
                      .map((item) => item.trim()) // 공백 제거
                      .map((item) => Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: blueColor1,
                              ),
                              padding: EdgeInsets.all(5),
                              child: Text(item,
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ))
                      .toList(),
                ),
                // 채팅방 이동 버튼
                ColorBottomButton(
                  text: "채팅방 이동",
                  backgroundColor: blueColor1,
                  onPressed: () {
                    Get.back();
                    /////////////////////////삭제할거/////////////////////////
                    ChattingController.to.isChatEnabled.value = true;
                    ////////////////////////////////////////////////////////
                    Get.to(ChatRoomPage(
                      roomId: userData.roomId!,
                      oppUserName: userData.nickname,
                    ));
                  },
                  textStyle: whiteTextStyle1,
                )
              ],
            ),
          );
        }
      },
    ),
  );
}

Widget RequestProfilePage({
  required Request userData,
  required VoidCallback voidCallback,
}) {
  final pageController = PageController();

  return Padding(
    padding: EdgeInsets.fromLTRB(0, Get.height * 0.1, 0, Get.height * 0.1),
    child: FutureBuilder(
      future: FriendController.getFriendData(friendEmail: userData.userEmail),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // http를 통해 정보를 불러오지 못했을 때
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // 에러 발생 시
        else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        // 성공적으로 친구의 정보를 불러왔을 경우
        else {
          print(FriendController.to.friendImageData.length);

          return Container(
            padding: EdgeInsets.all(10),
            width: Get.width * 0.6,
            height: Get.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.7),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              FriendController.to.friendData.value!.userImage!),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  userData.nickname,
                                  style: blackTextStyle1,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 40,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: blueColor1,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                      child: Text(
                                        userData.age + "세",
                                        style: whiteTextStyle2,
                                      )),
                                ),
                              ],
                            ),
                            Text(
                              userData.myMBTI,
                              style: const TextStyle(color: greyColor4),
                            ),
                          ],
                        )
                      ],
                    ),
                    IconButton(
                      onPressed: voidCallback,
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                // 친구의 사진 보여주는 슬라이더
                // http 요청을 통해 이미지 정보 못받으면 검정 화면
                Expanded(
                  child: PageIndicatorContainer(
                    align: IndicatorAlign.bottom,
                    length: FriendController.to.friendImageData.length,
                    indicatorSpace: 10.0,
                    // 인디케이터 간의 공간
                    padding: const EdgeInsets.all(10),
                    indicatorColor: Colors.white,
                    indicatorSelectorColor: Colors.blue,
                    shape: IndicatorShape.circle(size: 8),
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: FriendController.to.friendImageData.length,
                      itemBuilder: (context, index) {
                        var friendImage =
                        FriendController.to.friendImageData[index];
                        return Image.network(friendImage.imagePath);
                      },
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 8.0, // 수평 간격
                  runSpacing: 4.0, // 수직 간격
                  children: userData.myKeyword
                      .split(',')
                      .map((item) => item.trim()) // 공백 제거
                      .map((item) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: blueColor1,
                      ),
                      padding: EdgeInsets.all(5),
                      child: Text(item,
                          style: TextStyle(color: Colors.white)),
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),
          );
        }
      },
    ),
  );
}
