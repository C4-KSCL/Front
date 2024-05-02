// ignore_for_file: avoid_unnecessary_containers, unnecessary_const

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
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

  void removeImage(int index) {
    if (index < imagePathURL.length && imagePathURL[index].isNotEmpty) {
      setState(() {
        imagePathURL.removeAt(index);
      });
    }
  }

  // 이미지를 삭제하는 함수
  Future<void> deleteImage(String deletepath, String accessToken) async {
    final url = Uri.parse('http://15.164.245.62:8000/edit/deleteimage');
    print(deletepath);
    try {
      print(accessToken);
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          },
          body: jsonEncode({'deletepath': deletepath}));

      if (response.statusCode == 200) {
        print('삭제 성공: ${response.body}');
      } else {
        print('삭제 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
      // 예외 처리 로직
    }
  }

  // 이미지를 수정하는 함수
  Future<void> ModifyImages(List<XFile?>? pickedFiles) async {
    final url = Uri.parse('http://15.164.245.62:8000/edit/addimage');
    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['accesstoken'] = accessToken;
      print(accessToken);
      for (var pickedFile in pickedFiles!) {
        request.files.add(await http.MultipartFile.fromPath(
          'files',
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
          childAspectRatio: 2, // 가로 세로 비율 조정
        ),
        itemCount: 3, // 고정된 카드 수를 3으로 설정
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                index < imagePathURL.length && imagePathURL[index] != null
                    ? Image.network(
                        imagePathURL[index]!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Text('이미지를 불러올 수 없습니다.')),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            print(index);
                            pickImages(index);
                          },
                        ),
                      ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Colors.red),
                    onPressed: () {
                      deleteImage(imagePathURL[index], accessToken);
                      removeImage(index); // 해당 이미지를 제거하는 함수 호출
                    },
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
