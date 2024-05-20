import 'dart:convert';

import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/post.dart';
import 'package:frontend_matching/models/postImage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../config.dart';

class ServiceCenterController extends GetxController {
  static String? baseUrl=AppConfig.baseUrl;

  UserDataController userDataController = Get.find<UserDataController>();

  Future<Map<String, dynamic>> fetchPosts(String accessToken) async {
    final url = Uri.parse('$baseUrl/customerService/readGeneral');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'accesstoken': accessToken},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Server response: $data');

      List<Post> posts =
          (data['posts'] as List).map((post) => Post.fromJson(post)).toList();
      List<PostImage> images = (data['images'] as List)
          .map((image) => PostImage.fromJson(image))
          .toList();
      return {
        'posts': posts,
        'images': images,
      };
    } else {
      print('Server error: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to load posts');
    }
  }

  Future<void> submitPost(
    String postCategory,
    String postTitle,
    String postContent,
    XFile? imageFile,
    String accessToken,
  ) async {
    final url = Uri.parse('$baseUrl/customerService/post');
    final request = http.MultipartRequest('POST', url);

    request.headers['accesstoken'] = accessToken;

    request.fields['postCategory'] = postCategory;
    request.fields['postTitle'] = postTitle;
    request.fields['postContent'] = postContent;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          imageFile.path,
        ),
      );
    }
    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('게시글 작성 성공');
        Get.back();
        Get.back();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
