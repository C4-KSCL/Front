import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/friend/friend_and_request_listtile.dart';
import 'package:frontend_matching/pages/friend/friend_controller.dart';
import 'package:get/get.dart';

Widget sentFriendRequestTabView() {
  return Obx(() => ListView.separated(
    itemCount: FriendController.to.sentRequests.length,
    itemBuilder: (context, index) {
      var sentRequestData=FriendController.to.sentRequests[index];
      return sentRequest(
        sentRequestData: sentRequestData,
      );
    },
    separatorBuilder: (context, index) {
      return const Divider();
    },
  )) ;
}
