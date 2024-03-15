// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ChatRoomPage extends StatelessWidget {
//   const ChatRoomPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               socketController.disconnect();
//               Get.back();
//             },
//           ),
//           title: Text('챗방')),,
//       body: Column(
//           children: [
//           Expanded(
//           child: Obx(() => ListView.builder(
//       reverse: true,
//       itemCount: controller.readCounts.length,
//       itemBuilder: (BuildContext context, int index) => Obx(
//             () {
//           return controller.chats[index]['userEmail'] == userEmail
//               ? Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               if (controller.readCounts[index] == 1)
//                 Text(controller.readCounts[index].toString()),
//               BubbleSpecialThree(
//                   color: Colors.blue,
//                   tail: false,
//                   text: controller.chats[index]['content']),
//             ],
//           )
//               : Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               BubbleSpecialThree(
//                   color: Colors.grey,
//                   tail: false,
//                   isSender: false,
//                   text: controller.chats[index]['content']),
//               if (controller.readCounts[index] == 1)
//                 Text(controller.readCounts[index].toString()),
//             ],
//           );
//         },
//       ),
//     )),
//     ),
//     Row(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//     IconButton(
//     onPressed: () {
//     socketController.clickAddButton.value
//     ? socketController.clickAddButton.value = false
//         : socketController.clickAddButton.value = true;
//     //키보드가 열릴 때는 닫기
//     FocusScope.of(context).unfocus();
//     },
//     icon: Obx(
//     () => socketController.clickAddButton.value
//     ? const Icon(
//     Icons.keyboard_arrow_down,
//     color: Colors.black,
//     size: 24,
//     )
//         : const Icon(
//     Icons.add,
//     color: Colors.black,
//     size: 24,
//     ),
//     ),
//     ),
//     SizedBox(
//     width: Get.width-100,
//     child: TextField(
//     focusNode: myFocusNode,
//     controller: _chatController,
//     ),
//     ),
//     IconButton(onPressed: () {}, icon: Icon(Icons.send)),
//     ],
//     ),,
//     );
//   }
// }
