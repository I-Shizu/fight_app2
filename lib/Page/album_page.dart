import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fight_app2/post.dart';
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
    _fetchFirebaseData();
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
                      Text(posts[index].date != null ?DateFormat('yyyy-MM-dd').format(posts[index].date!.toDate()) : '日付はありません'),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  void _fetchFirebaseData() async {
    final db = FirebaseFirestore.instance;

    final events = await db.collection("posts").orderBy("date", descending: true).get();
    final docs = events.docs;
    final posts = docs.map((doc) => Post.fromFirestore(doc)).toList();

    setState(() {
      this.posts = posts;
      _isLoading = false;
    });
  }
}