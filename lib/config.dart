import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppConfig {
  static String? baseUrl;
  static const storage = FlutterSecureStorage();

  static void load() {
    baseUrl = dotenv.env['SERVER_URL'];
  }
}