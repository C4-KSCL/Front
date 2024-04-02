import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SignupController extends GetxController {
  final RxList<String> signupArray = <String>[].obs;

  void addToSignupArray(String value) {
    signupArray.add(value);
  }

  void clearSignupArray() {
    signupArray.clear();
  }
}
