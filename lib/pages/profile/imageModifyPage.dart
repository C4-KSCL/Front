// ignore_for_file: avoid_unnecessary_containers, unnecessary_const

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend_matching/pages/matching/imageSlide.dart';
import 'package:frontend_matching/pages/profile/topLayer.dart';

class ImageModifyPage extends StatefulWidget {
  const ImageModifyPage({Key? key}) : super(key: key);
  @override
  State<ImageModifyPage> createState() => _ImageModifyPageState();
}

class _ImageModifyPageState extends State<ImageModifyPage> {
  List<File> images = [];
  List<String> ImagePaths = [];

  @override
  Widget build(BuildContext context) {
    final double medWidth = MediaQuery.of(context).size.width;
    final double medHeight = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TopLayer(
            medHeight: medHeight,
            medWidth: medWidth,
            statusBarHeight: statusBarHeight,
            onpressed: () {
              print('button check');
            },
          ),
          const Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '사진 수정하기',
                  style: TextStyle(fontSize: 25),
                ),
                Text('최대 3장'),
              ],
            ),
          ),
          Column(
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
                      child: ImageSlider(imageArray: ImagePaths)),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // 스크롤 동작 방지
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
                              image: FileImage(images[index]),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              images.removeAt(index);
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('완료'),
          ),
        ],
      ),
    );
  }
}
