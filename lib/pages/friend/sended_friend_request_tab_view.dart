import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/friend/friend_and_request_listtile.dart';
import 'package:frontend_matching/pages/friend/friend_controller.dart';
import 'package:get/get.dart';

Widget SendedFriendRequestTabView() {
  return Obx(() => ListView.separated(
    itemCount: FriendController.to.sendedRequests.length,
    itemBuilder: (context, index) {
      return SendedRequest(
        nickname: FriendController.to.sendedRequests[index].nickname,
        userImage:
        FriendController.to.sendedRequests[index].userImage,
        myMBTI: FriendController.to.sendedRequests[index].myMBTI,
        age: FriendController.to.sendedRequests[index].age,
        myKeyword:
        FriendController.to.sendedRequests[index].myKeyword,
        createdAt: FriendController.to.sendedRequests[index].createdAt,
        chatContent: FriendController.to.sendedRequests[index].chatContent,
        requestId: FriendController.to.sendedRequests[index].requestId,
        roomId: FriendController.to.sendedRequests[index].roomId,
      );
    },
    separatorBuilder: (context, index) {
      return const Divider();
    },
  )) ;
}
