// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/hobbyKeyword.dart';
import 'package:frontend_matching/components/mindKeyword.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/pages/signup/friendInfo.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/textStyle.dart';
import 'package:get/get.dart';

class FriendKeywordPage extends StatefulWidget {
  const FriendKeywordPage({Key? key});

  @override
  _FriendKeywordPageState createState() => _FriendKeywordPageState();
}

class _FriendKeywordPageState extends State<FriendKeywordPage> {
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
              '친구는',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color.fromARGB(255, 212, 118, 172),
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
              child: Text('취미 키워드', style: greyTextStyle1),
            ),
            HobbyKeyWord(
              onKeywordsSelected: (keywords) {
                selectedHobbyKeywords = keywords;
                checkElevationButtonStatus();
              },
            ),
            SizedBox(
              height: 5,
              child: Text('성격 키워드', style: greyTextStyle1),
            ),
            MindKeyWord(
              onKeywordsSelected: (keywords) {
                selectedMindKeywords = keywords;
                checkElevationButtonStatus();
              },
            ),
            const SizedBox(height: 30),
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
                            builder: (context) => FriendInfoPage(),
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
