import 'package:flutter/material.dart';

class TopLayer extends StatelessWidget {
  final double medWidth;
  final double medHeight;
  final Function()? onpressed;
  final double statusBarHeight;
  TopLayer(
      {required this.statusBarHeight,
      required this.onpressed,
      required this.medWidth,
      required this.medHeight});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        height: statusBarHeight,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(medWidth / 20, 0, 0, 0),
            child: Text(
              '마이페이지',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            child: TextButton(
                onPressed: onpressed,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: const Image(
                      height: 25,
                      width: 25,
                      fit: BoxFit.fill,
                      image: AssetImage('assets/system/settings-2-fill.png')),
                )),
          )
        ],
      ),
    ]);
  }
}
