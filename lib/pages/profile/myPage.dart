// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_unnecessary_containers, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/pages/profile/buttons/InfoModifyButton.dart';
import 'package:frontend_matching/pages/profile/buttons/columnButton.dart';
import 'package:frontend_matching/pages/profile/imageModifyPage.dart';
import 'package:frontend_matching/pages/profile/infoModifyPage.dart';
import 'package:frontend_matching/pages/profile/topLayer.dart';
import 'package:frontend_matching/pages/profile/userAvatar.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double medWidth = MediaQuery.of(context).size.width;
    final double medHeight = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    String my_email = '';
    String my_password = '';
    String my_nickname = '';
    String my_age = '';
    String my_gender = '';
    String my_mbti = '';
    String my_profileImagePath = '';
    String my_keyword = '';
    String accesstoken = '';

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: GetBuilder<UserDataController>(builder: (controller) {
          if (controller.user.value != null) {
            accesstoken = controller.accessToken;
            my_email = controller.user.value!.email;
            my_password = controller.user.value!.password;
            my_nickname = controller.user.value!.nickname;
            my_age = controller.user.value!.age;
            my_gender = controller.user.value!.gender;
            my_mbti = controller.user.value!.myMBTI!;
            my_keyword = controller.user.value!.myKeyword!;
            if (my_gender == '0') {
              my_gender = '남';
            } else {
              my_gender = '여';
            }
            my_profileImagePath = controller.user.value!.userImage!;
            print(my_profileImagePath);
          }

          return Stack(children: [
            Positioned(
                top: medHeight / 4.1,
                child: Container(
                    height: medHeight,
                    decoration: const BoxDecoration(
                        color: Color(0xFFFCFCFF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    padding: EdgeInsets.fromLTRB(0, medHeight, medWidth, 0.0))),
            Opacity(
              opacity: 0.8,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(width: 0.5, color: Colors.grey))),
                height: statusBarHeight + 55,
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TopLayer(
                    onpressed: () {},
                    medHeight: medHeight,
                    medWidth: medWidth,
                    statusBarHeight: statusBarHeight,
                  ),
                  SizedBox(
                    height: medHeight / 10,
                  ),
                  UserAvatar(
                    img: my_profileImagePath,
                    medWidth: medWidth,
                    accessToken: accesstoken,
                    deletePath: my_profileImagePath,
                    email: my_email,
                    password: my_password,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        my_nickname,
                        style: TextStyle(
                            fontSize: 29, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.black26, width: 1),
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)))),
                          onPressed: () {},
                          child: Text(
                            my_gender,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: blueColor3),
                          ))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(medWidth / 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                //MBTI
                                my_mbti,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                //이메일
                                my_email,
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey),
                              ),
                            ),
                            Text(
                              //나이
                              my_age + '살',
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                //keyword
                                my_keyword,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InfoModifyButton(
                                medHeight: medHeight,
                                medWidth: medWidth,
                                pressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InfoModifyPage(),
                                    ),
                                  );
                                },
                                img: 'assets/icons/profile_modify.svg',
                                str: '내 정보 수정하기'),
                            InfoModifyButton(
                                medHeight: medHeight,
                                medWidth: medWidth,
                                pressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageModifyPage(),
                                    ),
                                  );
                                },
                                img: 'assets/icons/image_modify.png',
                                str: '내 사진 수정하기'),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(medWidth / 55),
                          child: const Opacity(
                              opacity: 0.6,
                              child: Divider(
                                  color: Colors.blueGrey, thickness: 0.5)),
                        ),
                        ColumnButton(
                            pressed: () {},
                            img: 'assets/icons/setting_button.png',
                            str: '환경설정'),
                        ColumnButton(
                            pressed: () {},
                            img: 'assets/icons/customer_center.png',
                            str: '고객센터'),
                        ColumnButton(
                            pressed: () {},
                            img: 'assets/icons/delete_member.png',
                            str: '탈퇴하기'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]);
        })));
  }
}
