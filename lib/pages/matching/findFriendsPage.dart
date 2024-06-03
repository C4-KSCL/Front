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
  void initState() {
    super.initState();
    _loadFriends();
    print('init check');
  }

  Future<void> _loadFriends() async {
    await FindFriendController.findFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (FindFriendController.to.matchingFriendInfoList.isEmpty) {
          return const LoadingPage();
        } else {
          return const MainPage();
        }
      }),
    );
  }
}
