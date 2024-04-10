import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/models/chat.dart';
import 'package:frontend_matching/pages/chat_room/big_category.dart';
import 'package:frontend_matching/pages/chat_room/button_layer.dart';
import 'package:frontend_matching/pages/chat_room/small_category.dart';
import 'package:frontend_matching/pages/chat_room/quiz_page.dart';
import 'package:frontend_matching/pages/chat_room/socket_controller.dart';
import 'package:frontend_matching/services/chat_service.dart';
import 'package:frontend_matching/theme/textStyle.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../theme/colors.dart';
import 'chat_box.dart';

// 채팅 타입
enum ChatType {
  sentTextChat,
  receivedTextChat,
  sentEventChat,
  receivedEventChat;

  static ChatType getChatType(bool isTextChatType, bool isUserEmail) {
    if (isTextChatType && isUserEmail) {
      return ChatType.sentTextChat;
    } else if (isTextChatType && !isUserEmail) {
      return ChatType.receivedTextChat;
    } else if (!isTextChatType && isUserEmail) {
      return ChatType.sentEventChat;
    } else {
      return ChatType.receivedEventChat;
    }
  }
}

class ChatRoomPage extends GetView<SocketController> {
  ChatRoomPage(
      {super.key,
      this.friendRequestId,
      required this.roomId,
      required this.oppUserName});

  final String roomId;
  final String oppUserName;
  int? friendRequestId;

  @override
  Widget build(BuildContext context) {
    Get.put(SocketController());

    var chatController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("앱 리로딩");
      SocketController.to.init();
      SocketController.to.connect(roomId: roomId); //웹소켓 연결
    });

    return Scaffold(
      backgroundColor: blueColor5,
      appBar: AppBar(
        backgroundColor: blueColor5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            controller.disconnect();
            Get.back();
          },
        ),
        title: Text(oppUserName),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              // 이 버튼을 누르면 endDrawer가 열립니다.
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.separated(
                  reverse: true,
                  itemCount: controller.chats.length,
                  itemBuilder: (BuildContext context, int index) => Obx(
                    () {
                      Chat chat = controller.chats[index];
                      bool isTextChatType = chat.type == "text" ? true : false;
                      bool isUserEmail = chat.userEmail ==
                              UserDataController.to.user.value!.email
                          ? true
                          : false;
                      ChatType chatType =
                          ChatType.getChatType(isTextChatType, isUserEmail);

                      switch (chatType) {
                        case ChatType.sentTextChat:
                          return SentTextChatBox(chat: chat);
                        case ChatType.sentEventChat:
                          return SentQuizChatBox(chat: chat);
                        case ChatType.receivedTextChat:
                          return ReceiveTextChatBox(chat: chat);
                        case ChatType.receivedEventChat:
                          return ReceiveQuizChatBox(chat: chat);
                        default:
                          return SentQuizChatBox(chat: chat);
                      }
                    },
                  ),
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 5,
                    );
                  },
                ),
              ),
            ),
          ),
          Obx(
            () => SocketController.to.isChatEnabled.value
                ?
                // 채팅 키보드
                Container(
                    color: whiteColor1,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            ChatService.getBigCategories();
                            controller.clickAddButton.value
                                ? controller.clickAddButton.value = false
                                : controller.clickAddButton.value = true;

                            //키보드가 열릴 때는 닫기
                            FocusScope.of(context).unfocus();
                          },
                          icon: Obx(
                            () => controller.clickAddButton.value
                                ? const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: blueColor1,
                                    size: 25,
                                  )
                                : const Icon(
                                    Icons.add,
                                    color: blueColor1,
                                    size: 25,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: Get.width - 100,
                          child: TextField(
                            // focusNode: myFocusNode,
                            controller: chatController,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              SocketController.to.sendMessage(
                                  roomId: roomId, content: chatController.text);
                            },
                            icon: Image.asset(
                                "assets/icons/send_message_button.png",
                                color: blueColor1)),
                      ],
                    ),
                  )
                :
                //버튼 칸 (수락,거절 / 취소)
                Align(
                    alignment: Alignment.center,
                    child: SocketController.to.isReceivedRequest.value
                        ? AcceptOrRejectButtonLayer(friendRequestId)
                        : CancelButtonLayer(friendRequestId),
                  ),
          ),
          Obx(() => SocketController.to.clickAddButton.value
              ? SizedBox(
                  height: 250,
                  child: Center(
                      child: Obx(
                    () => SocketController.to.showSecondGridView.value
                        ? smallCategory()
                        : bigCategory(),
                  )),
                )
              : Container()),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('오른쪽 드로어 헤더'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('항목 1'),
              onTap: () {
                // 항목 1을 탭했을 때 수행할 작업
                Navigator.pop(context); // Drawer를 닫습니다.
              },
            ),
            ListTile(
              title: Text('항목 2'),
              onTap: () {
                // 항목 2를 탭했을 때 수행할 작업
                Navigator.pop(context); // Drawer를 닫습니다.
              },
            ),
          ],
        ),
      ),
    );
  }
}
