import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend_matching/services/time_convert_service.dart';
import 'package:get/get.dart';

import '../../models/chat_list.dart';
import '../../theme/textStyle.dart';
import '../chat_room/chat_room_page.dart';

ListTile ChatListTile({
  required ChatList chatListData,
}) {
  return ListTile(

    leading: CircleAvatar(
      backgroundImage: NetworkImage(
          chatListData.userImage
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          chatListData.nickname,
          style: blackTextStyle1,
        ),
        Text(
          chatListData.content,
          style: greyTextStyle3,
        ),
      ],
    ),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          convertKoreaTime(utcTimeString: chatListData.createdAt),
          style: greyTextStyle4,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(7)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Text(chatListData.notReadCounts.toString(),style: whiteTextStyle2,),
          ),
        ),
      ],
    ),
    onTap: () {
      Get.to(ChatRoomPage(roomId: chatListData.roomId, oppUserName: chatListData.nickname,));
    },
  );
}
