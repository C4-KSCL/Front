// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/mbtiKeyword.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/pages/signup/myKeywordPage.dart';
import 'package:frontend_matching/pages/signup/schoolAuth.dart';
import 'package:get/get.dart';

class MyMbtiPage extends StatefulWidget {
  const MyMbtiPage({Key? key}) : super(key: key);

  @override
  _MyMbtiPageState createState() => _MyMbtiPageState();
}

class _MyMbtiPageState extends State<MyMbtiPage> {
  SignupController signupController = Get.find<SignupController>();
  String selectedMBTI = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.home), onPressed: () => {}),
          IconButton(icon: Icon(Icons.search), onPressed: () => {})
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Text(
              '나의',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0xFF7EA5F3),
              ),
            ),
            Text(
              'MBTI는요?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            // MbtiKeyWord 위젯을 호출할 때 onMbtiSelected 함수를 정의합니다.
            MbtiKeyWord(
              title: 'mbti',
              onMbtiSelected: (String mbti) {
                setState(() {
                  selectedMBTI = mbti;
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7EA5F3),
                minimumSize: Size(300, 50),
              ),
              child: const Text('다음으로',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () {
                // 사용할 때 selectedMBTI를 사용합니다.
                signupController.addToSignupArray(selectedMBTI);
                print(signupController.signupArray);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyKeywordPage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
