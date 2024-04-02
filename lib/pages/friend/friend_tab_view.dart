import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/friend/friend_and_request_listtile.dart';
import 'package:frontend_matching/pages/friend/friend_controller.dart';
import 'package:get/get.dart';

Widget FriendTabView() {
  return Obx(() => ListView.separated(
        itemCount: FriendController.to.friends.length,
        itemBuilder: (context, index) {
          var friendData = FriendController.to.friends[index];
          return FriendListTile(
            friendData: friendData,
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ));
}
