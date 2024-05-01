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
  receivedEventChat; // 받은 이벤트 메세지

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
    Get.put(ChattingController());
    Get.put(ChattingListController()); ////////////////없애야함///////////////

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
            // 나중에 지워야될거 /////////////////////////////////////////////
            ChattingListController.getLastChatList();
            ///////////////////////////////////////////////////////////////
            controller.disconnect();
            ChattingController.to.resetIsChatEnabled();
            ChattingController.to.clickAddButton.value=false;
            ChattingController.to.showSecondGridView.value=false;
            ChattingController.to.clickQuizButtonIndex.value=-1;
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

                      //날짜 비교 ///////////
                      String? DateText = controller.chatDate;
                      String currentChatDate = extractDate(chat.createdAt);
                      // print(DateText);
                      // print(currentChatDate);

                      if (controller.chatDate != currentChatDate) {
                        // print("다름");
                        controller.chatDate = currentChatDate;
                      } else {
                        DateText = null;
                      }

                      // 채팅 타입 비교
                      bool isTextChatType = chat.type == "text" ? true : false;
                      bool isUserEmail = chat.userEmail ==
                              UserDataController.to.user.value!.email
                          ? true
                          : false;
                      ChatType chatType =
                          ChatType.getChatType(isTextChatType, isUserEmail);

                      switch (chatType) {
                        case ChatType.sentTextChat:
                          return SentTextChatBox(
                            chat: chat,
                            chatDate: DateText,
                          );
                        case ChatType.sentEventChat:
                          return SentQuizChatBox(
                            chat: chat,
                            chatDate: DateText,
                          );
                        case ChatType.receivedTextChat:
                          return ReceiveTextChatBox(
                            chat: chat,
                            chatDate: DateText,
                          );
                        case ChatType.receivedEventChat:
                          return ReceiveQuizChatBox(
                            chat: chat,
                            chatDate: DateText,
                          );
                        default:
                          return const Text("알수 없는 채팅");
                      }
                    },
                  ),
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 5);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Obx(
            () => ChattingController.to.isChatEnabled.value
                ?
                // 채팅 키보드
                Container(
                    color: whiteColor1,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (focusNode.hasFocus) {
                              print("포커스 있음...........");
                              focusNode.unfocus();
                            }
                            if (!focusNode.hasFocus) {
                              print("포커스 없음...........");
                            }
                            ChattingController.getBigCategories();
                            controller.clickAddButton.value
                                ? controller.clickAddButton.value = false
                                : controller.clickAddButton.value = true;
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
                            focusNode: focusNode,
                            controller: chatController,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if(chatController.text.isNotEmpty){
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
                :
                //버튼 칸 (수락,거절 / 취소)
                Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ChattingController.to.isReceivedRequest.value
                            ? AcceptOrRejectButtonLayer(friendRequestId)
                            : CancelButtonLayer(friendRequestId),
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
          ),
          Obx(() => ChattingController.to.clickAddButton.value
              ? SizedBox(
                  height: 250,
                  child: Center(
                      child: Obx(
                    () => ChattingController.to.showSecondGridView.value
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
