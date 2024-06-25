import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_matching/config.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/pages/login/bottomLayer.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import '../../controllers/bottomNavigationBar.dart';
import '../chatting_room/chatting_room_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/brand.png',
              fit: BoxFit.cover, // 전체 화면으로 배경
            ),
          ),
          Positioned.fill(
            bottom: Get.height / 2,
            child: ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                  ),
                ),
              ),
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
