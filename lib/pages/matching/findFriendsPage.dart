import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/find_friend_controller.dart';
import 'package:frontend_matching/pages/matching/loadingPage.dart';
import 'package:frontend_matching/pages/matching/mainPage.dart';
import 'package:get/get.dart';

class FindFriendsPage extends StatefulWidget {
  @override
  _FindFriendsPageState createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (FindFriendController.to.matchingFriendInfoList.isEmpty) {
          return FutureBuilder(
              future: FindFriendController.findFriends(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingPage();
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return const MainPage();
                }
              });
        } else {
          return const MainPage();
        }
      }),
    );
  }
}
