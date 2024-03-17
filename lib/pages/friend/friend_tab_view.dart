import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/friend/friend_and_request_listtile.dart';
import 'package:frontend_matching/pages/friend/friend_controller.dart';
import 'package:get/get.dart';

Widget FriendTabView() {
  return Obx(() => ListView.separated(
        itemCount: FriendController.to.friends.length,
        itemBuilder: (context, index) {
          return FriendListTile(
            nickname: FriendController.to.friends[index].nickname,
            userImage: FriendController.to.friends[index].userImage,
            myMBTI: FriendController.to.friends[index].myMBTI,
            age: FriendController.to.friends[index].age,
            myKeyword: FriendController.to.friends[index].myKeyword,
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ));
}
