import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/pages/friend/friend_tab_view.dart';
import 'package:frontend_matching/pages/friend/received_friend_request_tab_view.dart';
import 'package:frontend_matching/pages/friend/sent_friend_request_tab_view.dart';
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
      FriendController.to.friends.clear();
      FriendController.to.receivedRequests.clear();
      FriendController.to.sentRequests.clear();
      FriendController.getFriendList();
      FriendController.getFriendReceivedRequest(); //request:{[]}오면 에러
      FriendController.getFriendSendedRequest();
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("친구"),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
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
            height: 20,
          ),
          CarouselSlider(
            carouselController: _carouselController,
            items: [
              friendTabView(),
              receivedFriendRequestTabView(),
              sentFriendRequestTabView(),
            ],
            options: CarouselOptions(
                height: Get.height*0.7,
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
