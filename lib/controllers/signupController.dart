import 'package:get/get.dart';

class SignupController extends GetxController {
  final RxList<String> signupArray = <String>[].obs;

  void addToSignupArray(String value) {
    signupArray.add(value);
  }

  void clearSignupArray() {
    signupArray.clear();
  }
}
