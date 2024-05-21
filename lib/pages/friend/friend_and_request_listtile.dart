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
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(8.0), // 모서리를 둥글게 처리
      child: Image.network(
        friendData.userImage, // 예시 이미지 URL
        width: 50,
        height: 100,
        fit: BoxFit.cover,
        alignment: Alignment.center,// 이미지가 넘치면 잘라냄
      ),
    ),
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
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(8.0), // 모서리를 둥글게 처리
      child: Image.network(
        receivedRequestData.userImage, // 예시 이미지 URL
        width: 50,
        height: 100,
        fit: BoxFit.cover,
        alignment: Alignment.center,// 이미지가 넘치면 잘라냄
      ),
    ),
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
                color:
                    receivedRequestData.gender == "남" ? blueColor1 : pinkColor1,
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
      ],
    ),
    trailing: IconButton(
      onPressed: () {
        Get.to(ChatRoomPage(
          roomId: receivedRequestData.roomId,
          oppUserName: receivedRequestData.nickname,
          friendRequestId: receivedRequestData.requestId,
        ));
        ChattingController.to.isReceivedRequest.value = true;
      },
      icon: Image.asset("assets/icons/question_message.png"),
    ),
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
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(8.0), // 모서리를 둥글게 처리
      child: Image.network(
        sentRequestData.userImage, // 예시 이미지 URL
        width: 50,
        height: 100,
        fit: BoxFit.cover,
        alignment: Alignment.center,// 이미지가 넘치면 잘라냄
      ),
    ),
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
        ChattingController.to.isReceivedRequest.value = false;
        Get.to(ChatRoomPage(
          roomId: sentRequestData.roomId,
          oppUserName: sentRequestData.nickname,
          friendRequestId: sentRequestData.requestId,
        ));
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
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(8.0), // 모서리를 둥글게 처리
      child: Image.network(
        friendData.userImage, // 예시 이미지 URL
        width: 50,
        height: 100,
        fit: BoxFit.cover,
        alignment: Alignment.center,// 이미지가 넘치면 잘라냄
      ),
    ),
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
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(8.0), // 모서리를 둥글게 처리
      child: Image.network(
        friendData.userImage, // 예시 이미지 URL
        width: 50,
        height: 100,
        fit: BoxFit.cover,
        alignment: Alignment.center,// 이미지가 넘치면 잘라냄
      ),
    ),
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
