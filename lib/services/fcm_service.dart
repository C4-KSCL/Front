import 'package:flutter/services.dart';

class WakeScreen {
  static const platform = MethodChannel('com.example.your_project_name/wakelock');

  static Future<void> wakeUpScreen() async {
    try {
      await platform.invokeMethod('wakeScreen');
    } on PlatformException catch (e) {
      print("Failed to wake up screen: '${e.message}'.");
    }
  }
}