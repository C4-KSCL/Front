import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for ByteData and Uint8List
import 'package:image_picker/image_picker.dart';
import 'package:crop_image/crop_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:ui' as ui;

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  File? croppedFile;
  late final CropController controller;

  @override
  void initState() {
    super.initState();
    controller = CropController(
      aspectRatio: 1.0,
      defaultCrop: Rect.fromCenter(
        center: const Offset(0.5, 0.5),
        width: 0.6,
        height: 0.6,
      ),
    );
    controller.addListener(_handleCropChange);
  }

  void _handleCropChange() {
    final fixedSize = 0.6;
    final currentCrop = controller.crop;
    final newCrop = Rect.fromCenter(
      center: currentCrop.center,
      width: fixedSize,
      height: fixedSize,
    );

    if (currentCrop != newCrop) {
      controller.removeListener(_handleCropChange);
      controller.crop = newCrop;
      controller.addListener(_handleCropChange);
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        croppedFile = null; // 새로운 이미지를 선택하면 크롭된 파일을 초기화
      });
    }
  }

  Future<void> cropImage() async {
    if (imageFile == null) return;

    // 크롭 영역을 기반으로 이미지를 크롭합니다.
    final croppedImage = await controller.croppedBitmap();
    if (croppedImage == null) return;

    // 크롭된 이미지를 ui.Image로 변환
    final byteData =
        await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    // ByteData를 Uint8List로 변환
    final buffer = byteData.buffer.asUint8List();

    // 크롭된 이미지를 파일로 저장합니다.
    final directory = await getTemporaryDirectory();
    final filePath = path.join(directory.path, 'cropped_image.png');
    final file = File(filePath);
    await file.writeAsBytes(buffer);

    setState(() {
      croppedFile = file;
      imageFile = null; // 크롭 후 원본 이미지를 초기화
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('이미지 크롭 테스트'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageFile == null && croppedFile == null)
                const Text('이미지를 선택하세요.')
              else if (imageFile != null)
                Expanded(
                  child: CropImage(
                    controller: controller,
                    image: Image.file(imageFile!, fit: BoxFit.contain),
                    gridColor: Colors.white70,
                    paddingSize: 20,
                    touchSize: 30,
                    gridCornerSize: 15,
                    gridThinWidth: 2,
                    gridThickWidth: 5,
                    scrimColor: Colors.black54,
                    alwaysShowThirdLines: true,
                    minimumImageSize: 100,
                    maximumImageSize: double.infinity,
                    alwaysMove: true,
                  ),
                )
              else if (croppedFile != null)
                Expanded(
                  child: Image.file(croppedFile!),
                ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: pickImage,
              child: const Icon(Icons.add_a_photo),
            ),
            const SizedBox(width: 10),
            if (imageFile != null)
              FloatingActionButton(
                onPressed: cropImage,
                child: const Icon(Icons.crop),
              ),
          ],
        ),
      );
}
