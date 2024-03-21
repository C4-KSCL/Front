import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/chat_room/chat_room_page.dart';
import 'package:frontend_matching/services/chat_service.dart';
import 'package:frontend_matching/services/friend_service.dart';
import 'package:get/get.dart';

import '../../theme/textStyle.dart';




ListTile FriendListTile({
  required String nickname,
  required String userImage,
  required String myMBTI,
  required String age,
  required String myKeyword,
  required String roomId,
}) {
  return ListTile(
    leading: Image.network(userImage, fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              nickname,
              style: blackTextStyle1,
            ),
            Text(
              myMBTI,
              style: blueTextStyle1,
            ),
            Text(
              age,
              style: blackTextStyle1,
            ),
          ],
        ),
        Text(
          myKeyword,
          style: greyTextStyle3,
        ),
      ],
    ),
    trailing: TextButton(
      onPressed: () {
        Get.to(ChatRoomPage(roomId: roomId, oppUserName: nickname,));
      },
      child: Text("채팅방 입장 or 메모 기능"),
    ),
    onTap: () {},
  );
}

ListTile ReceivedRequest({
  required String nickname,
  required String userImage,
  required String myMBTI,
  required String age,
  required String myKeyword,
  required String createdAt,
  required String chatContent,
  required int requestId,
  required String roomId,
}) {
  return ListTile(
    leading: Image.asset('assets/images/profile1.jpg', fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              nickname,
              style: blackTextStyle1,
            ),
            Text(
              myMBTI,
              style: blueTextStyle1,
            ),
            Text(
              age,
              style: blackTextStyle1,
            ),
          ],
        ),
        Text(
          myKeyword,
          style: greyTextStyle3,
        ),
        Text(
          chatContent,
          style: blackTextStyle1,
        ),
      ],
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () {
            FriendService.acceptFriendRequest(requestId: requestId.toString());
            FriendService.getFriendReceivedRequest();
          },
          child: const Text('수락'),
        ),
        TextButton(
          onPressed: () {
            FriendService.rejectFriendRequest(requestId: requestId.toString()); //친구 거절
            ChatService.deleteRoom(roomId: roomId); //채팅방 나가기
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
  required String nickname,
  required String userImage,
  required String myMBTI,
  required String age,
  required String myKeyword,
  required String createdAt,
  required String chatContent,
  required int requestId,
  required String roomId,
})  {
  return ListTile(
    leading: Image.asset('assets/images/profile1.jpg', fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              nickname,
              style: blackTextStyle1,
            ),
            Text(
              myMBTI,
              style: blueTextStyle1,
            ),
            Text(
              age,
              style: blackTextStyle1,
            ),
          ],
        ),
        Text(
          myKeyword,
          style: greyTextStyle3,
        ),
        Text(
          chatContent,
          style: blackTextStyle1,
        ),
      ],
    ),
    trailing: TextButton(
      onPressed: () {
        FriendService.deleteFriendRequest(requestId: requestId.toString());
      },
      child: Text('취소'),
    ),
    onTap: () {},
  );
}
