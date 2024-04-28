import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/services/time_convert_service.dart';
import 'package:get/get.dart';

import '../../models/chat_list.dart';
import '../../theme/textStyle.dart';
import '../chatting_room/chatting_room_page.dart';

Widget ChatListTile({
  required ChatList chatListData,
}) {
  Get.put(ChattingController());

  return ListTile(
    key: ValueKey(chatListData.roomId),
    leading: CircleAvatar(
      backgroundImage: NetworkImage(chatListData.userImage),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          chatListData.nickname ??= "알 수 없음",
          style: blackTextStyle1,
        ),
        Text(
          chatListData.type == "text" ? chatListData.content : "퀴즈를 보냈습니다.",
          style: greyTextStyle3,
        ),
      ],
    ),
    trailing: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          convertHowMuchTimeAge(utcTimeString: chatListData.createdAt),
          style: greyTextStyle4,
        ),
        const SizedBox(height: 10,),
        if(chatListData.notReadCounts!=0)
        Container(
          decoration: BoxDecoration(
            color: chatListData.userEmail ==
                    UserDataController.to.user.value!.email
                ? Colors.transparent
                : Colors.red,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Text(
              chatListData.userEmail ==
                      UserDataController.to.user.value!.email
                  ? "" : chatListData.notReadCounts.toString()
                  ,
              style: whiteTextStyle2,
            ),
          ),
        ),
      ],
    ),
    onTap: () {
      print("챗 가능 : ${chatListData.isChatEnabled}");
      ChattingController.to.isChatEnabled.value = chatListData.isChatEnabled;
      print("받은 요청인가? : ${chatListData.isReceivedRequest}");
      ChattingController.to.isReceivedRequest.value =
          chatListData.isReceivedRequest;
      Get.to(ChatRoomPage(
        friendRequestId: chatListData.friendRequestId,
        roomId: chatListData.roomId,
        oppUserName: chatListData.nickname ??= "알 수 없음",
      ));
    },
  );
}
