// ignore_for_file: avoid_unnecessary_containers, unnecessary_const

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:frontend_matching/models/userImage.dart';
import 'package:frontend_matching/pages/signup/imageUpload/selectImagePage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageModifyPage extends StatefulWidget {
  const ImageModifyPage({Key? key}) : super(key: key);

  @override
  State<ImageModifyPage> createState() => _ImageModifyPageState();
}

class _ImageModifyPageState extends State<ImageModifyPage> {
  final ImagePicker picker = ImagePicker();
  List<String> imagePathURL = [];
  List<XFile> xfilePathURL = [];
  String accessToken = '';
  int imageCount = 0;

  @override
  void initState() {
    super.initState();
    final UserDataController controller = Get.find<UserDataController>();
    if (controller.user.value != null) {
      accessToken = controller.accessToken;
      print(accessToken);
      print('컨트롤러 안의 $accessToken');
      imageCount = controller.images.length;

      for (int i = 0; i < imageCount; i++) {
        if (controller.images[i].imagePath != null) {
          String imagePath = controller.images[i].imagePath;
          imagePathURL.add(imagePath);
        }
      }
      print(imagePathURL);
    } else {
      print('사진이 없습니다.');
    }
  }

  Future<void> pickImages(int index) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        xfilePathURL.add(pickedFile);
        ModifyImages(xfilePathURL);
      });
    }
  }

  // 이미지를 삭제하는 함수
  Future<void> deleteImage(String deletepath, String accessToken) async {
    final url = Uri.parse('https://soulmbti.shop:8000/edit/deleteimage');
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'accessToken': accessToken
          },
          body: jsonEncode({'deletepath': deletepath}));

      if (response.statusCode == 200) {
        print('삭제 성공: ${response.body}');
        List<dynamic> updatedImages = jsonDecode(response.body);
        UserDataController.to.images.assignAll(
            updatedImages.map((item) => UserImage.fromJson(item)).toList());
      } else {
        print('삭제 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  // 이미지를 수정하는 함수
  Future<void> ModifyImages(List<XFile?>? pickedFiles) async {
    final url = Uri.parse('https://soulmbti.shop:8000/edit/addimage');
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers['accesstoken'] = accessToken;

      for (var pickedFile in pickedFiles!) {
        if (pickedFile != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'file',
            pickedFile.path,
          ));
        }
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var respBody = await http.Response.fromStream(response);
        print('이미지 수정 완료');
        List<dynamic> updatedImages = jsonDecode(respBody.body);
        UserDataController.to.images.assignAll(
            updatedImages.map((item) => UserImage.fromJson(item)).toList());
      } else {
        print('이미지 수정 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDataController = Get.find<UserDataController>();
    return Scaffold(
      appBar: AppBar(title: const Text('사진 수정하기')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2,
        ),
        itemCount: userDataController.images.length,
        itemBuilder: (context, index) {
          var img = userDataController.images[index];
          return Obx(() => Card(
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    img.imagePath.value.isNotEmpty
                        ? Image.network(img.imagePath.value)
                        : Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => pickImages(index),
                            ),
                          ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.red),
                        onPressed: () =>
                            deleteImage(img.imagePath.value, accessToken),
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
