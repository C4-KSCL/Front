// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageSlider extends StatelessWidget {
  final List<String> imageArray;

  // 생성자 추가
  const ImageSlider({required this.imageArray});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageArray.length,
        itemBuilder: (context, index) {
          print(imageArray[index]);
          return Image.network(
            imageArray[index],
            fit: BoxFit.contain,
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              print('Image loading error: $error');
              return Center(child: Text('Image loading error'));
            },
          );
        },
      ),
    );
  }
}
