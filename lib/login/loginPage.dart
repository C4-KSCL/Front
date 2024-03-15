// ignore: file_names
import 'package:flutter/material.dart';
import 'package:frontend_matching/login/bottomLayer.dart';
import 'package:frontend_matching/login/topLayer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final medHeight = MediaQuery.of(context).size.height;
    final medWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      //backgroundColor: Colors.black,
      // GestureDetector는 텍스트 필드의 포커스를 풀어주기 위해서 사용됨.
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 로그인 창 상위 컨테이너
              TopLayerInLoginScreen(imgWidth: medWidth, imgHeight: medHeight),
              //로그인 창 하위 컨테이너
              BottomLayerLoginScreen()
            ],
          ),
        ),
      ),
    );
  }
}
