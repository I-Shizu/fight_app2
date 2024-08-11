import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fight_app2/View/Widget/Text/new_post_text.dart';
import 'package:fight_app2/Model/post.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreApi {
  final _instance = FirebaseFirestore.instance;
  String? imageUrl;
  DateTime postTime = DateTime.now();

  void fetchFirebaseData() async {
    final db = FirebaseFirestore.instance;

    final events = await db
      .collection("posts")
      .orderBy("date", descending: true)
      .limit(10)
      .get();
    final docs = events.docs;
    final posts = docs.map((doc) => Post.fromFirestore(doc)).toList();
  }
  
  //firestoreとfirebaseauthが混ざっているので、firebaseauthの役割を映す
  Future<void> addUserToFirestore(User user) async {
    final usersRef = FirebaseFirestore.instance.collection('user_data');
    final userDoc = await usersRef.doc(user.uid).get();

    if (!userDoc.exists) {
      await usersRef.doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
      });
    }
  }

    //authとstoreが混ざっているので、authの役割を映す
  Future<void> _addToFirebase() async {//ログインしてるユーザー情報を取得して、IDを作る
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final db = FirebaseFirestore.instance;

      final post = <String, dynamic>{
        "uid": user.uid,
        "text": NewPostText().textEditingController.text,
        "date": Timestamp.fromDate(postTime),
        "imageUrl": imageUrl,
      };
      
      await db.collection('posts').add(post);
    }
  }

}