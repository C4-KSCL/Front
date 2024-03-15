import 'package:flutter/material.dart';

import '../friend/friend_and_request_listtile.dart';

class ChattingListPage extends StatelessWidget {
  const ChattingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("채팅리스트"),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
              ],
            )
          ],
        ),
      ),
      body: ListView.separated(
        itemCount: 3,
        itemBuilder: (context, index) {
          return ChatListTile(
              username: "aaa", content: "A", timestamp: "a", readCounts: 3);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
      // Container(child: Text("aa"),),
    );
  }
}
