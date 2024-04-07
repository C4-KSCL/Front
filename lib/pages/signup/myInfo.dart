// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/genderButton.dart';
import 'package:frontend_matching/components/textformField.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/pages/signup/myMbtiPage.dart';
import 'package:frontend_matching/pages/signup/schoolAuth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InfoAuthPage extends StatefulWidget {
  const InfoAuthPage({Key? key}) : super(key: key);

  @override
  _InfoAuthPageState createState() => _InfoAuthPageState();
}

class _InfoAuthPageState extends State<InfoAuthPage> {
  SignupController signupController = Get.find<SignupController>();

  final TextEditingController passwordController =
      TextEditingController(); //비밀번호
  final TextEditingController nicknameController =
      TextEditingController(); //닉네임
  final TextEditingController numberController = TextEditingController(); //전화번호
  final TextEditingController ageController = TextEditingController(); //나이

  // 성별 선택을 위한 변수 추가
  bool isMaleSelected = false;
  bool isFemaleSelected = false;

  int genderInt = 0;
  String genderString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('회원가입하기'),
        elevation: 1.0,
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        backgroundColor: Colors.white70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SchoolAuthPage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.home), onPressed: () => {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () => {})
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              child: GetTextContainer(
                typeController: passwordController,
                textLogo: 'textLogo',
                textType: '비밀번호',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              child: GetTextContainer(
                  typeController: nicknameController,
                  textLogo: 'textLogo',
                  textType: '닉네임'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              child: GetTextContainer(
                  typeController: numberController,
                  textLogo: 'textLogo',
                  textType: '전화번호'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              child: GetTextContainer(
                  typeController: ageController,
                  textLogo: 'textLogo',
                  textType: '나이'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('성별'),
                  GenderButton(
                    // 선택된 값 콜백 함수 - 성별 받아옴
                    onGenderSelected: (selectedValue) {
                      genderInt = selectedValue; //gender 숫자값 대입
                      if (genderInt == 1) {
                        genderString = "남";
                      } else {
                        genderString = "여";
                      }
                      print(genderString);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7EA5F3),
                minimumSize: Size(300, 50),
              ),
              onPressed: () {
                // signupController에(배열) 회원정보 입력값 대입
                String password = passwordController.text;
                String nickname = nicknameController.text;
                String phoneNumber = numberController.text;

                String age = ageController.text;

                signupController.addToSignupArray(password);
                signupController.addToSignupArray(nickname);
                signupController.addToSignupArray(phoneNumber);
                signupController.addToSignupArray(age);
                signupController.addToSignupArray(genderString);

                print(signupController.signupArray);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyMbtiPage(),
                  ),
                );
              },
              child: const Text('다음으로',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
