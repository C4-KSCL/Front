// ignore_for_file: prefer_const_constructors, invalid_use_of_protected_member, unnecessary_null_comparison, prefer_conditional_assignment

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/components/genderButton.dart';
import 'package:frontend_matching/components/mbtiKeyword.dart';
import 'package:frontend_matching/components/textField.dart';
import 'package:frontend_matching/controllers/findFriendController.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/controllers/settingModifyController.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/pages/matching/imageSlide.dart';
import 'package:frontend_matching/pages/profile/myPage.dart';
import 'package:frontend_matching/services/friend_setting.dart';
import 'package:get/get.dart';

class TestMatching extends StatefulWidget {
  final int idx;
  const TestMatching({required this.idx});
  @override
  _TestMatchingState createState() => _TestMatchingState();
}

class _TestMatchingState extends State<TestMatching> {
  final TextEditingController sendingController = TextEditingController();
  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController maxAgeController = TextEditingController();
  String accessToken = '';
  String _inputValue = '';
  String email = '';
  String nickname = '';
  String age = '';
  String gender = '';
  String mbti = '';
  String imagePath0 = '';
  String imagePath1 = '';
  String imagePath2 = '';
  int imageCount = 0;
  List<String> validImagePaths = [];
  String profileImagePath =
      'https://matchingimage.s3.ap-northeast-2.amazonaws.com/defalut_user.png';

  String selectedMBTI = '';
  int genderInt = 10;
  String genderString = '';

  late SettingModifyController settingModifyController;
  late UserDataController userDataController;
  FriendSettingService settingService = FriendSettingService();

  @override
  void initState() {
    super.initState();
    print('check2');
    settingModifyController = Get.put(SettingModifyController());
    userDataController = Get.put(UserDataController());
    print('check3');
    accessToken = userDataController.accessToken;
    if (userDataController.matchingFriendInfoList.isNotEmpty) {
      print('null이 아닙니다');
      email = userDataController.matchingFriendInfoList[widget.idx].email;
      nickname = userDataController.matchingFriendInfoList[widget.idx].nickname;
      age = userDataController.matchingFriendInfoList[widget.idx].age;
      gender = userDataController.matchingFriendInfoList[widget.idx].gender;

      mbti = userDataController.matchingFriendInfoList[widget.idx].myMBTI!;
      profileImagePath =
          userDataController.matchingFriendInfoList[widget.idx].userImage!;

      var imageCount =
          userDataController.matchingFriendImageList[widget.idx].length;

      for (int i = 0; i < imageCount; i++) {
        validImagePaths.add(userDataController
            .matchingFriendImageList[widget.idx][i].imagePath);
      }
    } else {
      print("null입니다");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Find your soulmate',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // 매칭설정 페이지로 이동
                },
              ),
            ],
          ),
        ),
        Expanded(
          // 프로필 카드
          child: Card(
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageSlider(imageArray: validImagePaths),
                Text(
                  nickname,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '간단하게 인사말을 해보세요',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.send),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          child: Text('매칭하기'), //매칭 함수 호출
          onPressed: () async {
            await FindFriendController.findFriends(accessToken);
          },
        ),
      ],
    )));
  }

  @override
  void dispose() {
    sendingController.dispose();
    super.dispose();
  }
}
