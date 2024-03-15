// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend_matching/signup/schoolAuth.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';

class PersonalKeyWord extends StatefulWidget {
  // 콜백 함수를 받을 변수 추가
  final Function(List<String>) onKeywordsSelected;

  PersonalKeyWord({Key? key, required this.onKeywordsSelected})
      : super(key: key);

  @override
  _PersonalKeyWordState createState() => _PersonalKeyWordState();
}

class _PersonalKeyWordState extends State<PersonalKeyWord> {
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
                  "운동광",
                  "잠꾸러기",
                  "먹보",
                  "운동광",
                  "잠꾸러기",
                  "먹보",
                  "운동광",
                  "잠꾸러기",
                  "먹보",
                  "운동광",
                  "잠꾸러기",
                  "먹보",
                  "운동광",
                  "잠꾸러기",
                  "먹보",
                  "우동추d",
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
