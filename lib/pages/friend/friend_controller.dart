import 'package:frontend_matching/models/friend.dart';
import 'package:frontend_matching/models/request.dart';
import 'package:frontend_matching/services/friend_service.dart';
import 'package:get/get.dart';

class FriendController extends GetxController{
  static FriendController get to => Get.find();

  Rx<int> pageNumber = 0.obs;
  RxList<Friend> friends=RxList<Friend>();
  RxList<Request> sendedRequests=RxList<Request>();
  RxList<Request> receivedRequests=RxList<Request>();

}