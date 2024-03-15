import 'package:flutter/material.dart';

SizedBox ColorBottomButton(
    {required String text,
    required Color backgroundColor,
    required VoidCallback onPressed,
    required TextStyle textStyle}) {
  return SizedBox(
    width: 400,
    height: 50,
    child: TextButton(
      onPressed: () {
        onPressed();
      },
      child: Text(text, style: textStyle),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: backgroundColor,
      ),
    ),
  );
}

Container WhiteBottomButton(
    {required String text,
    required Color backgroundColor,
    required VoidCallback onPressed,
    required TextStyle textStyle}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 5.0,
          spreadRadius: 1.0,
          offset: const Offset(5, 5), // 그림자의 위치
        ),
      ],
    ),
    width: 400,
    height: 50,
    child: TextButton(
      onPressed: () {
        onPressed();
      },
      child: Text(text, style: textStyle),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: backgroundColor,
      ),
    ),
  );
}
