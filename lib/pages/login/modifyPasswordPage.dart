import 'package:flutter/material.dart';
import 'package:frontend_matching/components/textField.dart';
import 'package:frontend_matching/components/textformField.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/pages/login/loginPage.dart';
import 'package:frontend_matching/services/find_password.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';

class ModifyPasswordPage extends StatefulWidget {
  const ModifyPasswordPage({Key? key}) : super(key: key);

  @override
  _ModifyPasswordPageState createState() => _ModifyPasswordPageState();
}

class _ModifyPasswordPageState extends State<ModifyPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  String email = '';
  String pw = '';
  String verificationCode = ''; // 인증 코드를 저장할 변수 추가
  UserDataController userDataController = Get.find<UserDataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('비밀번호 수정하기'),
        elevation: 1.0,
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        backgroundColor: blueColor3,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
        ),
      ),
      backgroundColor: blueColor5,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              child: GetTextContainer(
                typeController: emailController,
                textLogo: 'textLogo',
                textType: '학교 이메일',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
              child: GetTextContainer(
                typeController: pwController,
                textLogo: 'textLogo',
                textType: '새 비밀번호',
              ),
            ),
            SizedBox(height: 260),
            Column(
              children: [
                SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7EA5F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      email = emailController.text;
                      pw = pwController.text;
                      FindPassword.setPassword(email, pw);
                      userDataController.logout();
                    },
                    child: const Text(
                      '다음으로',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
