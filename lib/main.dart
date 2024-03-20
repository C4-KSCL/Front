// ignore_for_file: unnecessary_import, unused_import
import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/bottomNavigationBar.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/pages/init_page.dart';
import 'package:frontend_matching/pages/login/loginPage.dart';
import 'package:frontend_matching/pages/matching/mainPage.dart';
import 'package:frontend_matching/pages/signup/friendInfo.dart';
import 'package:frontend_matching/pages/signup/imageUpload/selectImagePage.dart';
import 'package:frontend_matching/pages/signup/schoolAuth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(
    GetMaterialApp(
      home: MainPage(),
      initialBinding: BindingsBuilder(() {
        Get.put(SignupController());
        Get.put(UserDataController());
        Get.put(BottomNavigationBarController());
      }),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
