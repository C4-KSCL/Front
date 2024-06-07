import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'controllers/bottomNavigationBar.dart';
import 'controllers/chatting_list_controller.dart';
import 'controllers/find_friend_controller.dart';
import 'controllers/friend_controller.dart';
import 'controllers/infoModifyController.dart';
import 'controllers/keyword_controller.dart';
import 'controllers/service_center_controller.dart';
import 'controllers/signupController.dart';
import 'controllers/userImageController.dart';
import 'controllers/userProfileController.dart';
import 'controllers/user_data_controller.dart';

class AppConfig {
  static String? baseUrl;
  static const storage = FlutterSecureStorage();

  static void load() {
    baseUrl = dotenv.env['SERVER_URL'];
  }

  static void putGetxControllerDependency() {
    Get.lazyPut(() => SignupController());
    Get.lazyPut(() => UserDataController());
    Get.lazyPut(() => FriendController());
    Get.lazyPut(() => ChattingListController());
    Get.lazyPut(() => BottomNavigationBarController());
    Get.lazyPut(() => UserProfileController());
    Get.lazyPut(() => InfoModifyController());
    Get.lazyPut(() => FindFriendController());
    Get.lazyPut(() => KeywordController());
    Get.lazyPut(() => UserImageController());
    Get.lazyPut(() => ServiceCenterController());
  }


}
