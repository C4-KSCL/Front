// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:frontend_matching/controllers/user_data_controller.dart';
// import 'package:frontend_matching/pages/matching/matchingPage.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// class MatchingView extends StatefulWidget {
//   const MatchingView({Key? key}) : super(key: key);
//
//   @override
//   _MatchingViewState createState() => _MatchingViewState();
// }
//
// class _MatchingViewState extends State<MatchingView> {
//   late PageController _pageViewController;
//   int _currentPageIndex = 0;
//   List<Widget> _matchingPages = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _pageViewController = PageController();
//     final userDataController = Get.find<UserDataController>();
//
//     int friendCount = userDataController.matchingFriendInfoList.length;
//     _matchingPages = List.generate(
//       friendCount,
//       (index) => MatchingPage(idx: index),
//     );
//   }
//
//   @override
//   void dispose() {
//     _pageViewController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         alignment: Alignment.bottomCenter,
//         children: <Widget>[
//           PageView(
//             scrollDirection: Axis.vertical,
//             controller: _pageViewController,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentPageIndex = index;
//               });
//             },
//             children: _matchingPages,
//           ),
//           _buildPageIndicator(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPageIndicator() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(_matchingPages.length, (index) {
//         return Container(
//           width: 8.0,
//           height: 8.0,
//           margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: _currentPageIndex == index
//                 ? Theme.of(context).primaryColor
//                 : Colors.grey,
//           ),
//         );
//       }),
//     );
//   }
// }
