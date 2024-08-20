import 'package:fight_app2/Model/Api/firebase_firestore.dart';
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

  @override
  void initState() {
    super.initState();
    FirestoreApi().getPosts();
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
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder:(context, index) {
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
                      Text(posts[index].date != null ?DateFormat('yyyy-MM-dd').format(posts[index].date.toDate()) : '日付はありません'),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}