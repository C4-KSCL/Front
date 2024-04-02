import 'package:flutter/material.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/textStyle.dart';
import 'package:get/get.dart';

Widget ButtonLayer() {
  return Container(
    width: 320,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.3),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 150,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: blueColor1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 둥근 모서리의 반지름
              ),
            ),
            onPressed: () {
              //친구 수락
            },
            child: const Text(
              "수락",
              style: blackTextStyle2,
            ),
          ),
        ),
        SizedBox(
          width: 150,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: pinkColor1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 둥근 모서리의 반지름
              ),
            ),
            onPressed: () {
              //친구 거절
            },
            child: const Text(
              "거절",
              style: blackTextStyle2,
            ),
          ),
        ),
      ],
    ),
  );
}
