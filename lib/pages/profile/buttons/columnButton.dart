import 'package:flutter/material.dart';

class ColumnButton extends StatelessWidget {
  final Function()? pressed;
  final String img;
  final String str;

  ColumnButton({required this.pressed, required this.img, required this.str});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: pressed,
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey, width: 0.1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(img),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '$str',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ));
  }
}
