// ignore_for_file: duplicate_import, unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/textformField.dart';
import 'package:frontend_matching/components/textformVerify.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/matching/mainPage.dart';
import 'package:frontend_matching/services/user_service.dart';
import 'package:frontend_matching/signup/schoolAuth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:http/http.dart' as http;

// Future<Map<String, dynamic>?> getUserData(String email, String password) async {
//   final Uri url = Uri.parse('http://15.164.245.62:8000/auth/login');

//   try {
//     final response = await http.post(
//       url,
//       body: {
//         'email': email,
//         'password': password,
//       },
//     );

//     if (response.statusCode == 200) {
//       print('데이터 가져오기 성공!');
//       Map<String, dynamic> data = json.decode(response.body);

//       // 사용자 정보와 이미지 정보를 병합
//       Map<String, dynamic> userData = data['user'];
//       List<dynamic> images = data['images'];
//       userData['images'] = images;

//       return userData;
//     } else {
//       print('서버 에러: ${response.statusCode}');
//       return null;
//     }
//   } catch (e) {
//     print('에러 발생: $e');
//     return null;
//   }
// }

class BottomLayerLoginScreen extends StatefulWidget {
  const BottomLayerLoginScreen({super.key});

  @override
  State<BottomLayerLoginScreen> createState() => _BottomLayerLoginScreenState();
}

class _BottomLayerLoginScreenState extends State<BottomLayerLoginScreen> {
  final formkey = GlobalKey<FormState>();
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '로그인하기',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            TextformVerify(
              typeController: idController,
              textType: '이메일',
            ),

            GetTextContainer(
                typeController: pwController,
                textLogo: 'assets/images/logo1.png',
                textType: '비밀번호'),
            ////=========== 비밀번호 입력 창 컨테이너 끝 ============
            // ======== 비밀번호,아이디 찾기 버튼 ==========
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      '이메일 찾기',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline),
                    )),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      '비밀번호 찾기',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline),
                    )),
              ],
            ),
            const SizedBox(
                width: 500,
                child: Divider(color: Colors.blueGrey, thickness: 2.0)),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7EA5F3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    String email = idController.text;
                    String password = pwController.text;

                    // 데이터 전달
                    UserServices.loginUser(email, password);

                    // MyPage 클래스로 이동
                    // Get.to(() => MainPage());
                  },
                  child: const Text(
                    '로그인하기',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
            ),

            const SizedBox(
              height: 10,
            ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SchoolAuthPage()));
                  },
                  child: const Text(
                    '회원가입하기',
                    style: TextStyle(fontSize: 16, color: Color(0xFF61A6FA)),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
