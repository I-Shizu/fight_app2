import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title;
  final String text;
  //final String image;
  final Timestamp? date;
  final String? imageUrl;

  Post({
    required this.title,
    required this.text,
    required this.date,
    required this.imageUrl,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      title: data['title'],
      text: data['text'],
      date: data['date'],
      imageUrl: data['imageUrl'],
    );
  }
}