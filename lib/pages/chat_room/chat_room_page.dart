import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/pages/chat_room/big_category.dart';
import 'package:frontend_matching/pages/chat_room/middle_category.dart';
import 'package:frontend_matching/pages/chat_room/socket_controller.dart';
import 'package:get/get.dart';

class ChatRoomPage extends GetView<SocketController> {
  const ChatRoomPage({super.key, required this.roomId});

  final String roomId;

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
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                controller.disconnect();
                Get.back();
              },
            ),
            title: Text('챗방')),
        body: Column(children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                reverse: true,
                itemCount: controller.readCounts.length,
                itemBuilder: (BuildContext context, int index) => Obx(
                  () {
                    return controller.chats[index]['userEmail'] == UserDataController.to.user.value!.email
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (controller.readCounts[index] == 1)
                                Text(controller.readCounts[index].toString()),
                              BubbleSpecialThree(
                                  color: Colors.blue,
                                  tail: false,
                                  text: controller.chats[index]['content']),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              BubbleSpecialThree(
                                  color: Colors.grey,
                                  tail: false,
                                  isSender: false,
                                  text: controller.chats[index]['content']),
                              if (controller.readCounts[index] == 1)
                                Text(controller.readCounts[index].toString()),
                            ],
                          );
                  },
                ),
              ),
            ),
          ),
          Row(
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
                          color: Colors.black,
                          size: 24,
                        )
                      : const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 24,
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
              IconButton(onPressed: () {
                SocketController.to.sendMessage(roomId: roomId, content: chatController.text);
              }, icon: Icon(Icons.send)),
            ],
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
        ]));
  }
}
