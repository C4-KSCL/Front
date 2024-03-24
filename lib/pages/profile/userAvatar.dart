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
    String img = widget.img;
    double med = widget.medWidth;
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 0.4,
          child: CircleAvatar(
            radius: med / 5.2,
            child: Image.asset(
              img,
              fit: BoxFit.cover,
            ),
          ),
        ),
        CircleAvatar(
            radius: med / 5.5,
            child: Image.asset(
              img,
              fit: BoxFit.cover,
            ))
      ],
    );
  }
}
