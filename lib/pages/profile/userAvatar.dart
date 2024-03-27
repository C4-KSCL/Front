import 'package:flutter/material.dart';

class UserAvatar extends StatefulWidget {
  final String img;
  final double medWidth;

  UserAvatar({required this.img, required this.medWidth});

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 0.4,
          child: CircleAvatar(
            radius: widget.medWidth / 5.2,
            backgroundImage: AssetImage(widget.img),
            // 배경 이미지로 설정하여 원형 유지
          ),
        ),
        CircleAvatar(
          radius: widget.medWidth / 5.5,
          backgroundImage: AssetImage(widget.img),
          // 배경 이미지로 설정하여 원형 유지
        )
      ],
    );
  }
}
