import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/service_center_controller.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  XFile? imageFile;
  String accessToken = '';
  ServiceCenterController serviceCenterController = ServiceCenterController();

  @override
  void initState() {
    super.initState();
    final UserDataController controller = Get.find<UserDataController>();
    accessToken = controller.accessToken;
    print(accessToken);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('게시글 작성')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: '카테고리'),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: '제목'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: '내용'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('이미지 선택'),
              ),
              const SizedBox(height: 10),
              if (imageFile != null) Image.file(File(imageFile!.path)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String category = categoryController.text;
                  String title = titleController.text;
                  String content = contentController.text;
                  print(category);
                  print(title);
                  print(content);
                  serviceCenterController.submitPost(
                      category, title, content, imageFile, accessToken);
                },
                child: const Text('게시글 작성'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
