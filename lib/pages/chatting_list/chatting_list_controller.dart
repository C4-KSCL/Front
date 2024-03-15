import 'package:frontend_matching/services/chat_service.dart';
import 'package:get/get.dart';

class ChattingListController extends GetxController{
  static ChattingListController get to=>Get.find<ChattingListController>();
  RxList<dynamic> chttingList=[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    ChatService.getLastChatList(); //마지막 채팅 내역 가져오기
  }
}