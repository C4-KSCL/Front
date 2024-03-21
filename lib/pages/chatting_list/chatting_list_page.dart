import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/pages/chatting_list/chatlist_listtile.dart';
import 'package:frontend_matching/pages/chatting_list/chatting_list_controller.dart';
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
      ChatService.getLastChatList(); //마지막 채팅 내역 가져오기
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("채팅리스트"),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
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
              endActionPane: ActionPane(
                extentRatio: 0.3,
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.output,
                    label: '나가기',
                    onPressed: (BuildContext context) {

                    },
                  ),
                ],
              ),
              child: ChatListTile(
                nickname: chatListData.nickname,
                content: chatListData.content,
                timestamp: chatListData.createdAt,
                notReadCounts: chatListData.notReadCounts,
                roomId: chatListData.roomId,
                userImage: chatListData.userImage,
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
