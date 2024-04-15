import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// 시간을 "방금/1분전/2시간전/3일전/4주전/2024-12-12"로 바꿔줌
String convertHowMuchTimeAge({required String utcTimeString}) {
  // UTC 시간대를 명확히 하여 DateTime 객체를 생성
  DateTime utcTime = DateTime.parse(utcTimeString).toUtc();

  // 현재 날짜와 시간 (한국 시간 기준)
  DateTime now = DateTime.now().toUtc().add(Duration(hours: 9));

  // 차이 계산
  Duration difference = now.difference(utcTime);
  if (difference.inMinutes < 1) {
    return '방금';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}분 전';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}시간 전';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}일 전';
  } else if (difference.inDays < 30) {
    int weeks = (difference.inDays / 7).floor();
    return '$weeks주 전';
  } else {
    return DateFormat('yyyy-MM-dd').format(utcTime);
  }
}

// 시간을 "오전/오후 12:12" 으로 바꿔줌
String convertHourAndMinuteTime({required String utcTimeString}) {
  // UTC 시간을 DateTime 객체로 파싱
  DateTime utcTime = DateTime.parse(utcTimeString).toUtc();

  // DateFormat을 사용하여 "오후 12:33" 형식으로 변환
  String formattedTime = DateFormat('a hh:mm', 'ko_KR').format(utcTime);

  formattedTime = formattedTime.replaceFirst('AM', '오전').replaceFirst('PM', '오후');

  return formattedTime;
}

String extractDate(String utcTimeString) {
  // UTC 시간 문자열을 DateTime 객체로 파싱
  DateTime utcTime = DateTime.parse(utcTimeString).toUtc();

  // 날짜 부분만 추출하여 'yyyy-MM-dd' 포맷으로 변환
  String dateOnly = DateFormat('yyyy-MM-dd').format(utcTime);

  return dateOnly;
}

String convertKoreaTime({required String utcTimeString}) {
  // UTC 시간대를 명확히 하여 DateTime 객체를 생성
  DateTime utcTime = DateTime.parse(utcTimeString).toUtc();

  String formattedTime = DateFormat('yyyy년 MM월 dd일 EEEE', 'ko_KR').format(utcTime);

  return formattedTime;
}