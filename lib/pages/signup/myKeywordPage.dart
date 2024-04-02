// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/personalKeyword.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/pages/signup/friendMbtiPage.dart';
import 'package:frontend_matching/pages/signup/schoolAuth.dart';
import 'package:get/get.dart';

class MyKeywordPage extends StatefulWidget {
  const MyKeywordPage({Key? key});

  @override
  _MyKeywordPageState createState() => _MyKeywordPageState();
}

class _MyKeywordPageState extends State<MyKeywordPage> {
  SignupController signupController = Get.find<SignupController>();
  List<String> selectedKeywords = [];
  bool isElevationButtonEnabled = false; // ElevationButton 활성/비활성 상태

  // ElevationButton 활성/비활성 여부를 체크하는 함수
  void checkElevationButtonStatus() {
    setState(() {
      isElevationButtonEnabled = selectedKeywords.isNotEmpty;
    });
  }

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
              '나는',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0xFF7EA5F3),
              ),
            ),
            Text(
              '어떤 사람일까요?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            // PersonalKeyWord를 사용할 때, 콜백 함수를 전달
            PersonalKeyWord(
              onKeywordsSelected: (keywords) {
                selectedKeywords = keywords;
                checkElevationButtonStatus();
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7EA5F3),
                minimumSize: const Size(300, 50),
              ),
              onPressed: isElevationButtonEnabled
                  ? () {
                      debugPrint('Final Selected Keywords: $selectedKeywords');
                      String combinedKeywords = selectedKeywords.join(',');
                      print(combinedKeywords);
                      signupController.addToSignupArray(combinedKeywords);
                      print(signupController.signupArray);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FriendMbtiPage(),
                        ),
                      );
                    }
                  : null, // 버튼이 비활성 상태일 때는 null로 설정
              child: const Text(
                '다음으로',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
