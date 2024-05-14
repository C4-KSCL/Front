// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/components/hobbyKeyword.dart';
import 'package:frontend_matching/components/mindKeyword.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/pages/signup/friendMbtiPage.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/textStyle.dart';
import 'package:get/get.dart';

class MyKeywordPage extends StatefulWidget {
  const MyKeywordPage({Key? key});

  @override
  _MyKeywordPageState createState() => _MyKeywordPageState();
}

class _MyKeywordPageState extends State<MyKeywordPage> {
  SignupController signupController = Get.find<SignupController>();
  List<String> selectedHobbyKeywords = [];
  List<String> selectedMindKeywords = [];
  bool isElevationButtonEnabled = false; // ElevationButton 활성/비활성 상태

  // ElevationButton 활성/비활성 여부를 체크하는 함수
  void checkElevationButtonStatus() {
    setState(() {
      isElevationButtonEnabled =
          selectedHobbyKeywords.isNotEmpty && selectedMindKeywords.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '내 키워드',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        backgroundColor: blueColor3,
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
            Gap(),
            SizedBox(
              height: 30,
              child: Text('취미 키워드', style: greyTextStyle1),
            ),
            HobbyKeyWord(
              onKeywordsSelected: (keywords) {
                selectedHobbyKeywords = keywords;
                checkElevationButtonStatus();
              },
            ),
            SizedBox(
              height: 30,
              child: Text('성격 키워드', style: greyTextStyle1),
            ),
            MindKeyWord(
              onKeywordsSelected: (keywords) {
                selectedMindKeywords = keywords;
                checkElevationButtonStatus();
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7EA5F3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: isElevationButtonEnabled
                    ? () {
                        String HobbyKeywords = selectedHobbyKeywords.join(',');
                        String MindKeywords = selectedMindKeywords.join(',');
                        String combinedKeywords =
                            HobbyKeywords + ',' + MindKeywords;
                        print(HobbyKeywords);
                        print(MindKeywords);
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
            ),
          ],
        ),
      ),
    );
  }
}
