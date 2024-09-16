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
  final PostController _postController = PostController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Album'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _postController.fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("まだ投稿はありません"));
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                child: ListTile(
                  subtitle: Column(
                    children: [
                      post.imageUrl != null
                          ? Image.network(post.imageUrl!)
                          : Container(),
                      Text(
                        post.text,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(DateFormat('yyyy-MM-dd').format(post.date.toDate())),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}