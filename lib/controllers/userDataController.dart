import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/pages/login/loginPage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../pages/init_page.dart';
import '../models/user.dart';
import '../models/userImage.dart';

class UserDataController extends GetxController {
  static UserDataController get to => Get.find<UserDataController>();
  SignupController signupController = Get.find<SignupController>();
  Rxn<User?> user = Rxn<User?>(null);
  RxList<XFile?> userImages = <XFile?>[].obs;
  Rx<String> matchingUserNumbers = "1,2,3".obs; // 매칭 친구 userNumbers

  RxList<User> matchingFriendInfoList = RxList<User>();
  RxList<List<UserImage>> matchingFriendImageList = RxList<List<UserImage>>();
  List<dynamic> images = [];
  var accessToken = '';
  var refreshToken = '';

  //컨트롤러가 준비되었을 때 실행 -> 초기화 작업이나 데이터 로딩과 같은 초기 설정
  @override
  void onReady() {
    super.onReady();
    _moveToPage(user.value);
    ever(user, _moveToPage); //user에 변화가 생기면 함수 실행
  }

  //유저를 새로 반환받음
  void updateUserInfo(User newUser) {
    user.value = newUser;
  }

  //User 정보에 따른 페이지 이동
  void _moveToPage(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => InitPage());
    }
  }

  //로그아웃
  void logout() {
    user.value = null;
    //로그아웃 예외처리 필요
    signupController.resetAllInputs();
  }
}
