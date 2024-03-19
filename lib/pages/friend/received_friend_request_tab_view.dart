import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/friend/friend_and_request_listtile.dart';
import 'package:frontend_matching/pages/friend/friend_controller.dart';
import 'package:get/get.dart';

Widget ReceivedFriendRequestTabView() {
  return Obx(() => ListView.separated(
        // itemCount: 1,
        itemCount: FriendController.to.receivedRequests.length,
        itemBuilder: (context, index) {
          return ReceivedRequest(
            nickname: FriendController.to.receivedRequests[index].nickname,
            userImage:
                FriendController.to.receivedRequests[index].userImage,
            myMBTI: FriendController.to.receivedRequests[index].myMBTI,
            age: FriendController.to.receivedRequests[index].age,
            myKeyword:
                FriendController.to.receivedRequests[index].myKeyword,
            createdAt: FriendController.to.receivedRequests[index].createdAt,
            chatContent: FriendController.to.receivedRequests[index].chatContent,
            requestId: FriendController.to.receivedRequests[index].requestId,
            roomId: FriendController.to.receivedRequests[index].roomId,
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ));
}
