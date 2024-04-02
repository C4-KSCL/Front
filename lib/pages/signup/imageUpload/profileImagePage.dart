// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/pages/init_page.dart';
import 'package:frontend_matching/pages/signup/imageUpload/selectImagePage.dart';
import 'package:frontend_matching/pages/signup/schoolAuth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileImagePage extends StatefulWidget {
  const ProfileImagePage({Key? key}) : super(key: key);

  @override
  State<ProfileImagePage> createState() => _ProfileImagePageState();
}

class _ProfileImagePageState extends State<ProfileImagePage> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();
  SignupController signupController = Get.find<SignupController>();

  Future<void> getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> uploadProfileImage(XFile pickedFile) async {
    final url = Uri.parse('http://15.164.245.62:8000/signup/profile');
    try {
      var request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('files', pickedFile.path))
        ..fields['email'] = signupController.signupArray[0];
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Profile image uploaded successfully!');
        // 여기서 업로드가 완료되었음을 알 수 있도록 처리할 수 있습니다.
      } else {
        print('Failed to upload profile image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("프로필 이미지를 선택해주세요!")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF7EA5F3),
              ),
              child: Stack(
                children: [
                  _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      icon: Icon(Icons.add_a_photo),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                if (_image != null) {
                  uploadProfileImage(_image!);
                } else {
                  print('Please select a profile image.');
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectImagePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7EA5F3),
                minimumSize: Size(200, 50),
              ),
              child: const Text(
                '다음으로',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
