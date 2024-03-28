// ignore_for_file: prefer_const_constructors, invalid_use_of_protected_member, unnecessary_null_comparison, prefer_conditional_assignment

import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/pages/matching/imageSlide.dart';
import 'package:frontend_matching/pages/profile/myPage.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController sendingController = TextEditingController();
  String _inputValue = '';
  String email = '';
  String nickname = '';
  String age = '';
  String gender = '';
  String mbti = '';
  String imagePath0 = '';
  String imagePath1 = '';
  String imagePath2 = '';
  int imageCount = 0;
  List<String> validImagePaths = [];
  String profileImagePath =
      'https://matchingimage.s3.ap-northeast-2.amazonaws.com/defalut_user.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Main Page',
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
      body: SingleChildScrollView(
        child: GetBuilder<UserDataController>(builder: (controller) {
          if (controller.user.value != null) {
            email = controller.user.value!.email;
            nickname = controller.user.value!.nickname;
            age = controller.user.value!.age;
            gender = controller.user.value!.gender;
            mbti = controller.user.value!.myMBTI!;
            if (gender == '0') {
              gender = '남';
            } else {
              gender = '여';
            }
            imageCount = controller.images.length;
            profileImagePath = controller.user.value!.userImage!;
            print(profileImagePath);

            for (int i = 0; i < imageCount; i++) {
              if (controller.images[i].imagePath != null) {
                String imagePath = controller.images[i].imagePath;
                validImagePaths.add(imagePath);
                print(imagePath);
              }
            }
          }

          return Stack(
            children: [
              Column(
                children: [
                  ImageSlider(imageArray: validImagePaths),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: TextFormField(
                      controller: sendingController,
                      maxLength: 50,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: '한마디 보내기',
                        hintText: '여기에 입력하세요',
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.emoji_emotions_rounded),
                          onPressed: () {
                            //친구추가
                          },
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            _inputValue = sendingController.text;
                            print('Input value: $_inputValue');
                          },
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (String value) {
                        print('value = $value');
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 30.0,
                right: 16.0,
                child: ElevatedButton(
                  onPressed: () {
                    // 매칭 설정페이지로 이동
                  },
                  child: const Text('매칭 설정'),
                ),
              ),
              Positioned(
                bottom: 100.0,
                left: MediaQuery.of(context).size.width / 1000.0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyPage()));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent, // 위 부분은 투명하게
                          Colors.black.withOpacity(0.5), // 아래 부분은 블러 효과
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (UserDataController.to.user.value != null)
                          ClipOval(
                            child: Image.network(
                              profileImagePath,
                              width: 40, // 이미지 너비 조절
                              height: 40, // 이미지 높이 조절
                            ),
                          ),
                        const SizedBox(width: 8), // 간격 조절

                        Text(
                          email,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          age,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          mbti,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          gender,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 200,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    sendingController.dispose();
    super.dispose();
  }
}
