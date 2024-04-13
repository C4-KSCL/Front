import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/chatting_controller.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/services/friend_service.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/textStyle.dart';
import 'package:get/get.dart';

Widget AcceptOrRejectButtonLayer(int? friendRequestId) {
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
              FriendController.acceptFriendRequest(requestId: friendRequestId.toString());
              ChattingController.to.isChatEnabled.value=true;

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
              FriendController.rejectFriendRequest(requestId: friendRequestId.toString());
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

Widget CancelButtonLayer(int? friendRequestId) {
  return Container(
    width: 320,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.3),
      borderRadius: BorderRadius.circular(8),
    ),
    child: SizedBox(
      width: 150,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // 둥근 모서리의 반지름
          ),
        ),
        onPressed: () {
          FriendController.deleteFriendRequest(requestId: friendRequestId.toString());
        },
        child: const Text(
          "취소",
          style: blackTextStyle2,
        ),
      ),
    ),
  );
}
