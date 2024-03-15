import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/userDataController.dart';

class FriendService{
  static const baseUrl = 'http://15.164.245.62:8000';
  static const rooms = 'rooms';
  static const users = 'users';
  static const create = 'create';
  static const requests = 'requests';
  static const send = 'send';
  static const accept = 'accept';
  static const reject = 'reject';
  static const chats = 'chats';
  static const friends = 'friends';
  static const delete = 'delete';
  static const oppEmail = 'oppEmail';
  static const events='events';

  static String accessToken = UserDataController.to.accessToken;

  static Map<String, String> headers = {
    "Content-type": "application/json",
    "accessToken": accessToken
  };

  //친구 요청 보내기
  static void sendFriendRequest({
    required String oppEmail,
    required String content,
  }) async {
    final url = Uri.parse('$baseUrl/$requests/send');

    print(accessToken);

    String data =
        '{"oppEmail": "$oppEmail", "content":"$content"}';

    final response = await http.post(url, headers: headers, body: data);

    print(response.statusCode);
    print(response.body);
  }

  //받은 친구 요청 확인
  static dynamic getFriendReceivedRequest() async {
    final url = Uri.parse('$baseUrl/$requests/get-received');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);

    return response.body;
  }

  //보낸 친구 요청 확인
  static dynamic getFriendSendedRequest() async{
    final url = Uri.parse('$baseUrl/$requests/get-sended');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);

    return response.body;
  }

  //받은 친구 요청 수락
  //받은 친구 요청 확인을 할때 requestId를 저장해놓고 가져와야함
  static void acceptFriendRequest({required int requestId,})async{
    final url = Uri.parse('$baseUrl/$requests/accept');

    String data='{"requestId" :$requestId}';

    final response= await http.post(url,headers: headers,body: data);

    print(response.statusCode);
    print(response.body);
  }

  //받은 친구 요청 거절
  static void rejectFriendRequest({required String requestId,}) async{
    final url = Uri.parse('$baseUrl/$requests/reject');

    String data="{requestId : $requestId}";

    final response = await http.patch(url, headers: headers,body: data);

    print(response.statusCode);
    print(response.body);
  }

  //받은 친구 요청 삭제
  static void deleteFriendRequest({required String requestId,}) async{
    final url = Uri.parse('$baseUrl/$requests/reject');

    String data="{requestId : $requestId}";

    final response = await http.delete(url, headers: headers,body: data);

    print(response.statusCode);
    print(response.body);
  }

  //친구 리스트 가져오기
  static dynamic getFriendList() async{
    final url = Uri.parse('$baseUrl/$friends/get-list');

    final response = await http.get(url, headers: headers);

    print(response.statusCode);
    print(response.body);

    return response.body;
  }

  //친구 삭제
  static void deleteFriend({required String oppEmail,}) async{
    final url = Uri.parse('$baseUrl/$friends/$delete/$oppEmail');

    final response = await http.get(url, headers: headers,);

    print(response.statusCode);
    print(response.body);
  }
}