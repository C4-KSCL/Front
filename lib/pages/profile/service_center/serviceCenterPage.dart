import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/service_center_controller.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/post.dart';
import 'package:frontend_matching/models/postImage.dart';
import 'package:frontend_matching/pages/profile/service_center/detailPage.dart';
import 'package:frontend_matching/pages/profile/service_center/postPage.dart';
import 'package:frontend_matching/theme/colors.dart';
import 'package:get/get.dart';

class ServiceCenterPage extends StatefulWidget {
  const ServiceCenterPage({super.key});

  @override
  State<ServiceCenterPage> createState() => _ServiceCenterPageState();
}

class _ServiceCenterPageState extends State<ServiceCenterPage> {
  final ServiceCenterController serviceCenterController =
      ServiceCenterController();
  List<Post> posts = [];
  List<PostImage> images = [];
  bool isLoading = true;
  String accessToken = '';

  @override
  void initState() {
    super.initState();
    final UserDataController controller = Get.find<UserDataController>();
    accessToken = controller.accessToken;
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final data = await serviceCenterController.fetchPosts(accessToken);
      setState(() {
        posts = data['posts'];
        images = data['images'];
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load posts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('고객센터'),
          elevation: 1.0,
          titleTextStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          backgroundColor: blueColor3,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () => {}),
            IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () => {})
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : posts.isEmpty
                ? const Center(child: Text('게시글이 없습니다.'))
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final image = images.firstWhereOrNull(
                        (img) => img.postNumber == post.postNumber,
                      );

                      return ListTile(
                        leading: image != null
                            ? Image.network(image.imagePath)
                            : null,
                        title: Text(post.title),
                        subtitle: Text(post.content), //
                        trailing: Text(
                          post.isAnswered == 0 ? '답변대기중' : '답변완료',
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                post.isAnswered == 0 ? Colors.red : Colors.blue,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                post: post,
                                postImage: image,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostPage(),
                ),
              );
            },
            child: const Icon(Icons.article_outlined),
          ),
          const SizedBox(width: 10),
        ]));
  }
}
