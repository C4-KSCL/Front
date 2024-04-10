// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/textStyle.dart';

class GetTextContainer extends StatefulWidget {
  //logo는 이미지, type은 아이디인지 패스워드인지
  final String textLogo;
  final String textType;
  final TextEditingController typeController;

  GetTextContainer({
    required this.typeController,
    required this.textLogo,
    required this.textType,
  });

  @override
  State<GetTextContainer> createState() => _GetTextContainerState();
}

class _GetTextContainerState extends State<GetTextContainer> {
  @override
  Widget build(BuildContext context) {
    String textLogo = widget.textLogo;
    String textType = widget.textType;
    TextEditingController typeController = widget.typeController;
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //아이디 입력창 위 아이콘 및 '아이디' 텍스트
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 5,
                ),
                Text(
                  widget.textType,
                  style: const TextStyle(fontSize: 15),
                )
              ],
            ),
            // 아이디 입력 창
            Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: TextFormField(
                controller: widget.typeController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: '입력해주세요',
                  hintStyle: greyTextStyle1,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: whiteColor1, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: blueColor4, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
