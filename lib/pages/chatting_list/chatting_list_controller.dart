import 'package:frontend_matching/models/chat_list.dart';
import 'package:frontend_matching/services/chat_service.dart';
import 'package:get/get.dart';

class ChattingListController extends GetxController{
  static ChattingListController get to=>Get.find<ChattingListController>();

  RxList<ChatList> chattingList=<ChatList>[].obs;
}