import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String userId;
  final String text;
  final Timestamp? date;
  final String? imageUrl;

  Post({
    required this.userId,
    required this.text,
    required this.date,
    required this.imageUrl,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      userId: data['userId'],
      text: data['text'],
      date: data['date'],
      imageUrl: data['imageUrl'],
    );
  }
}