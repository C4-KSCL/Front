// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';

class HobbyKeyWord extends StatefulWidget {
  final Function(List<String>) onKeywordsSelected;

  HobbyKeyWord({Key? key, required this.onKeywordsSelected}) : super(key: key);

  @override
  _HobbyKeyWordState createState() => _HobbyKeyWordState();
}

class _HobbyKeyWordState extends State<HobbyKeyWord> {
  SignupController signupController = Get.find<SignupController>();
  final controller = GroupButtonController(selectedIndex: 20);
  List<String> selectedKeywords = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Center(
          child: Column(
            children: [
              GroupButton(
                controller: controller,
                isRadio: false,
                buttons: [
                  "야구",
                  "축구",
                  "농구",
                  "당구",
                  "배드민턴",
                  "책읽기",
                  "노래방가기",
                ],
                onSelected: (keyword, i, selected) {
                  setState(() {
                    if (selected) {
                      selectedKeywords.add(keyword);
                    } else {
                      selectedKeywords.remove(keyword);
                    }
                  });
                  debugPrint('Selected Keywords: $selectedKeywords');
                  widget.onKeywordsSelected(selectedKeywords);
                },
                options: GroupButtonOptions(
                  selectedTextStyle: const TextStyle(
                    color: Colors.white, // 선택된 텍스트 색상
                  ),
                  selectedColor: blueColor1, // 선택된 버튼 배경 색상
                  unselectedColor: Colors.white, // 선택되지 않은 버튼 배경 색상
                  unselectedTextStyle: const TextStyle(
                    color: blueColor1, // 선택되지 않은 텍스트 색상
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(
                height: 110,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
