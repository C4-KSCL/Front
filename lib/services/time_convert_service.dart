import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String convertKoreaTime({required String utcTimeString}) {
  DateTime utcTime = DateTime.parse(utcTimeString);

  // // 한국 시간으로 변환 (UTC+9)
  // DateTime kstTime = utcTime.add(Duration(hours: 9));
  // // 원하는 형식으로 포맷팅
  // String formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(kstTime);
  //
  // DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm');
  // DateTime inputDate = inputFormat.parse(formattedTime);

  // 현재 날짜와 시간
  DateTime now = DateTime.now();

  // 차이 계산
  Duration difference = now.difference(utcTime);
  if (difference.inMinutes < 1) {
    return '방금';
  } else if (difference.inMinutes < 60) {
    // 1시간 이내이면 분으로 계산
    return '${difference.inMinutes}분 전';
  } else if (difference.inHours < 24) {
    // 24시간 이내이면 시간으로 계산
    return '${difference.inHours}시간 전';
  } else if (difference.inDays < 7) {
    // 일주일 이내이면 일수로 계산
    return '${difference.inDays}일 전';
  } else if (difference.inDays < 30) {
    // 한 달 이내이면 주수로 계산
    int weeks = (difference.inDays / 7).floor();
    return '$weeks주 전';
  } else {
    // 그 이외에는 년도와 날짜 출력
    return DateFormat('yyyy-MM-dd').format(utcTime);
  }
}
