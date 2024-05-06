// ignore_for_file: prefer_const_constructors, invalid_use_of_protected_member, unnecessary_null_comparison, prefer_conditional_assignment

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/components/genderButton.dart';
import 'package:frontend_matching/components/mbtiKeyword.dart';
import 'package:frontend_matching/components/textField.dart';
import 'package:frontend_matching/controllers/find_friend_controller.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/controllers/settingModifyController.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/userImage.dart';
import 'package:frontend_matching/services/friend_setting.dart';
import 'package:get/get.dart';
import 'package:page_indicator/page_indicator.dart';

import '../../theme/colors.dart';
import '../../theme/textStyle.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController sendingController = TextEditingController();
  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController maxAgeController = TextEditingController();
  final CarouselController _carouselController = CarouselController();
  final pageController = PageController();

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
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find your',
              style: TextStyle(
                fontSize: 32,
                color: blackColor2,
                fontWeight: FontWeight.w400,
              ),
            ),
            Image.asset("assets/images/logo.png"),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return FractionallySizedBox(
                      heightFactor: 0.85,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Gap(),
                                Text(
                                  '    이상형 설정하기',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 27),
                                ),
                                Gap(),
                                Row(
                                  children: [
                                    SizedBox(width: 50),
                                    GenderButton(
                                      onGenderSelected: (selectedValue) {
                                        genderInt = selectedValue;
                                        if (genderInt == 1) {
                                          genderString = "남";
                                        } else {
                                          genderString = "여";
                                        }
                                        print(genderString);
                                      },
                                    ),
                                  ],
                                ),
                                Gap(),
                                MbtiKeyWord(
                                  title: 'mbti',
                                  onMbtiSelected: (String mbti) {
                                    selectedMBTI = mbti;
                                  },
                                ),
                                Row(
                                  children: [
                                    NumberInputField(
                                      controller: minAgeController,
                                      hintText: UserDataController
                                          .to.user.value!.friendMinAge!,
                                    ),
                                    Icon(Icons.remove),
                                    NumberInputField(
                                      controller: maxAgeController,
                                      hintText: UserDataController
                                          .to.user.value!.friendMaxAge!,
                                    ),
                                  ],
                                ),
                                Gap(),
                                Gap(),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF7EA5F3),
                                      minimumSize: Size(300, 50),
                                    ),
                                    child: const Text('변경',
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                    onPressed: () async {
                                      settingModifyController
                                          .addToSettingArray(selectedMBTI);
                                      settingModifyController.addToSettingArray(
                                          maxAgeController.text);
                                      settingModifyController.addToSettingArray(
                                          minAgeController.text);
                                      settingModifyController
                                          .addToSettingArray(genderString);
                                      print(settingModifyController);

                                      await settingService.updateFriendSetting(
                                        accessToken,
                                        selectedMBTI,
                                        maxAgeController.text,
                                        minAgeController.text,
                                        genderString,
                                      );
                                      print(selectedMBTI);
                                      Get.back();
                                    },
                                  ),
                                )
                              ]),
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.settings_rounded)),
          SizedBox(
            width: 20,
          )
        ],
        elevation: 0.0,
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        backgroundColor: blueColor5,
      ),
      backgroundColor: blueColor5,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Container(
            decoration: BoxDecoration(
              color: whiteColor1,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                  offset: const Offset(5, 5), // 그림자의 위치
                ),
              ],
            ),
            child: Obx(() {
              if (FindFriendController.to.matchingFriendInfoList.isEmpty) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 650,
                  margin:
                  const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "더 많은 친구를 만나고 싶나요?",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          FindFriendController.findFriends();
                          _carouselController.jumpToPage(0);
                          FocusScope.of(context).unfocus();
                        },
                        child: Text("친구 찾기 시작하기"),
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Obx(
                      () => CarouselSlider(
                        items: List.generate(
                            FindFriendController
                                    .to.matchingFriendInfoList.length +
                                1, (infoIndex) {
                          if (infoIndex <
                              FindFriendController
                                  .to.matchingFriendInfoList.length) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 480,
                                    child: PageIndicatorContainer(
                                      align: IndicatorAlign.bottom,
                                      length: FindFriendController
                                          .to
                                          .matchingFriendImageList[infoIndex]
                                          .length,
                                      indicatorSpace: 10.0,
                                      // 인디케이터 간의 공간
                                      padding: const EdgeInsets.all(10),
                                      indicatorColor: Colors.white,
                                      indicatorSelectorColor: Colors.blue,
                                      shape: IndicatorShape.circle(size: 8),
                                      child: PageView.builder(
                                        controller: pageController,
                                        itemCount: FindFriendController
                                            .to
                                            .matchingFriendImageList[infoIndex]
                                            .length,
                                        itemBuilder: (context, imageIndex) {
                                          UserImage friendImage =
                                              FindFriendController.to
                                                      .matchingFriendImageList[
                                                  infoIndex][imageIndex];
                                          return Image.network(
                                              friendImage.imagePath);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        FindFriendController
                                            .to
                                            .matchingFriendInfoList[infoIndex]
                                            .nickname,
                                        style: blackTextStyle1,
                                      ),
                                      Container(
                                        width: 40,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: FindFriendController
                                                      .to
                                                      .matchingFriendInfoList[
                                                          infoIndex]
                                                      .gender ==
                                                  "남"
                                              ? blueColor1
                                              : pinkColor1,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Center(
                                            child: Text(
                                          '${FindFriendController.to.matchingFriendInfoList[infoIndex].age}세',
                                          style: whiteTextStyle2,
                                        )),
                                      ),
                                      Text(
                                        FindFriendController
                                            .to
                                            .matchingFriendInfoList[infoIndex]
                                            .myMBTI!,
                                        style: blackTextStyle1,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: FindFriendController
                                          .to
                                          .matchingFriendInfoList[infoIndex]
                                          .myKeyword!
                                          .split(',')
                                          .map((item) => item.trim()) // 공백 제거
                                          .map((item) => Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: blueColor1,
                                                  ),
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(item,
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  IconTextFieldBox(
                                      hintText: '간단하게 인사를 해봐요',
                                      onPressed: () async{
                                        if (sendingController.text.isNotEmpty) {
                                          await FriendController.sendFriendRequest(
                                            oppEmail: FindFriendController
                                                .to
                                                .matchingFriendInfoList[
                                                    infoIndex]
                                                .email,
                                            content: sendingController.text,
                                          );
                                          sendingController.clear();
                                          FriendController
                                              .getFriendSentRequest();
                                        }
                                      },
                                      textEditingController: sendingController),
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "더 많은 친구를 만나고 싶나요?",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      FindFriendController.findFriends();
                                      _carouselController.jumpToPage(0);
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Text("친구 찾기 시작하기"),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                        options: CarouselOptions(
                          height: 650.0,
                          scrollDirection: Axis.vertical,
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                        ),
                        carouselController: _carouselController,
                      ),
                    ));
              }
            }),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    sendingController.dispose();
    super.dispose();
  }
}
