import 'package:flutter/material.dart';

class TopLayerInLoginScreen extends StatelessWidget {
  final double imgHeight;
  final double imgWidth;
  TopLayerInLoginScreen({required this.imgHeight, required this.imgWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      //로그인 창 상위 이미지 컨테이너
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 196, 215, 215),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: const ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)),
          child: Image(
            image: AssetImage('assets/images/logo1.png'),
          )),
    );
  }
}
