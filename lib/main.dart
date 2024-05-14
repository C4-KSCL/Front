import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/bottomNavigationBar.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/controllers/find_friend_controller.dart';
import 'package:frontend_matching/controllers/infoModifyController.dart';
import 'package:frontend_matching/controllers/keyword_controller.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/controllers/userImageController.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/controllers/userProfileController.dart';
import 'package:frontend_matching/pages/login/loginPage.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/friend_controller.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ko_KR', null);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        popupMenuTheme: PopupMenuThemeData(
          color: greyColor3.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
        ),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(SignupController());
        Get.put(UserDataController());
        Get.put(BottomNavigationBarController());
        Get.put(UserProfileController());
        Get.put(InfoModifyController());
        Get.put(FindFriendController());
        Get.put(FriendController());
        Get.put(ChattingListController());
        Get.put(ChattingController());
        Get.put(KeywordController());
        Get.put(UserImageController());
      }),
    ),
  );
}
