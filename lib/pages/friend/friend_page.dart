import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/models/friend.dart';
import 'package:frontend_matching/pages/friend/friend_setting_page.dart';
import 'package:frontend_matching/pages/friend/friend_page_tab_view.dart';
import 'package:get/get.dart';

import '../../theme/colors.dart';
import '../../theme/textStyle.dart';
import 'friend_and_request_listtile.dart';

class FriendPage extends StatelessWidget {
  FriendPage({super.key});

  final CarouselController _carouselController = CarouselController();

  var oppController = TextEditingController();
  var contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(FriendController());
    //컨트롤러 제거 코드도 생각해보기 Get.delete<FriendController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("친구창 리로딩");
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("친구"),
            Row(
              children: [
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    switch (result) {
                      case "1":
                        Get.to(FriendSettingPage());
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: "1",
                      child: Text('친구 관리'),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          // /////////////////////////////////
          // TextField(
          //   controller: oppController,
          // ),
          // TextField(
          //   controller: contentController,
          // ),
          // TextButton(onPressed: (){
          //   FriendController.sendFriendRequest(oppEmail: oppController.text, content: contentController.text);
          // }, child: Text("친구추가")),
          // //////////////////////////////////

          // [ 친구 / 받은 요청 / 보낸 요청 ] 메뉴 바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
                decoration: BoxDecoration(
                  color: greyColor3,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: FriendController.to.pageNumber.value == 0
                                  ? whiteColor1
                                  : greyColor3,
                              borderRadius: BorderRadius.circular(8)),
                          width: 100,
                          child: TextButton(
                              onPressed: () {
                                FriendController.to.pageNumber.value = 0;
                                _carouselController.jumpToPage(
                                    FriendController.to.pageNumber.value);
                              },
                              child: Text(
                                '친구',
                                style:
                                    FriendController.to.pageNumber.value == 0
                                        ? blueTextStyle2
                                        : greyTextStyle5,
                              )),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: FriendController.to.pageNumber.value == 1
                                ? whiteColor1
                                : greyColor3,
                            borderRadius: BorderRadius.circular(8)),
                        width: 120,
                        child: TextButton(
                          onPressed: () {
                            FriendController.to.pageNumber.value = 1;
                            _carouselController.jumpToPage(
                                FriendController.to.pageNumber.value);
                          },
                          child: Text(
                            '받은 요청',
                            style: FriendController.to.pageNumber.value == 1
                                ? blueTextStyle2
                                : greyTextStyle5,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: FriendController.to.pageNumber.value == 2
                                ? whiteColor1
                                : greyColor3,
                            borderRadius: BorderRadius.circular(8)),
                        width: 120,
                        child: TextButton(
                            onPressed: () {
                              FriendController.to.pageNumber.value = 2;
                              _carouselController.jumpToPage(
                                  FriendController.to.pageNumber.value);
                            },
                            child: Text(
                              '보낸 요청',
                              style: FriendController.to.pageNumber.value == 2
                                  ? blueTextStyle2
                                  : greyTextStyle5,
                            )),
                      ),
                    ],
                  ),
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          // 탭 뷰
          Expanded(
            child: CarouselSlider(
              carouselController: _carouselController,
              items: [
                friendTabView(),
                receivedFriendRequestTabView(),
                sentFriendRequestTabView(),
              ],
              options: CarouselOptions(
                  // 높이 관련해서 수정해야함 ///////////////////
                  height: Get.height * 0.7,
                  ///////////////////////////////////////////////
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  initialPage: FriendController.to.pageNumber.value,
                  onPageChanged: (index, reason) {
                    FriendController.to.pageNumber.value =
                        index; // 현재 페이지 인덱스를 _pageNumber 변수에 할당
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
