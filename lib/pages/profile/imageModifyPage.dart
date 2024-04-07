// ignore_for_file: avoid_unnecessary_containers, unnecessary_const

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/userDataController.dart';
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
  List<XFile?> images = []; // 갤러리에서 선택된 이미지들을 저장할 리스트
  String accessToken = '';
  int imageCount = 0;

  @override
  void initState() {
    super.initState();
    final UserDataController controller = Get.find<UserDataController>();
    if (controller.user.value != null) {
      accessToken = controller.accessToken;
      print(accessToken);
      imageCount = controller.images.length;

      for (int i = 0; i < imageCount; i++) {
        if (controller.images[i].imagePath != null) {
          String imagePath = controller.images[i].imagePath;
          XFile xFileImage = XFile(imagePath);
          images.add(xFileImage);
        }
      }
    } else {
      print('null???');
    }
  }

  Future<void> pickImages() async {
    multiImage = await picker.pickMultiImage();
    setState(() {
      images.addAll(multiImage);
    });
  }

  // 사용자가 이미지를 수정할 수 있도록 허용하는 함수
  Future<void> editImage(int index) async {
    var newImage = await picker.pickImage(source: ImageSource.gallery);
    if (newImage != null) {
      setState(() {
        images[index] = newImage;
      });
    }
  }

  // 이미지 삭제 함수
  void deleteImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  // 이미지를 수정하는 함수
  Future<void> ModifyImages(List<XFile?>? pickedFiles) async {
    final url = Uri.parse('http://15.164.245.62:8000/edit/addimage');

    try {
      var request = http.MultipartRequest('POST', url)
        ..fields['accessToken'] = accessToken;
      print(accessToken);
      for (var pickedFile in pickedFiles!) {
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          pickedFile!.path,
        ));
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        print('이미지 수정 완료');
      } else {
        print('이미지 수정 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  Widget buildImagesGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.network(images[index]!.path),
            // 수정 아이콘
            Positioned(
              right: 5,
              top: 5,
              child: GestureDetector(
                onTap: () => editImage(index),
                child: const Icon(
                  Icons.edit,
                  color: Colors.red,
                ),
              ),
            ),
            // 삭제 아이콘
            Positioned(
              right: 5,
              bottom: 5,
              child: GestureDetector(
                onTap: () => deleteImage(index),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 수정하기'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: IconButton(
                  onPressed: pickImages,
                  icon: const Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: buildImagesGrid(),
          ),
          ElevatedButton(
            onPressed: () => ModifyImages(images),
            child: const Text('수정 완료'),
          ),
        ],
      ),
    );
  }
}
