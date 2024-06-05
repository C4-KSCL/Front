// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/components/genderButton.dart';
import 'package:frontend_matching/components/mbtiKeyword.dart';
import 'package:frontend_matching/components/textField.dart';
import 'package:frontend_matching/controllers/find_friend_controller.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/controllers/keyword_controller.dart';
import 'package:frontend_matching/controllers/settingModifyController.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/userImage.dart';
import 'package:frontend_matching/pages/matching/findFriendsPage.dart';
import 'package:frontend_matching/pages/matching/loadingPage.dart';
import 'package:frontend_matching/pages/matching/mbtiSettingPage.dart';
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
  final List<TextEditingController> sendingControllers = [];
  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController maxAgeController = TextEditingController();
  final CarouselController _carouselController = CarouselController();
  final PageController pageController = PageController(initialPage: 0);

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

    // 매칭된 사람 수만큼 컨트롤러 리스트 초기화
    int matchingFriendsCount =
        FindFriendController.to.matchingFriendInfoList.length;
    for (int i = 0; i < matchingFriendsCount; i++) {
      sendingControllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/logo.png"),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MbtiSettingPage(),
                  ),
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Container(
          height: Get.height,
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
            return Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                child: CarouselSlider(
                  items: List.generate(
                          FindFriendController.to.matchingFriendInfoList.length,
                          (infoIndex) {
                        if (infoIndex >= sendingControllers.length) {
                          sendingControllers.add(TextEditingController());
                        }
                        return Container(
                          width: Get.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: Get.height - 360,
                                  child: PageIndicatorContainer(
                                    align: IndicatorAlign.bottom,
                                    length: FindFriendController
                                            .to
                                            .matchingFriendImageList[infoIndex]
                                            .length +
                                        1,
                                    indicatorSpace: 10.0,
                                    padding: const EdgeInsets.all(10),
                                    indicatorColor: Colors.white,
                                    indicatorSelectorColor: Colors.blue,
                                    shape: IndicatorShape.circle(size: 8),
                                    child: PageView.builder(
                                      controller: pageController,
                                      itemCount: FindFriendController
                                              .to
                                              .matchingFriendImageList[
                                                  infoIndex]
                                              .length +
                                          1,
                                      itemBuilder: (context, imageIndex) {
                                        if (imageIndex <
                                            FindFriendController
                                                .to
                                                .matchingFriendImageList[
                                                    infoIndex]
                                                .length) {
                                          UserImage friendImage =
                                              FindFriendController.to
                                                      .matchingFriendImageList[
                                                  infoIndex][imageIndex];
                                          return Image.network(
                                            friendImage.imagePath,
                                            fit: BoxFit.cover,
                                          );
                                        } else {
                                          final analysis = FindFriendController
                                              .to
                                              .matchingFriendInfoList[infoIndex]
                                              .analysis;
                                          final displayText =
                                              analysis != null &&
                                                      analysis.isNotEmpty
                                                  ? analysis
                                                  : '분석 정보가 없습니다.';
                                          return Container(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '분석보기',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                SingleChildScrollView(
                                                  child: Text(
                                                    displayText,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                SingleChildScrollView(
                                  child: Row(
                                    children: [
                                      Text(
                                        FindFriendController
                                            .to
                                            .matchingFriendInfoList[infoIndex]
                                            .nickname,
                                        style: blackTextStyle8,
                                      ),
                                      const SizedBox(
                                        width: 5,
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
                                      const SizedBox(
                                        width: 5,
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
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: FindFriendController
                                        .to
                                        .matchingFriendInfoList[infoIndex]
                                        .myKeyword!
                                        .split(',')
                                        .map((item) => item.trim()) // 공백 제거
                                        .map((item) => Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: blueColor1,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Text(item,
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                IconTextFieldBox(
                                    hintText: '간단하게 인사를 해봐요',
                                    onPressed: () async {
                                      if (sendingControllers[infoIndex]
                                          .text
                                          .isNotEmpty) {
                                        await FriendController
                                            .sendFriendRequest(
                                          oppEmail: FindFriendController
                                              .to
                                              .matchingFriendInfoList[infoIndex]
                                              .email,
                                          content: sendingControllers[infoIndex]
                                              .text,
                                        );
                                        sendingControllers[infoIndex].clear();
                                        FriendController.getFriendSentRequest();
                                      }
                                    },
                                    textEditingController:
                                        sendingControllers[infoIndex]),
                              ],
                            ),
                          ),
                        );
                      }) +
                      [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "더 많은 친구를 만나고 싶나요?",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  await FindFriendController.findFriends();
                                  _carouselController.jumpToPage(0);
                                  FocusScope.of(context).unfocus();
                                },
                                child: Text("친구 찾기 시작하기"),
                              ),
                            ],
                          ),
                        )
                      ],
                  options: CarouselOptions(
                    scrollDirection: Axis.vertical,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                  ),
                  carouselController: _carouselController,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in sendingControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
