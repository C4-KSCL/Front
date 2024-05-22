// import 'package:flutter/material.dart';
// import 'package:frontend_matching/controllers/userImageController.dart';
// import 'package:frontend_matching/controllers/user_data_controller.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class ImageModifyPage extends StatefulWidget {
//   const ImageModifyPage({Key? key}) : super(key: key);

//   @override
//   State<ImageModifyPage> createState() => _ImageModifyPageState();
// }

// class _ImageModifyPageState extends State<ImageModifyPage> {
//   final ImagePicker picker = ImagePicker();
//   late String accessToken;
//   final UserDataController userDataController = Get.find<UserDataController>();

//   @override
//   void initState() {
//     super.initState();
//     accessToken = userDataController.accessToken;
//   }

//   Future<void> pickImage() async {
//     final XFile? pickedFile =
//         await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       await UserImageController().addImage(pickedFile, accessToken);
//     }
//   }

//   void deleteImage(int idx) async {
//     await UserImageController().deleteImage(idx, accessToken);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('사진 수정하기'),
//       ),
//       body: GridView.builder(
//         padding: const EdgeInsets.all(8.0),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 1,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           childAspectRatio: 2,
//         ),
//         itemCount: 3,
//         itemBuilder: (context, index) {
//           return Obx(() {
//             var img = index < userDataController.images.length
//                 ? userDataController.images[index]
//                 : null;

//             return Card(
//               clipBehavior: Clip.antiAlias,
//               child: Stack(
//                 children: [
//                   if (img?.imagePath != null && img!.imagePath.isNotEmpty)
//                     Image.network(
//                       img.imagePath,
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return const Center(child: CircularProgressIndicator());
//                       },
//                       errorBuilder: (context, error, stackTrace) =>
//                           const Center(child: Text('이미지를 불러올 수 없습니다.')),
//                     )
//                   else
//                     Container(
//                       alignment: Alignment.center,
//                       child: IconButton(
//                         icon: const Icon(Icons.add, size: 40),
//                         onPressed: () => pickImage(),
//                       ),
//                     ),
//                   Positioned(
//                     right: 4,
//                     top: 4,
//                     child: IconButton(
//                       icon: const Icon(Icons.remove_circle_outline,
//                           color: Colors.red),
//                       onPressed: () => deleteImage(index),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           });
//         },
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/userImageController.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_image/crop_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

class ImageModifyPage extends StatefulWidget {
  const ImageModifyPage({Key? key}) : super(key: key);

  @override
  State<ImageModifyPage> createState() => _ImageModifyPageState();
}

class _ImageModifyPageState extends State<ImageModifyPage> {
  final ImagePicker picker = ImagePicker();
  late String accessToken;
  final UserDataController userDataController = Get.find<UserDataController>();
  File? imageFile;
  CropController? cropController;

  @override
  void initState() {
    super.initState();
    accessToken = userDataController.accessToken;
  }

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        cropController = CropController(
          aspectRatio: 0.5, // 가로:세로 비율을 1:2로 설정
          defaultCrop: Rect.fromCenter(
            center: const Offset(0.5, 0.5),
            width: 0.98,
            height: 0.98,
          ),
        );
      });
      await showCropDialog();
    }
  }

  Future<void> showCropDialog() async {
    if (cropController == null || imageFile == null) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('이미지 크롭'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: CropImage(
            controller: cropController!,
            image: Image.file(imageFile!, fit: BoxFit.contain),
            gridColor: Colors.white70,
            paddingSize: 20,
            touchSize: 30,
            gridCornerSize: 15,
            gridThinWidth: 2,
            gridThickWidth: 5,
            scrimColor: Colors.black54,
            alwaysShowThirdLines: true,
            minimumImageSize: 300,
            maximumImageSize: double.infinity,
            alwaysMove: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              await cropAndUploadImage();
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Future<void> cropAndUploadImage() async {
    if (imageFile == null || cropController == null) return;

    final croppedImage = await cropController!.croppedBitmap();

    final byteData =
        await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    final buffer = byteData.buffer.asUint8List();

    final directory = await getTemporaryDirectory();
    final filePath = path.join(directory.path,
        'cropped_image_${DateTime.now().millisecondsSinceEpoch}.png');
    final file = File(filePath);
    await file.writeAsBytes(buffer);

    // 이미지를 고정된 크기로 리사이즈
    final fixedWidth = 400; // 원하는 고정된 너비
    final fixedHeight = 800; // 원하는 고정된 높이
    final image = img.decodeImage(file.readAsBytesSync());
    final resizedImage =
        img.copyResize(image!, width: fixedWidth, height: fixedHeight);
    file.writeAsBytesSync(img.encodePng(resizedImage));

    await UserImageController().addImage(XFile(file.path));
    setState(() {
      imageFile = null;
      cropController = null;
    });
  }

  void deleteImage(int idx) async {
    await UserImageController().deleteImage(idx);
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
        itemCount: 3,
        itemBuilder: (context, index) {
          return Obx(() {
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
          });
        },
      ),
    );
  }
}
