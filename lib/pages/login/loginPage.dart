// ignore: file_names
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend_matching/config.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/pages/login/bottomLayer.dart';
import 'package:frontend_matching/services/fcm_token_service.dart';
import 'package:get/get.dart';

import '../../controllers/chatting_list_controller.dart';
import '../../controllers/friend_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  void _checkAutoLogin() async {
    // 자동 로그인 여부 확인
    String? isAutoLogin = await AppConfig.storage.read(key: "isAutoLogin");
    // 자동 로그인이 설정된 경우
    if (isAutoLogin == "true") {
      print("자동 로그인 한적 있음");
      String? email = await AppConfig.storage.read(key: "autoLoginEmail");
      String? password = await AppConfig.storage.read(key: "autoLoginPw");
      if (email != null && password != null) {
        await UserDataController.loginUser(email, password);
        // 로그인 후의 UI 업데이트나 다른 처리
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/brand.png',
              fit: BoxFit.cover, // 전체 화면으로 배경 함
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6, //하단 높이
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: const BottomLayerLoginScreen(),
            ),
          ),
        ],
      ),
    );
  }
}
