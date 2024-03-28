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
            backgroundImage: NetworkImage(widget.img),
          ),
        ),
        CircleAvatar(
          radius: widget.medWidth / 5.5,
          backgroundImage: NetworkImage(widget.img),
        ),
      ],
    );
  }
}
