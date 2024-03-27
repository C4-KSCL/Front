// ignore: file_names
import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/login/bottomLayer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // final medHeight = MediaQuery.of(context).size.height;
    // final medWidth = MediaQuery.of(context).size.width;
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
              height: MediaQuery.of(context).size.height * 0.56, //하단 높이
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
