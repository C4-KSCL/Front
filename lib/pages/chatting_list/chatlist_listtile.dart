import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../theme/textStyle.dart';
import '../chat_room/chat_room_page.dart';

ListTile ChatListTile({
  required String nickname,
  required String content,
  required String timestamp,
  required int notReadCounts,
  required String roomId,
  required String userImage,
}) {
  return ListTile(
    leading: CircleAvatar(
      backgroundImage: NetworkImage(
        userImage
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nickname,
          style: blackTextStyle1,
        ),
        Text(
          content,
          style: greyTextStyle3,
        ),
      ],
    ),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          timestamp,
          style: greyTextStyle4,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(7)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Text(notReadCounts.toString()),
          ),
        ),
      ],
    ),
    onTap: () {
      Get.to(ChatRoomPage(roomId: roomId, oppUserName: nickname,));
    },
  );
}
