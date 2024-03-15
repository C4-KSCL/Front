import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend_matching/pages/friend/friend_controller.dart';
import 'package:frontend_matching/pages/friend/friend_tab_view.dart';
import 'package:frontend_matching/pages/friend/received_friend_request_tab_view.dart';
import 'package:frontend_matching/pages/friend/sended_friend_request_tab_view.dart';
import 'package:frontend_matching/services/friend_service.dart';
import 'package:get/get.dart';

import '../../services/chat_service.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text("친구창"),
      ),
      body: Column(
        children: [
          /////////테스트용/////////
          TextField(
            controller: oppController,
          ),
          TextField(
            controller: contentController,
          ),
          TextButton(
            onPressed: () {
              FriendService.sendFriendRequest(
                  oppEmail: oppController.text,
                  content: contentController.text);
            },
            child: Text("요청"),
          ),
          ////////////////////////
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
                                _carouselController.animateToPage(
                                    FriendController.to.pageNumber.value);
                              },
                              child: Text(
                                '친구',
                                style: FriendController.to.pageNumber.value == 0
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
                            _carouselController.animateToPage(
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
                              _carouselController.animateToPage(
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
            height: 20,
          ),
          CarouselSlider(
            carouselController: _carouselController,
            items: [
              FriendTabView(),
              ReceivedFriendRequestTabView(),
              SendedFriendRequestTabView(),
            ],
            options: CarouselOptions(
                height: 600,
                //mediaquery로 수정필요
                scrollDirection: Axis.horizontal,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                initialPage: FriendController.to.pageNumber.value,
                onPageChanged: (index, reason) {
                  FriendController.to.pageNumber.value =
                      index; // 현재 페이지 인덱스를 _pageNumber 변수에 할당
                }),
          ),
        ],
      ),
    );
  }
}
