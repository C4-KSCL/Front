import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/models/friend.dart';
import 'package:frontend_matching/models/userImage.dart';
import 'package:frontend_matching/pages/chatting_room/chatting_room_page.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/textStyle.dart';
import 'package:get/get.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:path/path.dart';

Widget FriendProfilePage({
  required Friend friendData,
  required VoidCallback voidCallback,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 50),
    child: Container(
      margin: const EdgeInsets.all(10.0),
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
                    backgroundImage: NetworkImage(friendData.userImage),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(friendData.nickname),
                          Container(
                            width: 40,
                            height: 20,
                            decoration: BoxDecoration(
                              color: blueColor1,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                                child: Text(
                              friendData.age,
                              style: whiteTextStyle2,
                            )),
                          ),
                        ],
                      ),
                      Text(friendData.myMBTI),
                    ],
                  )
                ],
              ),
              IconButton(onPressed: voidCallback, icon: const Icon(Icons.close))
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
          Obx(
            () => FriendController.to.friendImageData.isNotEmpty
                ? PageIndicatorContainer(
                    length: FriendController.to.friendImageData.length,
                    child: PageView.builder(itemBuilder: (context, index) {
                      UserImage friendImage =
                          FriendController.to.friendImageData[index];
                      return Image.network(friendImage.imagePath);
                    }),
                  )
                : Container(
                    height: 200,
                    width: 200,
                    color: Colors.black,
                  ),
          ),

          const SizedBox(
            height: 10,
          ),
          Text(friendData.myKeyword),
          // 채팅방 이동 버튼
          TextButton(
              onPressed: () {
                Get.to(ChatRoomPage(
                  roomId: friendData.roomId!,
                  oppUserName: friendData.nickname,
                ));
              },
              child: const Text("채팅방 이동"))
        ],
      ),
    ),
  );
}
