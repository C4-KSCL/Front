// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, use_build_context_synchronously, annotate_overrides

import 'package:flutter/material.dart';
import 'package:frontend_matching/components/customTextForm.dart';
import 'package:frontend_matching/components/textField.dart';
import 'package:frontend_matching/components/textformField.dart';
import 'package:frontend_matching/controllers/infoModifyController.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/pages/profile/myPage.dart';
import 'package:frontend_matching/pages/profile/topLayer.dart';
import 'package:frontend_matching/pages/profile/userAvatar.dart';
import 'package:frontend_matching/pages/signup/imageUpload/selectImagePage.dart';
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
        backgroundColor: Colors.white,
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
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(''),
              )),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TopLayer(
                    //   onpressed: () {},
                    //   medHeight: medHeight,
                    //   medWidth: medWidth,
                    //   statusBarHeight: statusBarHeight,
                    // ),
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
                          style: TextStyle(
                              fontSize: 29, fontWeight: FontWeight.w600),
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
                      child: GetTextContainer(
                        textLogo: '',
                        textType: '닉네임',
                        typeController: nicknameController,
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
                    Padding(
                      padding: EdgeInsets.all(medWidth / 60),
                      child: GetTextContainer(
                        textLogo: '',
                        textType: '성별',
                        typeController: genderController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(medWidth / 60),
                      child: GetTextContainer(
                        textLogo: '',
                        textType: '내 MBTI',
                        typeController: myMBTIController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(medWidth / 60),
                      child: GetTextContainer(
                        textLogo: '',
                        textType: '내 키워드',
                        typeController: myKeywordController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(medWidth / 60),
                      child: GetTextContainer(
                        textLogo: '',
                        textType: '친구 키워드',
                        typeController: friendKeywordController,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(medWidth / 60),
                        child: CustomeTextForm()),
                    Padding(
                      padding: EdgeInsets.all(medWidth / 60),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7EA5F3),
                          minimumSize: Size(300, 50),
                        ),
                        onPressed: () async {
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

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyPage(),
                            ),
                          );
                        },
                        child: const Text('다음으로',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    )
                  ]))
        ])));
  }
}
