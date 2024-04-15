
import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/bottomNavigationBar.dart';
import 'package:frontend_matching/controllers/findFriendController.dart';
import 'package:frontend_matching/controllers/infoModifyController.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/controllers/userProfileController.dart';
import 'package:frontend_matching/pages/init_page.dart';
import 'package:frontend_matching/pages/login/loginPage.dart';
import 'package:frontend_matching/pages/matching/mainPage.dart';
import 'package:frontend_matching/pages/profile/myPage.dart';
import 'package:frontend_matching/pages/signup/friendInfo.dart';
import 'package:frontend_matching/pages/signup/imageUpload/profileImagePage.dart';
import 'package:frontend_matching/pages/signup/imageUpload/selectImagePage.dart';
import 'package:frontend_matching/pages/signup/schoolAuth.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  runApp(
    GetMaterialApp(
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
      }),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
