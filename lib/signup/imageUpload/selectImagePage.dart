// ignore_for_file: avoid_print, sized_box_for_whitespace, file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

Future<void> uploadImage(XFile pickedFile) async {
  final url = Uri.parse('http://15.164.245.62:8000/signup/image');

  var request = http.MultipartRequest('POST', url)
    ..files.add(await http.MultipartFile.fromPath('files', pickedFile.path))
    ..fields['email'] = 'ww@naver.com';

  request.headers['Content-Type'] = 'multipart/form-data';

  try {
    var response = await request.send();
    print('Request sent!');
    if (response.statusCode == 200) {
      print('이미지 업로드 성공!');
    } else {
      print('이미지 업로드 실패: ${response.statusCode}');
    }
  } catch (e) {
    print('에러 발생: $e');
  }
}

class SelectImagePage extends StatefulWidget {
  const SelectImagePage({Key? key}) : super(key: key);

  @override
  State<SelectImagePage> createState() => _SelectImagePageState();
}

class _SelectImagePageState extends State<SelectImagePage> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담김
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile; //가져온 이미지를 _image에 저장
      });

      // 이미지 업로드 함수 호출
      await uploadImage(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Camera Test")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30, width: double.infinity),
            _buildPhotoArea(),
            const SizedBox(height: 20),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
            width: 300,
            height: 300,
            child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
          )
        : Container(
            width: 300,
            height: 300,
            color: Colors.grey,
          );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: const Text("카메라"),
        ),
        const SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: const Text("갤러리"),
        ),
      ],
    );
  }
}
