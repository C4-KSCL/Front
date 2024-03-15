import 'package:frontend_matching/services/friend_service.dart';
import 'package:get/get.dart';

class FriendController extends GetxController{
  static FriendController get to => Get.find();

  Rx<int> pageNumber = 0.obs;
  RxList<dynamic> friends = [].obs;
  RxList<dynamic> sendedRequests = [].obs;
  RxList<dynamic> receivedRequests= [].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    friends= FriendService.getFriendList();
    receivedRequests=FriendService.getFriendReceivedRequest();
    sendedRequests=FriendService.getFriendSendedRequest();
  }
}