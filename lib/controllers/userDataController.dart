import 'package:get/get.dart';

import '../login/loginPage.dart';
import '../matching/mainPage.dart';
import '../models/user.dart';
import '../models/userImage.dart';

class UserDataController extends GetxController {
  static UserDataController instance = Get.find(); //싱글톤 형식
  Rx<User?> user = Rx<User?>(null);
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
      Get.offAll(() => LoginPage()); //이전 모든 라우트를 제거하고 새로운 라우트로 이동(이전 라우트 스택 제거)
    } else {
      Get.offAll(() => MainPage());
    }
  }

  //로그아웃
  void logout() {
    user.value = null;
  }
}
