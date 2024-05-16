import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/chat.dart';
import 'package:frontend_matching/pages/chatting_room/big_category.dart';
import 'package:frontend_matching/pages/chatting_room/button_layer.dart';
import 'package:frontend_matching/pages/chatting_room/small_category.dart';
import 'package:frontend_matching/pages/chatting_room/quiz_page.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/services/time_convert_service.dart';
import 'package:frontend_matching/theme/textStyle.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../theme/colors.dart';
import 'chatting_box.dart';

// 채팅 타입
enum ChatType {
  sentTextChat, // 보낸 텍스트 메세지
  receivedTextChat, // 받은 텍스트 메세지
  sentEventChat, // 보낸 이벤트 메세지
  receivedEventChat,
  timeBox; // 받은 이벤트 메세지

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

class ChatRoomPage extends GetView<ChattingController> {
  ChatRoomPage({
    super.key,
    this.friendRequestId,
    required this.roomId,
    required this.oppUserName,
  });

  final String roomId;
  final String oppUserName;
  int? friendRequestId;

  @override
  Widget build(BuildContext context) {
    ChattingController.to.setRoomId(roomId: roomId);

    final FocusNode focusNode = FocusNode();
    var chatController = TextEditingController();

    MyTextFieldWidget() => focusNode.addListener(() {
          if (focusNode.hasFocus) {
            ChattingController.to.clickAddButton.value = false;
          }
        });

    MyTextFieldWidget();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("채팅방 화면 리로딩");
      ChattingController.to.init();
      ChattingController.to.connect(roomId: roomId); //웹소켓 연결
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
            ChattingListController.getLastChatList();
            Get.back();
            ChattingController.to.resetChatRoomData();
          },
        ),
        title: Text(oppUserName),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.separated(
                controller: controller.scrollController,
                reverse: true,
                itemCount: controller.chats.length,
                itemBuilder: (BuildContext context, int index) {
                  Chat chat = controller.chats[index];

                  if (chat.type == 'time') {
                    return timeBox(chatDate: formatIsoDateString(chat.createdAt));
                  }

                  // 채팅 타입 비교
                  bool isTextChatType = chat.type == "text";
                  bool isUserEmail = chat.userEmail == UserDataController.to.user.value?.email;
                  ChatType chatType = ChatType.getChatType(isTextChatType, isUserEmail);

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
                      return const Text("알수 없는 채팅");
                  }
                },
                separatorBuilder: (_, __) => const SizedBox(height: 3),
              ),
            )),
          ),
          const SizedBox(height: 5),
          Obx(() {
            return ChattingController.to.isChatEnabled.value
                ? Container(
              color: whiteColor1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      if (focusNode.hasFocus) {
                        focusNode.unfocus();
                      }
                      if (!focusNode.hasFocus) {
                        focusNode.requestFocus();
                      }
                      ChattingController.getBigCategories();
                      controller.clickAddButton.value = !controller.clickAddButton.value;
                    },
                    icon: Icon(
                      controller.clickAddButton.value ? Icons.keyboard_arrow_down : Icons.add,
                      color: blueColor1,
                      size: 25,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      controller: chatController,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (chatController.text.isNotEmpty) {
                          ChattingController.to.sendMessage(
                              roomId: roomId, content: chatController.text);
                          chatController.clear();
                        }
                      },
                      icon: Image.asset(
                          "assets/icons/send_message_button.png",
                          color: blueColor1)),
                ],
              ),
            )
                : Column(
              children: [
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: ChattingController.to.isReceivedRequest.value
                      ? AcceptOrRejectButtonLayer(friendRequestId)
                      : CancelButtonLayer(friendRequestId),
                ),
                const SizedBox(height: 50),
              ],
            );
          }),
          Obx(() => ChattingController.to.clickAddButton.value
              ? SizedBox(
            height: 250,
            child: Center(
              child: ChattingController.to.showSecondGridView.value ? smallCategory() : bigCategory(),
            ),
          )
              : Container()),
        ],
      )
      ,
    );
  }
}
