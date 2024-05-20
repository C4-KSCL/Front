import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String? baseUrl;

  static void load() {
    baseUrl = dotenv.env['SERVER_URL'];
  }
}