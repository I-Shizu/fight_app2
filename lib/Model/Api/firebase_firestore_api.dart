import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fight_app2/Model/post.dart';

class FirestoreApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'posts';
  final String _userIdPath = 'userId';
  final String _datePath = 'date';

  Future<List<Post>> getPosts(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection(_collectionPath)
        .where(_userIdPath, isEqualTo: userId)
        .orderBy(_datePath, descending: true)
        .limit(10)
        .get();

    return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }

  Future<void> addPostToFirestore(Post post) async {
   await _firestore.collection(_collectionPath).add(post.toFirestore());
  }

  Future<void> deletePost(String postId) async {
    await _firestore.collection(_collectionPath).doc(postId).delete();
  }
}