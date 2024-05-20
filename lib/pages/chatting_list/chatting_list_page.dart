import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/pages/chatting_list/chatlist_listtile.dart';
import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';

class ChattingListPage extends StatelessWidget {
  const ChattingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChattingListController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChattingListController.getLastChatList(); // 마지막 채팅 내역 가져오기
      // ChattingController.to.resetChatRoomData();
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("채팅"),
          ],
        ),
      ),
      body: Obx(
        () => ListView.separated(
          itemCount: ChattingListController.to.chattingList.length,
          itemBuilder: (context, index) {
            var chatListData = ChattingListController.to.chattingList[index];
            return Slidable(
              key: ValueKey(chatListData.roomId) ,
              endActionPane: ActionPane(
                extentRatio: 0.25,
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.output,
                    label: '나가기',
                    onPressed: (BuildContext context) async{
                      await ChattingListController.leaveRoom(roomId: chatListData.roomId);
                      await ChattingListController.getLastChatList();
                      await FriendController.getFriendList();
                    },
                  ),
                ],
              ),
              child: ChatListTile(
                chatListData: chatListData,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 5,);
          },
        ),
      ),
    );
  }
}
