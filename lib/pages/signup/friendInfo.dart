// ignore_for_file: prefer_const_constructors, must_be_immutable, unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/components/genderButton.dart';
import 'package:frontend_matching/components/textformField.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/pages/init_page.dart';
import 'package:frontend_matching/pages/signup/imageUpload/profileImagePage.dart';
import 'package:frontend_matching/pages/signup/imageUpload/selectImagePage.dart';
import 'package:frontend_matching/pages/signup/schoolAuth.dart';
import 'package:get/get.dart';
// ignore_for_file: unused_import
import 'package:http/http.dart' as http;

import '../login/loginPage.dart';

Future<void> registerUser(
  String email,
  String password,
  String nickname,
  String phoneNumber,
  String age,
  String gender,
  String myMBTI,
  String myKeyword,
  String friendMBTI,
  String friendKeyword,
  String friendMaxAge,
  String friendMinAge,
  String friendGender,
) async {
  final Uri url = Uri.parse('http://15.164.245.62:8000/signup/register');

  try {
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
        'nickname': nickname,
        'phoneNumber': phoneNumber,
        'age': age,
        'gender': gender,
        'myMBTI': myMBTI,
        'myKeyword': myKeyword,
        'friendMBTI': friendMBTI,
        'friendKeyword': friendKeyword,
        'friendMaxAge': friendMaxAge,
        'friendMinAge': friendMinAge,
        'friendGender': friendGender,
      },
    );

    if (response.statusCode == 200) {
      print('회원가입 성공!');
    } else if (response.statusCode == 401) {
      print('중복된 이메일입니다. 비밀번호 찾기를 이용하세요.');
    } else {
      print('서버 에러: ${response.statusCode}');
    }
  } catch (e) {
    print('에러 발생: $e');
  }
}

class FriendInfoPage extends StatelessWidget {
  FriendInfoPage({super.key});
  final TextEditingController minageController = TextEditingController();
  final TextEditingController maxageController = TextEditingController();
  int genderInt = 10;
  String genderString = '';

  SignupController signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.home), onPressed: () => {}),
          IconButton(icon: Icon(Icons.search), onPressed: () => {})
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text(
                '친구',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Color.fromARGB(255, 212, 118, 172),
                ),
              ),
              Text(
                '정보는?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              Gap(),
              GetTextContainer(
                typeController: maxageController,
                textLogo: '',
                textType: '최대나이',
              ),
              Gap(),
              GetTextContainer(
                typeController: minageController,
                textLogo: '',
                textType: '최소나이',
              ),
              Gap(),
              Gap(),
              GenderButton(
                onGenderSelected: (selectedValue) {
                  genderInt = selectedValue; //gender 숫자값 대입
                  if (genderInt == 1) {
                    genderString = "남";
                  } else {
                    genderString = "여";
                  }
                  print(genderString);
                },
              ),
              Gap(),
              Gap(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7EA5F3),
                  minimumSize: Size(300, 50),
                ),
                onPressed: () async {
                  // signupController에(배열) 친구정보 입력값 대입
                  String minage = minageController.text;
                  String maxage = maxageController.text;

                  signupController.addToSignupArray(minage);
                  signupController.addToSignupArray(maxage);
                  signupController.addToSignupArray(genderString);

                  print(signupController.signupArray);

                  await registerUser(
                    signupController.signupArray[0],
                    signupController.signupArray[1],
                    signupController.signupArray[2],
                    signupController.signupArray[3],
                    signupController.signupArray[4],
                    signupController.signupArray[5],
                    signupController.signupArray[6],
                    signupController.signupArray[7],
                    signupController.signupArray[8],
                    signupController.signupArray[9],
                    signupController.signupArray[10],
                    signupController.signupArray[11],
                    signupController.signupArray[12],
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileImagePage(),
                    ),
                  );
                },
                child: const Text('다음으로',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
