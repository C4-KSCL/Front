import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/models/friend.dart';
import 'package:frontend_matching/models/request.dart';
import 'package:frontend_matching/pages/chatting_room/chatting_room_page.dart';
import 'package:frontend_matching/pages/friend/profile_page.dart';
import 'package:get/get.dart';

import '../../controllers/friend_controller.dart';
import '../../theme/colors.dart';
import '../../theme/textStyle.dart';

ListTile friendListTile({
  required Friend friendData,
}) {
  return ListTile(
    key: ValueKey(friendData.id),
    leading: Image.network(friendData.userImage, fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              friendData.nickname,
              style: blackTextStyle1,
              // style: friendData.gender == "남" ? blueTextStyle3 : pinkTextStyle1,
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: friendData.gender == "남" ? blueColor1 : pinkColor1,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                  child: Text(
                '${friendData.age}세',
                style: whiteTextStyle2,
              )),
            ),
          ],
        ),
        Text(
          friendData.myMBTI,
          style: const TextStyle(color: greyColor4),
        ),
      ],
    ),
    onTap: () {
      //프로필 페이지 열기
      Get.bottomSheet(
        FriendProfilePage(
          userData: friendData,
          voidCallback: Get.back,
        ),
        isScrollControlled: true,

      );
    },
  );
}

ListTile receivedRequestListTile({
  required Request receivedRequestData,
}) {
  return ListTile(
    key: ValueKey(receivedRequestData.requestId),
    leading: Image.network(receivedRequestData.userImage, fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              receivedRequestData.nickname,
              style: blackTextStyle1,
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: receivedRequestData.gender == "남" ? blueColor1 : pinkColor1,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                  child: Text(
                '${receivedRequestData.age}세',
                style: whiteTextStyle2,
              )),
            ),
          ],
        ),
        Text(
          receivedRequestData.myMBTI,
          style: const TextStyle(color: greyColor4),
        ),
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     TextButton(
        //       onPressed: () async {
        //         await FriendController.acceptFriendRequest(requestId: receivedRequestData.requestId.toString());
        //         FriendController.getFriendReceivedRequest();
        //         FriendController.getFriendList();
        //       },
        //       child: const Text('수락',style: blueTextStyle1,),
        //     ),
        //     TextButton(
        //       onPressed: () async{
        //         await FriendController.rejectFriendRequest(requestId: receivedRequestData.requestId.toString()); //친구 거절
        //         await ChattingController.deleteRoom(roomId: receivedRequestData.roomId); //채팅방 나가기
        //         FriendController.getFriendReceivedRequest(); //내역 리프레쉬
        //       },
        //       child: const Text('거절',style: redTextStyle1,),
        //     ),
        //   ],
        // ),
      ],
    ),
    trailing:
    IconButton(
      onPressed: () {
        Get.to(ChatRoomPage(roomId: receivedRequestData.roomId, oppUserName: receivedRequestData.nickname));
        ChattingController.to.isReceivedRequest.value=true;
      },
      icon: Image.asset("assets/icons/question_message.png"),
    ),
    // Row(
    //   mainAxisSize: MainAxisSize.min,
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     TextButton(
    //       onPressed: () async {
    //         await FriendController.acceptFriendRequest(
    //             requestId: receivedRequestData.requestId.toString());
    //         FriendController.getFriendReceivedRequest();
    //         FriendController.getFriendList();
    //       },
    //       child: const Text(
    //         '수락',
    //         style: blueTextStyle1,
    //       ),
    //     ),
    //     TextButton(
    //       onPressed: () async {
    //         await FriendController.rejectFriendRequest(
    //             requestId: receivedRequestData.requestId.toString()); //친구 거절
    //         await ChattingListController.leaveRoom(
    //             roomId: receivedRequestData.roomId); //채팅방 나가기
    //         FriendController.getFriendReceivedRequest(); //내역 리프레쉬
    //       },
    //       child: const Text(
    //         '거절',
    //         style: redTextStyle1,
    //       ),
    //     ),
    //   ],
    // ),
    onTap: () {
      //프로필 페이지 열기
      Get.bottomSheet(
        RequestProfilePage(
          userData: receivedRequestData,
          voidCallback: Get.back,
        ),
        isScrollControlled: true,
      );
    },
  );
}

ListTile sentRequestListTile({
  required Request sentRequestData,
}) {
  return ListTile(
    key: ValueKey(sentRequestData.requestId),
    leading: Image.network(sentRequestData.userImage, fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              sentRequestData.nickname,
              style: blackTextStyle1,
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: sentRequestData.gender == "남" ? blueColor1 : pinkColor1,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                  child: Text(
                '${sentRequestData.age}세',
                style: whiteTextStyle2,
              )),
            ),
          ],
        ),
        Text(
          sentRequestData.myMBTI,
          style: const TextStyle(color: greyColor4),
        ),
      ],
    ),
    trailing: IconButton(
      onPressed: () {
        ChattingController.to.isReceivedRequest.value=false;
        Get.to(ChatRoomPage(roomId: sentRequestData.roomId, oppUserName: sentRequestData.nickname));
      },
      icon: Image.asset("assets/icons/question_message.png"),
    ),
    onTap: () {
      Get.bottomSheet(
        RequestProfilePage(
          userData: sentRequestData,
          voidCallback: Get.back,
        ),
        isScrollControlled: true,
      );
    },
  );
}

ListTile friendSettingListTile({
  required Friend friendData,
}) {
  return ListTile(
    key: ValueKey(friendData.id),
    leading: Image.network(friendData.userImage, fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              friendData.nickname,
              style: blackTextStyle1,
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: friendData.gender == "남" ? blueColor1 : pinkColor1,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                  child: Text(
                '${friendData.age}세',
                style: whiteTextStyle2,
              )),
            ),
          ],
        ),
        Text(
          friendData.myMBTI,
          style: const TextStyle(color: greyColor4),
        ),
      ],
    ),
    trailing: TextButton(
      onPressed: () async {
        try {
          await FriendController.blockFriend(oppEmail: friendData.oppEmail);
          await FriendController.getFriendList();
          await FriendController.getBlockedFriendList();
        } catch (e) {
          print('An error occurred: $e');
        }
      },
      child: const Text(
        "차단",
        style: blackTextStyle1,
      ),
    ),
    onTap: () {},
  );
}

ListTile blockedFriendSettingListTile({
  required Friend friendData,
}) {
  return ListTile(
    key: ValueKey(friendData.id),
    leading: Image.network(friendData.userImage, fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              friendData.nickname,
              style: blackTextStyle1,
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: friendData.gender == "남" ? blueColor1 : pinkColor1,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                  child: Text(
                '${friendData.age}세',
                style: whiteTextStyle2,
              )),
            ),
          ],
        ),
        Text(
          friendData.myMBTI,
          style: const TextStyle(color: greyColor4),
        ),
      ],
    ),
    trailing: TextButton(
      onPressed: () async {
        try {
          await FriendController.unblockFriend(oppEmail: friendData.oppEmail);
          await FriendController.getFriendList();
          await FriendController.getBlockedFriendList();
        } catch (e) {
          print('An error occurred: $e');
        }
      },
      child: const Text(
        "차단 취소",
        style: blackTextStyle1,
      ),
    ),
    onTap: () {},
  );
}
