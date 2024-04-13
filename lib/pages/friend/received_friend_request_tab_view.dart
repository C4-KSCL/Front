import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/friend/friend_and_request_listtile.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:get/get.dart';

Widget receivedFriendRequestTabView() {
  return Obx(() => ListView.separated(
        itemCount: FriendController.to.receivedRequests.length,
        itemBuilder: (context, index) {
          var receivedRequestData = FriendController.to.receivedRequests[index];
          return ReceivedRequest(
            receivedRequestData: receivedRequestData,
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 5,);
        },
      ));
}
