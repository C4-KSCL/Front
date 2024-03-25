// ignore: file_names
import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/login/bottomLayer.dart';
import 'package:frontend_matching/pages/login/topLayer.dart';

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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TopLayerInLoginScreen(imgWidth: medWidth, imgHeight: medHeight),
              BottomLayerLoginScreen()
            ],
          ),
        ),
      ),
    );
  }
}
