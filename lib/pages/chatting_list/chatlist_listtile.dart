import 'package:flutter/material.dart';

import '../../theme/textStyle.dart';

ListTile ChatListTile({
  required String username,
  required String content,
  required String timestamp,
  required int readCounts,
}) {
  return ListTile(
    leading: Image.asset('lib/sample.jpg', fit: BoxFit.fill),
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
    onTap: () {},
  );
}
