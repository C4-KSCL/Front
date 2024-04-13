import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/models/friend.dart';
import 'package:frontend_matching/models/request.dart';
import 'package:frontend_matching/pages/chat_room/chat_room_page.dart';
import 'package:frontend_matching/services/chat_service.dart';
import 'package:frontend_matching/services/friend_service.dart';
import 'package:get/get.dart';

import '../../controllers/friend_controller.dart';
import '../../theme/colors.dart';
import '../../theme/textStyle.dart';

ListTile FriendListTile({
  required Friend friendData,
}) {
  return ListTile(
    leading: Image.network(friendData.userImage, fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              friendData.nickname,
              style: friendData.gender=="남" ? blueTextStyle3 : pinkTextStyle1,
            ),
            const SizedBox(width: 10,),
            Container(
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: blueColor1,
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
          style: blackTextStyle1,
        ),
        Text(
          friendData.myKeyword,
          style: greyTextStyle3,
        ),
      ],
    ),
    trailing: TextButton(
      onPressed: () {
        // Get.to(ChatRoomPage(roomId: friendData.roomId, oppUserName: friendData.nickname,));
      },
      child: Text(""),
    ),
    onTap: () {},
  );
}

ListTile ReceivedRequest({
  required Request receivedRequestData,
}) {
  return ListTile(
    leading: Image.network(receivedRequestData.userImage, fit: BoxFit.fill),
    title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            receivedRequestData.nickname,
            style: receivedRequestData.gender=="남" ? blueTextStyle3 : pinkTextStyle1,
          ),
          const SizedBox(width: 10,),
          Container(
            width: 40,
            height: 20,
            decoration: BoxDecoration(
              color: blueColor1,
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
        style: blackTextStyle1,
      ),
      Text(
        receivedRequestData.myKeyword,
        style: greyTextStyle3,
      ),
    ],
  ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () async {
            await FriendController.acceptFriendRequest(requestId: receivedRequestData.requestId.toString());
            FriendController.getFriendReceivedRequest();
            FriendController.getFriendList();
          },
          child: const Text('수락'),
        ),
        TextButton(
          onPressed: () async{
            await FriendController.rejectFriendRequest(requestId: receivedRequestData.requestId.toString()); //친구 거절
            await ChattingController.deleteRoom(roomId: receivedRequestData.roomId); //채팅방 나가기
            FriendController.getFriendReceivedRequest(); //내역 리프레쉬
          },
          child: const Text('거절'),
        ),
      ],
    ),
    onTap: () {},
  );
}

ListTile sentRequest({
  required Request sentRequestData,
})  {
  return ListTile(
    leading: Image.network(sentRequestData.userImage, fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              sentRequestData.nickname,
              style: sentRequestData.gender=="남" ? blueTextStyle3 : pinkTextStyle1,
            ),
            const SizedBox(width: 10,),
            Container(
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: blueColor1,
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
          style: blackTextStyle1,
        ),
        Text(
          sentRequestData.myKeyword,
          style: greyTextStyle3,
        ),
      ],
    ),
    trailing: TextButton(
      onPressed: () {
        FriendController.deleteFriendRequest(requestId: sentRequestData.requestId.toString());
      },
      child: Text('취소'),
    ),
    onTap: () {},
  );
}
