import 'package:fight_app2/Controller/post_controller.dart';
import 'package:fight_app2/Model/post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key,});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> with AutomaticKeepAliveClientMixin {
  List<Post> posts = [];
  bool _isLoading = true;
  String? imageUrl;
  final PostController _postController = PostController();

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() async {
    List<Post> fetchPosts = await _postController.fetchPosts();
    setState(() {
      posts = fetchPosts;
      _isLoading = false;//データ取得完了したらfalseになる
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: _isLoading 
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : checkPostsExist(),
    );
  }

  Widget checkPostsExist() {
    if (posts.isEmpty) {
      return const Center(
        child: Text('まだ投稿はありません'),
      );
    } else {
      return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              subtitle: Column(
                children: [
                  posts[index].imageUrl != null ? Image.network(posts[index].imageUrl!) : Container(),
                  Text(
                    posts[index].text,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(DateFormat('yyyy-MM-dd').format(posts[index].date.toDate())),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}