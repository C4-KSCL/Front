// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NickNameCheck {
  static Future<String?> checknickname(String nickname, BuildContext context,
      Function updateNicknameValid) async {
    final url = Uri.parse('http://15.164.245.62:8000/signup/checknickname');
    try {
      final response = await http.post(
        url,
        body: {'nickname': nickname},
      );

      if (response.statusCode == 200) {
        print('사용 가능한 닉네임입니다.');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('닉네임 인증'),
              content: Text('사용 가능한 닉네임 입니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
        updateNicknameValid(true); // 다음으로 버튼 홠ㅇ화
      } else if (response.statusCode == 301) {
        print('이미 사용 중인 닉네임입니다.');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('닉네임 인증'),
              content: Text('이미 사용 중인 닉네임입니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
        updateNicknameValid(false);
      } else {
        print('서버 에러가 발생했습니다. 에러 코드: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('닉네임 인증'),
              content: Text('서버 에러 발생, 관리자에게 문의하세요.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      }
      updateNicknameValid(false);
    } catch (e) {
      print('닉네임 확인 중 에러가 발생했습니다: $e');
      updateNicknameValid(false);
    }
  }
}
