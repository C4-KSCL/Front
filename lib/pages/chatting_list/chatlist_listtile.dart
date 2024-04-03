import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend_matching/pages/chat_room/socket_controller.dart';
import 'package:frontend_matching/services/time_convert_service.dart';
import 'package:get/get.dart';

import '../../models/chat_list.dart';
import '../../theme/textStyle.dart';
import '../chat_room/chat_room_page.dart';

Widget ChatListTile({
  required ChatList chatListData,
}) {
  Get.put(SocketController());

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
      crossAxisAlignment: CrossAxisAlignment.end,
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
      print("챗 가능 : ${chatListData.isChatEnabled}");
      SocketController.to.isChatEnabled.value=chatListData.isChatEnabled;
      print("받은 요청인가? : ${chatListData.isReceivedRequest}");
      SocketController.to.isReceivedRequest.value=chatListData.isReceivedRequest;
      Get.to(ChatRoomPage(roomId: chatListData.roomId, oppUserName: chatListData.nickname,));
    },
  );
}
