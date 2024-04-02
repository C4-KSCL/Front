import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/friend/friend_and_request_listtile.dart';
import 'package:frontend_matching/pages/friend/friend_controller.dart';
import 'package:get/get.dart';

Widget SendedFriendRequestTabView() {
  return Obx(() => ListView.separated(
    itemCount: FriendController.to.sendedRequests.length,
    itemBuilder: (context, index) {
      var sendedRequestData=FriendController.to.sendedRequests[index];
      return SendedRequest(
        sendedRequestData: sendedRequestData,
      );
    },
    separatorBuilder: (context, index) {
      return const Divider();
    },
  )) ;
}
