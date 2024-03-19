import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/friend/friend_and_request_listtile.dart';
import 'package:frontend_matching/pages/friend/friend_controller.dart';
import 'package:get/get.dart';

Widget FriendTabView() {
  return Obx(() => ListView.separated(
        itemCount: FriendController.to.friends.length,
        itemBuilder: (context, index) {
          var FriendData = FriendController.to.friends[index];
          return FriendListTile(
            nickname: FriendData.nickname,
            userImage: FriendData.userImage,
            myMBTI: FriendData.myMBTI,
            age: FriendData.age,
            myKeyword: FriendData.myKeyword,
            roomId: FriendData.roomId,
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ));
}
