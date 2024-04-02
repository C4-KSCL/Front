import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend_matching/models/friend.dart';
import 'package:frontend_matching/models/request.dart';
import 'package:frontend_matching/pages/chat_room/chat_room_page.dart';
import 'package:frontend_matching/services/chat_service.dart';
import 'package:frontend_matching/services/friend_service.dart';
import 'package:get/get.dart';

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
              style: blueTextStyle3,
            ),
            SizedBox(width: 10,),
            Container(
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: blueColor1,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                  child: Text(
                    '$friendData.age세',
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
        Get.to(ChatRoomPage(roomId: friendData.roomId, oppUserName: friendData.nickname,));
      },
      child: Text("채팅방 입장 or 메모 기능"),
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
              style: blackTextStyle1,
            ),
            Text(
              receivedRequestData.myMBTI,
              style: blueTextStyle1,
            ),
            Text(
              receivedRequestData.age,
              style: blackTextStyle1,
            ),
          ],
        ),
        Text(
          receivedRequestData.myKeyword,
          style: greyTextStyle3,
        ),
        Text(
          receivedRequestData.chatContent,
          style: blackTextStyle1,
        ),
      ],
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () async {
            await FriendService.acceptFriendRequest(requestId: receivedRequestData.requestId.toString());
            FriendService.getFriendReceivedRequest();
            FriendService.getFriendList();
          },
          child: const Text('수락'),
        ),
        TextButton(
          onPressed: () async{
            await FriendService.rejectFriendRequest(requestId: receivedRequestData.requestId.toString()); //친구 거절
            await ChatService.deleteRoom(roomId: receivedRequestData.roomId); //채팅방 나가기
            FriendService.getFriendReceivedRequest(); //내역 리프레쉬
          },
          child: const Text('거절'),
        ),
      ],
    ),
    onTap: () {},
  );
}

ListTile SendedRequest({
  required Request sendedRequestData,
})  {
  return ListTile(
    leading: Image.network(sendedRequestData.userImage, fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              sendedRequestData.nickname,
              style: blackTextStyle1,
            ),
            Text(
              sendedRequestData.myMBTI,
              style: blueTextStyle1,
            ),
            Text(
              sendedRequestData.age,
              style: blackTextStyle1,
            ),
          ],
        ),
        Text(
          sendedRequestData.myKeyword,
          style: greyTextStyle3,
        ),
        Text(
          sendedRequestData.chatContent,
          style: blackTextStyle1,
        ),
      ],
    ),
    trailing: TextButton(
      onPressed: () {
        FriendService.deleteFriendRequest(requestId: sendedRequestData.requestId.toString());
      },
      child: Text('취소'),
    ),
    onTap: () {},
  );
}
