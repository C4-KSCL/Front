// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../theme/colors.dart';
// import '../../theme/textStyle.dart';
// import 'friend_controller.dart';
//
// Widget TopMenuBar(){
//   return Obx(() => Row(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: [
//       Padding(
//         padding: const EdgeInsets.all(6.0),
//         child: Container(
//           decoration: BoxDecoration(
//               color: FriendController.to.pageNumber.value == 0
//                   ? whiteColor1
//                   : greyColor3,
//               borderRadius: BorderRadius.circular(8)),
//           width: 100,
//           child: TextButton(
//               onPressed: () {
//                 FriendController.to.pageNumber.value = 0;
//                 _carouselController.animateToPage(
//                     FriendController.to.pageNumber.value);
//               },
//               child: Text(
//                 '친구',
//                 style: FriendController.to.pageNumber.value == 0
//                     ? blueTextStyle2
//                     : greyTextStyle5,
//               )),
//         ),
//       ),
//       Container(
//         decoration: BoxDecoration(
//             color: FriendController.to.pageNumber.value == 1
//                 ? whiteColor1
//                 : greyColor3,
//             borderRadius: BorderRadius.circular(8)),
//         width: 120,
//         child: TextButton(
//           onPressed: () {
//             FriendController.to.pageNumber.value = 1;
//             _carouselController.animateToPage(
//                 FriendController.to.pageNumber.value);
//           },
//           child: Text(
//             '받은 요청',
//             style: FriendController.to.pageNumber.value == 1
//                 ? blueTextStyle2
//                 : greyTextStyle5,
//           ),
//         ),
//       ),
//       Container(
//         decoration: BoxDecoration(
//             color: FriendController.to.pageNumber.value == 2
//                 ? whiteColor1
//                 : greyColor3,
//             borderRadius: BorderRadius.circular(8)),
//         width: 120,
//         child: TextButton(
//             onPressed: () {
//               FriendController.to.pageNumber.value = 2;
//               _carouselController.animateToPage(
//                   FriendController.to.pageNumber.value);
//             },
//             child: Text(
//               '보낸 요청',
//               style: FriendController.to.pageNumber.value == 2
//                   ? blueTextStyle2
//                   : greyTextStyle5,
//             )),
//       ),
//     ],
//   ),);
// }