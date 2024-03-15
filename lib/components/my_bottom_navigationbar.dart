import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bottomNavigationBar.dart';

class MyBottomNavigationBar extends GetView<BottomNavigationBarController> {
  const MyBottomNavigationBar({super.key});

  //controller는 GetView<BottomNavigationBarController>때문에 자동으로 BottomNavigationBarController을 할당

  @override
  Widget build(BuildContext context) {
    //Obx()안에서 .obs인 변수가 변화되면 위젯을 다시 빌드해서 화면 업데이트
    return Obx(() => BottomNavigationBar(
      // 현재 인덱스를 selectedIndex에 저장
      currentIndex: controller.selectedIndex.value,
      onTap: controller.changeIndex,
      unselectedItemColor: Colors.black, //애니메이션 없음
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: controller.selectedIndex.value ==
              0 ? Image.asset('assets/icons/selected_home.png') : Image.asset('assets/icons/no_selected_home.png'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: controller.selectedIndex.value ==
              1 ? Image.asset('assets/icons/selected_friend.png') : Image.asset('assets/icons/no_selected_friend.png'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: controller.selectedIndex.value ==
              2 ? Image.asset('assets/icons/selected_message.png') : Image.asset('assets/icons/no_selected_message.png'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: controller.selectedIndex.value ==
              3 ? Image.asset('assets/icons/selected_myInformation.png') : Image.asset('assets/icons/no_selected_myInformation.png'),
          label: '',
        ),
      ],
    ));
  }
}
