import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/friend/friend_and_request_listtile.dart';
import 'package:frontend_matching/pages/friend/friend_controller.dart';
import 'package:get/get.dart';

Widget ReceivedFriendRequestTabView() {
  return Obx(() => ListView.separated(
        itemCount: FriendController.to.receivedRequests.length,
        itemBuilder: (context, index) {
          var receivedRequestData = FriendController.to.receivedRequests[index];
          return ReceivedRequest(
            receivedRequestData: receivedRequestData,
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ));
}
