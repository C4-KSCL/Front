import 'package:flutter/material.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/textStyle.dart';
import 'package:get/get.dart';

class FriendProfilePage extends StatelessWidget {
  const FriendProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage("https://matchingimage.s3.ap-northeast-2.amazonaws.com/profile/1712729048538-chovy3.jpg"),
                  ),
                  Column(children: [
                    Row(
                      children: [
                        Text("닉네임"),
                        Container(
                          width: 40,
                          height: 20,
                          decoration: BoxDecoration(
                            color: blueColor1,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                              child: Text(
                                '나이',
                                style: whiteTextStyle2,
                              )),
                        ),
                      ],
                    ),
                    Text("MBTI"),
                  ],)
                ],
              ),
              IconButton(onPressed: Get.back, icon: Icon(Icons.close))
            ],
          ),
          Divider(),
          Container(
            height: 200,
            width: 200,
            color: Colors.black,
          ),
          Text("키워드칸")
        ],
      ),
    );
  }
}
