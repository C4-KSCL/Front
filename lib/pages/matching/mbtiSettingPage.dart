import 'package:flutter/material.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/components/genderButton.dart';
import 'package:frontend_matching/components/mbtiKeyword.dart';
import 'package:frontend_matching/components/textField.dart';
import 'package:frontend_matching/controllers/keyword_controller.dart';
import 'package:frontend_matching/controllers/settingModifyController.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/pages/matching/keywordSettingPage.dart';
import 'package:frontend_matching/services/friend_setting.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MbtiSettingPage extends StatefulWidget {
  const MbtiSettingPage({super.key});

  @override
  State<MbtiSettingPage> createState() => _MbtiSettingPageState();
}

class _MbtiSettingPageState extends State<MbtiSettingPage> {
  final TextEditingController sendingController = TextEditingController();
  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController maxAgeController = TextEditingController();
  final pageController = PageController();

  String accessToken = '';
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

  String selectedMBTI = '';
  int genderInt = 10;
  String genderString = '';

  late SettingModifyController settingModifyController;
  FriendSettingService settingService = FriendSettingService();

  @override
  void initState() {
    super.initState();
    settingModifyController = Get.put(SettingModifyController());
    final controller = Get.find<UserDataController>();
    if (controller.user.value != null) {
      accessToken = controller.accessToken;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          IconButton(icon: const Icon(Icons.home), onPressed: () => {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () => {})
        ],
      ),
      backgroundColor: blueColor5,
      body: SingleChildScrollView(
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Gap(),
            Row(
              children: [
                const Text(
                  '    이상형 설정하기',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 27),
                ),
                const SizedBox(width: 100),
                IconButton(
                  icon: const Icon(
                    Icons.double_arrow_rounded,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KeywordSettingPage(),
                      ),
                    );
                  },
                )
              ],
            ),
            const Gap(),
            Row(
              children: [
                const SizedBox(width: 50),
                GenderButton(
                  onGenderSelected: (selectedValue) {
                    genderInt = selectedValue;
                    if (genderInt == 1) {
                      genderString = "남";
                    } else {
                      genderString = "여";
                    }
                    print(genderString);
                  },
                ),
              ],
            ),
            const Gap(),
            MbtiKeyWord(
              title: 'mbti',
              onMbtiSelected: (String mbti) {
                selectedMBTI = mbti;
              },
            ),
            Row(
              children: [
                NumberInputField(
                  controller: minAgeController,
                  hintText: UserDataController.to.user.value!.friendMinAge!,
                ),
                const Icon(Icons.remove),
                NumberInputField(
                  controller: maxAgeController,
                  hintText: UserDataController.to.user.value!.friendMaxAge!,
                ),
              ],
            ),
            const Gap(),
            const Gap(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7EA5F3),
                  minimumSize: const Size(300, 50),
                ),
                child: const Text('변경',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onPressed: () async {
                  settingModifyController.addToSettingArray(selectedMBTI);
                  settingModifyController
                      .addToSettingArray(maxAgeController.text);
                  settingModifyController
                      .addToSettingArray(minAgeController.text);
                  settingModifyController.addToSettingArray(genderString);
                  print(settingModifyController);

                  await FriendSettingService.updateFriendMbtiSetting(
                    accessToken,
                    selectedMBTI,
                    maxAgeController.text,
                    minAgeController.text,
                    genderString,
                  );
                  KeywordController.to.resetMBTI();
                  print(selectedMBTI);
                  Get.back();
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
