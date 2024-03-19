import 'package:get/get.dart';

import '../pages/init_page.dart';
import '../pages/login/loginPage.dart';
import '../pages/matching/mainPage.dart';
import '../models/user.dart';
import '../models/userImage.dart';

class UserDataController extends GetxController {
  static UserDataController get to => Get.find<UserDataController>();
  Rxn<User?> user = Rxn<User?>(null);
  List<dynamic> images = [];
  var accessToken = '';
  var refreshToken = '';
  RxList<User> matchingFriendInfoList = RxList<User>();
  RxList<List<UserImage>> matchingFriendImageList = RxList<List<UserImage>>();

  //컨트롤러가 준비되었을 때 실행 -> 초기화 작업이나 데이터 로딩과 같은 초기 설정
  @override
  void onReady() {
    super.onReady();
    _moveToPage(user.value);
    ever(user, _moveToPage); //user에 변화가 생기면 함수 실행
  }

  //User 정보에 따른 페이지 이동
  void _moveToPage(User? user) {
    if (user == null) {
      // Get.offAll(() => InitPage());
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => InitPage());
    }
  }

  //로그아웃
  void logout() {
    user.value = null;
  }
}
