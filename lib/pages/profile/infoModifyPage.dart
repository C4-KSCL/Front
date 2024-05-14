// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, use_build_context_synchronously, annotate_overrides

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/textField.dart';
import 'package:frontend_matching/components/textformField.dart';
import 'package:frontend_matching/controllers/infoModifyController.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/pages/profile/buttons/InfoModifyButton.dart';
import 'package:frontend_matching/pages/profile/myKeywordModifyPage.dart';
import 'package:frontend_matching/pages/profile/myMbtiModifyPage.dart';
import 'package:frontend_matching/pages/profile/userAvatar.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';

class InfoModifyPage extends StatefulWidget {
  const InfoModifyPage({Key? key}) : super(key: key);

  @override
  _InfoModifyPageState createState() => _InfoModifyPageState();
}

class _InfoModifyPageState extends State<InfoModifyPage> {
  late InfoModifyController infoModifyController;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController myMBTIController = TextEditingController();
  final TextEditingController myKeywordController = TextEditingController();
  final TextEditingController friendKeywordController = TextEditingController();
  String my_email = '';
  String my_password = '';
  String my_nickname = '';
  String my_phoneNumber = '';
  String my_age = '';
  String my_gender = '';
  String my_mbti = '';
  String my_keyword = '';
  String friend_keyword = '';
  String my_profileImagePath = '';
  String accessToken = '';
  String refreshToken = '';

  @override
  void initState() {
    super.initState();
    infoModifyController = Get.find<InfoModifyController>();
    final controller = Get.find<UserDataController>();

    if (controller.user.value != null) {
      accessToken = controller.accessToken;
      refreshToken = controller.refreshToken;
      my_email = controller.user.value!.email;
      my_password = controller.user.value!.password;
      my_nickname = controller.user.value!.nickname;
      my_phoneNumber = controller.user.value!.phoneNumber;
      my_age = controller.user.value!.age;
      my_gender = controller.user.value!.gender;
      my_mbti = controller.user.value!.myMBTI!;
      my_keyword = controller.user.value!.myKeyword!;
      friend_keyword = controller.user.value!.friendKeyword!;
      if (my_gender == '0') {
        my_gender = '남';
      } else {
        my_gender = '여';
      }
      my_profileImagePath = controller.user.value!.userImage!;

      passwordController.text = my_password;
      nicknameController.text = my_nickname;
      phoneNumberController.text = my_phoneNumber;
      ageController.text = my_age;
      genderController.text = my_gender;
      myMBTIController.text = my_mbti;
      myKeywordController.text = my_keyword;
      friendKeywordController.text = friend_keyword;
    }
  }

  Widget build(BuildContext context) {
    final double medWidth = MediaQuery.of(context).size.width;
    final double medHeight = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('사진 수정하기'),
        ),
        backgroundColor: blueColor5,
        body: SingleChildScrollView(
            child: Stack(children: [
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
            color: blueColor5,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: medHeight / 10,
              ),
              UserAvatar(
                img: my_profileImagePath,
                medWidth: medWidth,
                accessToken: accessToken,
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
                    style: TextStyle(fontSize: 29, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(medWidth / 60),
                child: GetTextContainer(
                  textLogo: '',
                  textType: '비밀번호',
                  typeController: passwordController,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(medWidth / 60),
                child: ButtonTextFieldBox(
                  hintText: '입력하세요',
                  onPressed: () {}, //닉네임 인증 로직 필요
                  textEditingController: nicknameController,
                  buttonText: '인증하기',
                  TEXT: '닉네임',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(medWidth / 60),
                child: GetTextContainer(
                  textLogo: '',
                  textType: '전화번호',
                  typeController: phoneNumberController,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(medWidth / 60),
                child: GetTextContainer(
                  textLogo: '',
                  textType: '나이',
                  typeController: ageController,
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 15),
                  InfoModifyButton(
                      medHeight: medHeight,
                      medWidth: medWidth,
                      pressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyMbtiModifyPage(),
                          ),
                        );
                      },
                      img: 'assets/images/mbti.png',
                      str: '내 MBTI 수정하기'),
                  InfoModifyButton(
                      medHeight: medHeight,
                      medWidth: medWidth,
                      pressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyKeywordModifyPage(),
                          ),
                        );
                      },
                      img: 'assets/images/keyword.jpeg',
                      str: '내 키워드 수정하기'),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.all(medWidth / 60),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7EA5F3),
                    minimumSize: Size(300, 50),
                  ),
                  onPressed: () async {
                    // 여기 api 수정해야함
                    String password = passwordController.text;
                    String nickname = nicknameController.text;
                    String phoneNumber = phoneNumberController.text;
                    String age = ageController.text;
                    String gender = genderController.text;
                    String mbti = myMBTIController.text;
                    String keyword = myKeywordController.text;
                    String f_keyword = friendKeywordController.text;

                    await infoModifyController.InfoModify(
                      accessToken,
                      refreshToken,
                      password,
                      nickname,
                      phoneNumber,
                      age,
                      gender,
                      mbti,
                      keyword,
                      f_keyword,
                    );

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('정보 수정'),
                          content: Text('정보가 수정되었습니다.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('다음으로',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ]),
          ),
        ])));
  }
}
