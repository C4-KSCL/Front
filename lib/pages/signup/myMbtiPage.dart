// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/mbtiKeyword.dart';
import 'package:frontend_matching/controllers/keyword_controller.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/pages/signup/myKeywordPage.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';

class MyMbtiPage extends StatefulWidget {
  const MyMbtiPage({Key? key}) : super(key: key);

  @override
  _MyMbtiPageState createState() => _MyMbtiPageState();
}

class _MyMbtiPageState extends State<MyMbtiPage> {
  SignupController signupController = Get.find<SignupController>();
  String selectedMBTI = "";
  bool isMbtiComplete = false; // 버튼 활성화 관련

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
      backgroundColor: blueColor5,
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
                  isMbtiComplete = selectedMBTI.length == 4;
                });
              },
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7EA5F3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: isMbtiComplete
                    ? () {
                        // 사용할 때 selectedMBTI를 사용합니다.
                        signupController.addToSignupArray(selectedMBTI);
                        print(signupController.signupArray);
                        KeywordController.to.resetMBTI();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyKeywordPage(),
                          ),
                        );
                      }
                    : null,
                child: const Text('다음으로',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
