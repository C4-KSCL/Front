import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/pages/signup/schoolAuth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class SelectImagePage extends StatefulWidget {
  @override
  State<SelectImagePage> createState() => SelectImagePageState();
}

UserDataController userDataController = Get.find<UserDataController>();
final picker = ImagePicker();
List<XFile?> multiImage = []; // 갤러리에서 여러장의 사진을 선택해서 저장할 변수
List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수

class SelectImagePageState extends State<SelectImagePage> {
  Future<void> pickImages() async {
    multiImage = await picker.pickMultiImage();
    setState(() {
      images.addAll(multiImage);
    });
  }

  Future<void> uploadImages(List<XFile?>? pickedFiles) async {
    final url = Uri.parse('http://15.164.245.62:8000/signup/image');
    SignupController signupController = Get.find<SignupController>();
    String userEmail = signupController.signupArray.isNotEmpty
        ? signupController.signupArray[0]
        : '';
    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['email'] = userEmail;
      for (var pickedFile in pickedFiles!) {
        request.files.add(await http.MultipartFile.fromPath(
          'files',
          pickedFile!.path,
        ));
        print(pickedFile!.path);
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Images uploaded successfully!');
        userDataController.logout();
      } else {
        print('Failed to upload images: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("추가로 이미지를 선택해주세요!")),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
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
            SizedBox(height: 50),
            Container(
              margin: EdgeInsets.all(20),
              child: GridView.builder(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1 / 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(
                              File(images[index]!.path),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 15,
                          ),
                          onPressed: () {
                            setState(() {
                              images.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 250,
            ),
            SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7EA5F3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  if (images.isNotEmpty) {
                    uploadImages(images);
                    userDataController.logout();
                  } else {
                    print('추가 이미지를 넣어주세요.');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('이미지 추가'),
                          content: const Text('추가 이미지를 넣어주세요.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text(
                  '다음으로',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
