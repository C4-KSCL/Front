import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/pages/chatting_list/chatlist_listtile.dart';
import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';

import '../../services/chat_service.dart';
import '../friend/friend_and_request_listtile.dart';

class ChattingListPage extends StatelessWidget {
  const ChattingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChattingListController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChattingListController.to.chattingList.clear();
      ChattingListController.getLastChatList(); // 마지막 채팅 내역 가져오기
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("채팅"),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
              ],
            )
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
                extentRatio: 0.3,
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.output,
                    label: '나가기',
                    onPressed: (BuildContext context) {},
                  ),
                ],
              ),
              child: ChatListTile(
                chatListData: chatListData,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      ),
    );
  }
}
