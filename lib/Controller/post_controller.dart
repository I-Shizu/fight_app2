import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fight_app2/Controller/auth_controller.dart';
import 'package:fight_app2/Model/Api/firebase_firestore_api.dart';
import 'package:fight_app2/Model/Api/firebase_storage_api.dart';
import 'package:fight_app2/Model/post.dart';
import 'package:table_calendar/table_calendar.dart';

class PostController {
  final FirebaseStorageApi _storageApi = FirebaseStorageApi();
  final FirestoreApi _firestoreApi = FirestoreApi();
  final AuthController _authController = AuthController();

  Future<void> createPost(String text, File imageFile) async {
    await _authController.checkAndLogin();

    String? userId = _authController.getCurrentUserId();
    if (userId == null) {
      return;
    }

    try {
      //Firebase Storageにアップロードした画像をimageUrlに保存
      String imageUrl = await _storageApi.uploadImageToStorage(userId, imageFile);
      
      // Firestoreに保存したPostをpostに保存
      await FirebaseFirestore.instance.collection('posts').add({
        'id': '',
        'uid': userId,
        'text': text,
        'imageUrl': imageUrl,
        'date': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('投稿の作成に失敗しました: $e');
    }
  }

  Future<List<Post>> fetchPosts() async {
    try {
      String? userId = _authController.getCurrentUserId();
      if (userId == null) {
        throw Exception('ユーザーが認証されていません。再度ログインしてください。');
      }

      // Firestoreから投稿データを取得
      return await _firestoreApi.getPosts(userId);
    } catch (e) {
      throw Exception('投稿の取得に失敗しました: $e');
    }
  }

  Future<List<Post>> fetchPostsForDay(DateTime day) async {
    try {
      String? userId = _authController.getCurrentUserId();
      if (userId == null) {
        throw Exception('ユーザーが認証されていません。再度ログインしてください。');
      }

      // 日付(day)に投稿されたデータを取得
      List<Post> posts = await _firestoreApi.getPosts(userId);
      return posts.where((post) => isSameDay(post.date.toDate(), day)).toList();
    } catch (e) {
      throw Exception('指定日の投稿の取得に失敗しました: $e');
    }
  }

  Future<void> deletePost(String postId, String imageUrl) async {
    try {
      // Firestoreから投稿データを削除
      await _firestoreApi.deletePost(postId);

      // Firebase Storageから画像を削除
      await _storageApi.deleteImage(imageUrl);
    } catch (e) {
      throw Exception('投稿の削除に失敗しました: $e');
    }
  }

}