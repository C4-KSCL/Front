// ignore_for_file: prefer_const_constructors, invalid_use_of_protected_member, unnecessary_null_comparison, prefer_conditional_assignment

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/components/genderButton.dart';
import 'package:frontend_matching/components/mbtiKeyword.dart';
import 'package:frontend_matching/components/textField.dart';
import 'package:frontend_matching/controllers/findFriendController.dart';
import 'package:frontend_matching/controllers/settingModifyController.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/pages/matching/imageSlide.dart';
import 'package:frontend_matching/pages/matching/matchingView.dart';
import 'package:frontend_matching/pages/profile/myPage.dart';
import 'package:frontend_matching/services/friend_setting.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController sendingController = TextEditingController();
  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController maxAgeController = TextEditingController();
  String accessToken = '';
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
  FriendSettingService settingService = FriendSettingService();

  @override
  void initState() {
    super.initState();
    settingModifyController = Get.put(SettingModifyController());
    final controller = Get.find<UserDataController>();
    if (controller.user.value != null) {
      accessToken = controller.accessToken;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blueColor5,
        body: SafeArea(
            child: GetBuilder<UserDataController>(builder: (controller) {
          if (controller.user.value != null) {
            email = controller.user.value!.email;
            nickname = controller.user.value!.nickname;
            age = controller.user.value!.age;
            gender = controller.user.value!.gender;
            mbti = controller.user.value!.myMBTI!;
            if (gender == '남') {
              gender = '남';
            } else {
              gender = '여';
            }
            imageCount = controller.images.length;
            profileImagePath = controller.user.value!.userImage!;
            print(profileImagePath);

            for (int i = 0; i < imageCount; i++) {
              if (controller.images[i].imagePath != null) {
                String imagePath = controller.images[i].imagePath;
                validImagePaths.add(imagePath);
                print(imagePath);
              }
            }
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Find your soulmate',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  // 프로필 카드
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageSlider(imageArray: validImagePaths),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16.0, 10, 8.0, 0),
                                child: Text(
                                  nickname,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 10, 8.0, 0),
                                child: Text(
                                  age,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
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
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: ElevatedButton(
                        child: Text('매칭하기'),
                        onPressed: () async {
                          await FindFriendController.findFriends(accessToken);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 150.0),
                      child: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          // 매칭설정 페이지로 이동
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        })));
  }

  @override
  void dispose() {
    sendingController.dispose();
    super.dispose();
  }
}
