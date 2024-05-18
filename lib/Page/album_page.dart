import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fight_app2/post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key,});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  List<Post> posts = [];
  bool _isLoading = true;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchFirebaseData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(0),//ここの調節をどうにかする
              child: Text('アルバム'),
            ),
            /*InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage(posts: [],)),
                );
              },
              child: Icon(Icons.search),
            ),*/
          ],
        ),
      ),*/

      body: _isLoading 
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder:(context, index) {
              return Card(
                child: ListTile(
                  title: Text(posts[index].title),
                  subtitle: Column(
                    children: [
                      posts[index].imageUrl != null ? Image.network(posts[index].imageUrl!) : Container(),
                      Text(posts[index].text),
                      Text(posts[index].date != null ?DateFormat('yyyy-MM-dd HH:mm:ss').format(posts[index].date!.toDate()) : '日付はありません'),
                    ],
                  ),
                ),
              );
            },
          ),
      
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditPage(),
            ),
          ).then((_) {
            _fetchFirebaseData();
          });
        },
        child: Icon(Icons.add),
      ),*/
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