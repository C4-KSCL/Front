// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/components/hobbyKeyword.dart';
import 'package:frontend_matching/components/mindKeyword.dart';
import 'package:frontend_matching/pages/signup/imageUpload/selectImagePage.dart';
import 'package:frontend_matching/services/friend_setting.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/textStyle.dart';
import 'package:get/get.dart';

class MyKeywordModifyPage extends StatefulWidget {
  const MyKeywordModifyPage({Key? key});

  @override
  _MyKeywordModifyPageState createState() => _MyKeywordModifyPageState();
}

class _MyKeywordModifyPageState extends State<MyKeywordModifyPage> {
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
          '내 키워드 설정하기',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.home), onPressed: () => {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () => {})
        ],
      ),
      backgroundColor: blueColor5,
      body: Column(
        children: [
          const Gap(),
          const Gap(),
          const Gap(),
          const SizedBox(
            height: 50,
            child: Text('취미 키워드', style: greyTextStyle1),
          ),
          HobbyKeyWord(
            onKeywordsSelected: (keywords) {
              selectedHobbyKeywords = keywords;
              checkElevationButtonStatus();
            },
          ),
          const SizedBox(
            height: 50,
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
                  ? () async {
                      String HobbyKeywords = selectedHobbyKeywords.join(',');
                      String MindKeywords = selectedMindKeywords.join(',');
                      String combinedKeywords =
                          HobbyKeywords + ',' + MindKeywords;
                      print(HobbyKeywords);
                      print(MindKeywords);

                      //여기에 myKeyword API 사용하기 (combinedKeywords)

                      Get.back();
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
    );
  }
}
