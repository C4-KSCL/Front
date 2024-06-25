// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/mbtiKeyword.dart';
import 'package:frontend_matching/controllers/keyword_controller.dart';
import 'package:frontend_matching/controllers/signup_controller.dart';
import 'package:frontend_matching/pages/signup/my_info_page.dart';
import 'package:frontend_matching/pages/signup/my_keyword_page.dart';
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
          'mbti',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        backgroundColor: blueColor3,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            for (int i = 0; i < 5; i++) {
              signupController.deleteToSignupArray();
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InfoAuthPage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () => {}),
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () => {})
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
            MbtiKeyWord(
              title: 'mbti',
              onMbtiSelected: (String mbti) {
                setState(() {
                  selectedMBTI = mbti;
                  if (selectedMBTI.length == 4) {
                    isMbtiComplete = true;
                  } else {
                    isMbtiComplete = false;
                  }
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
