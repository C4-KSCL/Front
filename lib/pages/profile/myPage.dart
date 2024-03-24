import 'package:flutter/material.dart';
import 'package:frontend_matching/pages/matching/mainPage.dart';
import 'package:frontend_matching/pages/profile/buttons/columnButton.dart';
import 'package:frontend_matching/pages/profile/buttons/rowButton.dart';
import 'package:frontend_matching/pages/profile/topLayer.dart';
import 'package:frontend_matching/pages/profile/userAvatar.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double medWidth = MediaQuery.of(context).size.width;
    final double medHeight = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final mainPage = MainPage();

    return Scaffold(
        backgroundColor: const Color(0xFFFCFCFF),
        body: SingleChildScrollView(
            child: Stack(children: [
          const Image(image: AssetImage('assets/logo/login_image.png')),
          Positioned(
              top: medHeight / 3.5,
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
                  img: MainPage.profileImagePath,
                  medWidth: medWidth,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '닉네임',
                      style:
                          TextStyle(fontSize: 29, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.blue, width: 1),
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)))),
                        onPressed: () {},
                        child: const Text(
                          '정보수정',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
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
                          RowButton(
                              medHeight: medHeight,
                              medWidth: medWidth,
                              pressed: () {},
                              img: 'assets/logos/dropbox-fill.png',
                              str: '맡긴 내역'),
                          RowButton(
                              medHeight: medHeight,
                              medWidth: medWidth,
                              pressed: () {},
                              img: 'assets/map/truck-fill.png',
                              str: '옮긴 내역'),
                          RowButton(
                              medHeight: medHeight,
                              medWidth: medWidth,
                              pressed: () {},
                              img: 'assets/health/heart-fill.png',
                              str: '관심 내역')
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
                          img: 'assets/communication/chat-quote-fill.png',
                          str: '내가 쓴 댓글'),
                      ColumnButton(
                          pressed: () {},
                          img: 'assets/communication/chat-quote-fill.png',
                          str: '내가 쓴 댓글'),
                      ColumnButton(
                          pressed: () {},
                          img: 'assets/communication/chat-quote-fill.png',
                          str: '내가 쓴 댓글'),
                      ColumnButton(
                          pressed: () {},
                          img: 'assets/communication/chat-quote-fill.png',
                          str: '내가 쓴 댓글'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ])));
  }
}
