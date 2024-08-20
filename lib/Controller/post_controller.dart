import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fight_app2/Model/Api/firebase_auth.dart';
import 'package:fight_app2/Model/Api/firebase_firestore.dart';
import 'package:fight_app2/Model/Api/firebase_storage.dart';
import 'package:fight_app2/Model/post.dart';
import 'package:table_calendar/table_calendar.dart';

class PostController {
  final FirebaseStorageApi _storageApi = FirebaseStorageApi();
  final FirestoreApi _postApi = FirestoreApi();
  final FirebaseAuthApi _authApi = FirebaseAuthApi();

  Future<void> createPost(String text, File imageFile) async {
    try {
      String? userId = _authApi.getCurrentUserId();
      if (userId == null) {
        throw Exception('ユーザーが認証されていません。再度ログインしてください。');
      }
      
      String imageUrl = await _storageApi.uploadUserImage(userId, imageFile);
      
      // 投稿データをFirestoreに保存
      Post post = Post(
        id: '',
        userId: userId,
        text: text,
        date: Timestamp.now(),
        imageUrl: imageUrl,
      );
      await _postApi.addPostToFirestore(post);
    } catch (e) {
      throw Exception('投稿の作成に失敗しました: $e');
    }
  }

  Future<List<Post>> getPostsForDay(DateTime day) async {
    try {
      // 日付(day)に投稿されたデータを取得
      List<Post> posts = await _postApi.getPosts();
      return posts.where((post) => isSameDay(post.date.toDate(), day)).toList();
    } catch (e) {
      throw Exception('投稿の取得に失敗しました: $e');
    }
  }

  Future<void> deletePost(String postId, String imageUrl) async {
    try {
      // Firestoreから投稿データを削除
      await _postApi.deletePost(postId);

      // Firebase Storageから画像を削除
      await _storageApi.deleteImage(imageUrl);
    } catch (e) {
      throw Exception('投稿の削除に失敗しました: $e');
    }
  }

}