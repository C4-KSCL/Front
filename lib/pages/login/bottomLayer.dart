// ignore_for_file: duplicate_import, unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/loginTextForm.dart';
import 'package:frontend_matching/components/loginVerifyTextForm.dart';
import 'package:frontend_matching/components/textformField.dart';
import 'package:frontend_matching/components/textformVerify.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/pages/matching/mainPage.dart';
import 'package:frontend_matching/services/user_service.dart';
import 'package:frontend_matching/pages/signup/schoolAuth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:http/http.dart' as http;

class BottomLayerLoginScreen extends StatefulWidget {
  const BottomLayerLoginScreen({super.key});

  @override
  State<BottomLayerLoginScreen> createState() => _BottomLayerLoginScreenState();
}

class _BottomLayerLoginScreenState extends State<BottomLayerLoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      padding: const EdgeInsets.all(20),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '로그인',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            LoginVerifyTextform(
              typeController: idController,
              textType: '이메일',
            ),
            LoginTextForm(
                typeController: pwController, textLogo: '', textType: '비밀번호'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      '이메일 찾기',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline),
                    )),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      '비밀번호 찾기',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline),
                    )),
              ],
            ),
            const SizedBox(
                width: 500,
                child: Divider(color: Colors.blueGrey, thickness: 2.0)),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7EA5F3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    String email = idController.text;
                    String password = pwController.text;
                    print("login check");

                    UserServices.loginUser(email, password);
                    //로컬에 저장된 매칭데이터가 없으면, 자동으로 매칭 한번 시키는 로직
                  },
                  child: const Text(
                    '로그인하기',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SchoolAuthPage()));
                  },
                  child: const Text(
                    '회원가입하기',
                    style: TextStyle(fontSize: 16, color: Color(0xFF61A6FA)),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
