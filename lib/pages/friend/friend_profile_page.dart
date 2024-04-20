import 'package:flutter/material.dart';
import 'package:frontend_matching/models/friend.dart';
import 'package:frontend_matching/pages/chatting_room/chatting_room_page.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/textStyle.dart';
import 'package:get/get.dart';

Widget FriendProfilePage({required Friend friendData}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 50),
    child: Container(
      margin: EdgeInsets.all(10.0),
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
              IconButton(onPressed: Get.back, icon: Icon(Icons.close))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 200,
            width: 200,
            color: Colors.black,
          ),
          SizedBox(
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
              child: Text("채팅방 이동"))
        ],
      ),
    ),
  );
}
