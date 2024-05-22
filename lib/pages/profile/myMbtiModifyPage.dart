import 'package:flutter/material.dart';
import 'package:frontend_matching/components/gap.dart';
import 'package:frontend_matching/components/mbtiKeyword.dart';
import 'package:frontend_matching/controllers/infoModifyController.dart';
import 'package:frontend_matching/controllers/keyword_controller.dart';
import 'package:frontend_matching/controllers/settingModifyController.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/services/friend_setting.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';

class MyMbtiModifyPage extends StatefulWidget {
  const MyMbtiModifyPage({super.key});

  @override
  State<MyMbtiModifyPage> createState() => _MyMbtiModifyPageState();
}

class _MyMbtiModifyPageState extends State<MyMbtiModifyPage> {
  final TextEditingController sendingController = TextEditingController();
  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController maxAgeController = TextEditingController();
  final pageController = PageController();

  String accessToken = '';

  String selectedMBTI = '';
  //String genderString = '';

  late SettingModifyController settingModifyController;
  final infocontroller = Get.find<InfoModifyController>();
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
            const Row(
              children: [
                Text(
                  '    이상형 설정하기',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 27),
                ),
                SizedBox(width: 100),
              ],
            ),
            const Gap(),
            const Gap(),
            MbtiKeyWord(
              title: 'mbti',
              onMbtiSelected: (String mbti) {
                selectedMBTI = mbti;
              },
            ),
            const Gap(),
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
                    await infocontroller.MbtiModify(selectedMBTI);
                    KeywordController.to.resetMBTI();
                    print(selectedMBTI);
                    Get.back();
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}
