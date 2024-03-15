import 'package:flutter/material.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:frontend_matching/theme/textStyle.dart';

//텍스트 필드
Container TextFieldBox({
  required TextEditingController textEditingController,
  required String hintText,
}) {
  return Container(
    height: 65,
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
    child: TextField(
      style: blackTextStyle2,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: greyTextStyle1,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: whiteColor1, width: 2.0),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: blueColor4, width: 2.0),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      controller: textEditingController,
    ),
  );
}

//버튼이 들어있는 텍스트 필드
class ButtonTextFieldBox extends StatefulWidget {
  final String hintText;
  final VoidCallback onPressed;
  final String buttonText;
  final TextEditingController textEditingController;

  ButtonTextFieldBox({
    required this.hintText,
    required this.onPressed,
    required this.buttonText,
    required this.textEditingController,
  });

  @override
  _ButtonTextFieldBoxState createState() => _ButtonTextFieldBoxState();
}

class _ButtonTextFieldBoxState extends State<ButtonTextFieldBox> {
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    widget.textEditingController.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    setState(() {
      _hasInput = widget.textEditingController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: TextField(
        controller: widget.textEditingController,
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: greyTextStyle1,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: whiteColor1, width: 2.0),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: blueColor4, width: 2.0),
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 80,
                child: ElevatedButton(
                  onPressed: _hasInput ? widget.onPressed : null,
                  child: Container(
                    child: Text(
                      widget.buttonText,
                      style: _hasInput ? blueTextStyle1 : greyTextStyle1,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // 원하는 반지름 값으로 설정
                    ),
                    side: BorderSide(
                      color: _hasInput ? blueColor4 : greyColor7,
                      // 원하는 테두리 색깔로 설정
                      width: 2, // 테두리의 두께 설정
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

Container IconTextFieldBox({
  required TextEditingController textEditingController,
  required String hintText,
  required VoidCallback onPressed,
}) {
  return Container(
    height: 65,
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
    child: TextField(
      style: blackTextStyle2,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: greyTextStyle1,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: blueColor4, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: blueColor4, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              onPressed();
            },
            icon: Icon(
              Icons.send,
              color: blueColor1,
            ),
          )),
      controller: textEditingController,
    ),
  );
}
