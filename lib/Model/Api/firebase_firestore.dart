import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fight_app2/Model/post.dart';

class FirestoreApi {
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'posts';

  // Firestoreから投稿データを取得
  Future<List<Post>> getPosts() async {
    final querySnapshot = await _firestore
        .collection(_collectionPath)
        .orderBy('date', descending: true)
        .limit(10)
        .get();

    return querySnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }

  // Firestoreに投稿データを追加
  Future<void> addPostToFirestore(Post post) async {
   await _firestore.collection(_collectionPath).add(post.toFirestore());
  }

  Future<void> deletePost(String postId) async {
    await _firestore.collection(_collectionPath).doc(postId).delete();
  }
}