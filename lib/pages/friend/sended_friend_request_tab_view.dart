import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/friend/friend_and_request_listtile.dart';
import 'package:frontend_matching/pages/friend/friend_controller.dart';
import 'package:get/get.dart';

Widget SendedFriendRequestTabView() {
  return Obx(() => ListView.separated(
    // itemCount: FriendController.to.friends.length,
    itemCount: 3,
    itemBuilder: (context, index) {
      return SendedRequest(
        username: "username",
        content: "content",
      );
    },
    separatorBuilder: (context, index) {
      return Divider();
    },
  )) ;
}
