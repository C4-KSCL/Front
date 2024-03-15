import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';

Widget RecommendedFriendFormat({
  required String userNickname,
  required int userAge,
  required String userMbti,
  //List<UserImage>? userImages,
}) {
  TextEditingController _messageController = TextEditingController();

  return Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 520,
          child: PageIndicatorContainer(
            length: 2, //페이지 개수 이미지 배열 길이로 정해야함
            child: PageView(
              children: [
                // 이미지 들어가는 곳
                Container(
                  width: 300,
                  height: 300,
                  color: Colors.black,
                  child: Image.asset("assets/images/profile3.jpg"),
                ),
                Container(
                  width: 300,
                  height: 300,
                  color: Colors.white,
                  child: Image.asset("assets/images/profile1.jpg"),
                ),
                // Container(
                //   width: 300,
                //   height: 300,
                //   child: userImages != null ? Image.network(userImages[0].imagePath.toString()) : Icon(Icons.person),
                // ),
                // Container(
                //   width: 300,
                //   height: 300,
                //   child: userImages != null ? Image.network(userImages[1].imagePath.toString()) : Icon(Icons.person),
                // ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              userNickname,
              style: TextStyle(),
            ),
            Container(
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                  child: Text(
                '$userAge세',
                style: TextStyle(),
              )),
            ),
            Text(
              userMbti,
              style: TextStyle(),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        IconTextFieldBox(
            hintText: '간단하게 인사를 해봐요',
            onPressed: () {},
            textEditingController: _messageController)
      ],
    ),
  );
}

// 메인 화면 하단 채팅 보내는 텍스트필드
Container IconTextFieldBox({
  required TextEditingController textEditingController,
  required String hintText,
  required VoidCallback onPressed,
}) {
  return Container(
    height: 65,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 5.0,
          spreadRadius: 1.0,
          offset: const Offset(5, 5), // 그림자의 위치
        ),
      ],
    ),
    child: TextField(
      style: TextStyle(),
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              onPressed();
            },
            icon: Icon(
              Icons.send,
              color: Colors.blue,
            ),
          )),
      controller: textEditingController,
    ),
  );
}

class test extends StatelessWidget {
  const test({Key? key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            RecommendedFriendFormat(
              userNickname: 'UserNickname',
              userAge: 25,
              userMbti: 'MBTI',
            ),
            IconTextFieldBox(
              textEditingController: _controller,
              hintText: 'Enter your message...',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
