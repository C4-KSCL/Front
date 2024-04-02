import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/pages/chat_room/big_category.dart';
import 'package:frontend_matching/pages/chat_room/button_layer.dart';
import 'package:frontend_matching/pages/chat_room/middle_category.dart';
import 'package:frontend_matching/pages/chat_room/quiz_page.dart';
import 'package:frontend_matching/pages/chat_room/socket_controller.dart';
import 'package:frontend_matching/theme/textStyle.dart';
import 'package:get/get.dart';

import '../../theme/colors.dart';
import 'chat_box.dart';

class ChatRoomPage extends GetView<SocketController> {
  const ChatRoomPage(
      {super.key, required this.roomId, required this.oppUserName});

  final String roomId;
  final String oppUserName;

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
                  itemCount: controller.readCounts.length,
                  itemBuilder: (BuildContext context, int index) => Obx(
                    () {
                      //event가 null이 아닌경우에
                      return controller.chats[index]['userEmail'] ==
                              UserDataController.to.user.value!.email
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (controller.readCounts[index] == 1)
                                  Text(controller.readCounts[index].toString()),
                                SendTextChatBox(
                                    text: controller.chats[index]['content']),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ReceiveTextChatBox(
                                    text: controller.chats[index]['content']),
                                if (controller.readCounts[index] == 1)
                                  Text(controller.readCounts[index].toString()),
                              ],
                            );
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
          SendQuizChatBox(), //나중에 삭제
          SocketController.to.isFriend.value
              ? Container(
                  color: whiteColor1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
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
                              "assets/icons/send_message_button.png")),
                    ],
                  ),
                )
              : Align(
                  alignment: Alignment.center,
                  child: ButtonLayer(),
                ),
          Obx(() => SocketController.to.clickAddButton.value
              ? SizedBox(
                  height: 250,
                  child: Center(
                      child: Obx(
                    () => SocketController.to.showSecondGridView.value
                        ? middleCategory()
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
