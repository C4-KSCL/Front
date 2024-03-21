import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/colors.dart';
import '../../theme/textStyle.dart';

Widget SendTextChatBox({
  required String text,
}){
  return Container(
    constraints: BoxConstraints(
        maxWidth: Get.width * 0.75),
    decoration: const BoxDecoration(
      color: blueColor1,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: whiteTextStyle2,
      ),
    ),
  );
}

Widget ReceiveTextChatBox({
  required String text,
}){
  return Container(
    constraints: BoxConstraints(
      maxWidth: Get.width * 0.75,
    ),
    decoration: const BoxDecoration(
      color: greyColor3,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: blackTextStyle4,
      ),
    ),
  );
}