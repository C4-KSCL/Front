import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/textStyle.dart';


ListTile ChatListTile({
  required String username,
  required String content,
  required String timestamp,
  required int readCounts,
}) {
  return ListTile(
    leading: Image.asset('assets/images/profile1.jpg', fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: blackTextStyle1,
        ),
        Text(
          content,
          style: greyTextStyle3,
        ),
      ],
    ),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          timestamp,
          style: greyTextStyle4,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(7)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Text(readCounts.toString()),
          ),
        ),
      ],
    ),
    onTap: () {
    },
  );
}

ListTile FriendListTile({
  required String username,
  required String content,
}) {
  return ListTile(
    leading: Image.asset('assets/images/profile1.jpg', fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: blackTextStyle1,
        ),
        Text(
          content,
          style: greyTextStyle3,
        ),
      ],
    ),
    trailing: TextButton(
      onPressed: () {},
      child: Text("채팅방 입장 or 메모 기능"),
    ),
    onTap: () {},
  );
}

ListTile ReceivedRequest({
  required String username,
  required String content,
}) {
  return ListTile(
    leading: Image.asset('assets/images/profile1.jpg', fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: blackTextStyle1,
        ),
        Text(
          content,
          style: greyTextStyle3,
        ),
      ],
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () {  },
          child: Text('수락'),
        ),
        TextButton(
          onPressed: () {  },
          child: Text('거절'),
        ),
      ],
    ),
    onTap: () {},
  );
}

ListTile SendedRequest({
  required String username,
  required String content,
}) {
  return ListTile(
    leading: Image.asset('assets/images/profile1.jpg', fit: BoxFit.fill),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: blackTextStyle1,
        ),
        Text(
          content,
          style: greyTextStyle3,
        ),
      ],
    ),
    trailing: TextButton(
      onPressed: () {  },
      child: Text('취소'),
    ),
    onTap: () {},
  );
}
