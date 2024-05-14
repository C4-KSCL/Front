import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/userImageController.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
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
  String accessToken = '';

  @override
  void initState() {
    super.initState();
    final UserDataController controller = Get.find<UserDataController>();
    accessToken = controller.accessToken;
  }

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      UserImageController().addImage(pickedFile, accessToken);
    }
  }

  void deleteImage(int idx) async {
    UserImageController().deleteImage(idx, accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 수정하기'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2,
        ),
        itemCount: 3, // 이미지는 최대 3장
        itemBuilder: (context, index) {
          // 안전한 인덱스 접근을 위해 ? 연산자 사용
          var img = index < userDataController.images.length
              ? userDataController.images[index]
              : null;

          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                if (img?.imagePath != null && img!.imagePath.isNotEmpty)
                  Image.network(
                    img.imagePath,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Text('이미지를 불러올 수 없습니다.')),
                  )
                else
                  Container(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: const Icon(Icons.add, size: 40),
                      onPressed: () => pickImage(),
                    ),
                  ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Colors.red),
                    onPressed: () => deleteImage(index),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
