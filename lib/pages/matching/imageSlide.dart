import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageSlider extends StatelessWidget {
  final List<String> imageArray;

  const ImageSlider({Key? key, required this.imageArray}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: PageView.builder(
        key: const PageStorageKey<String>(
            'imageSlider'), // 고정된 키를 사용하여 슬라이더의 상태를 유지
        scrollDirection: Axis.horizontal,
        itemCount: imageArray.length,
        itemBuilder: (context, index) {
          return Image.network(
            imageArray[index],
            fit: BoxFit.contain,
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              return Center(child: Text('Image loading error'));
            },
          );
        },
      ),
    );
  }
}
