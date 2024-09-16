import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String text;
  final Timestamp date;
  final String? imageUrl;

  Post({
    required this.id,
    required this.userId,
    required this.text,
    required this.date,
    this.imageUrl,
  });

  // Firestoreからデータを取得するためのファクトリコンストラクタ
  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      userId: data['userId'],
      text: data['text'],
      date: data['date'],
      imageUrl: data['imageUrl'],
    );
  }

  // Firestoreにデータを保存するためのメソッド
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'text': text,
      'date': date,
      'imageUrl': imageUrl,
    };
  }
}