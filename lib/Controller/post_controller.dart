import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fight_app2/Model/Api/firebase_auth_api.dart';
import 'package:fight_app2/Model/Api/firebase_firestore_api.dart';
import 'package:fight_app2/Model/Api/firebase_storage_api.dart';
import 'package:fight_app2/Model/post.dart';
import 'package:table_calendar/table_calendar.dart';

class PostController {
  final FirebaseStorageApi _storageApi = FirebaseStorageApi();
  final FirestoreApi _firestoreApi = FirestoreApi();
  final FirebaseAuthApi _authApi = FirebaseAuthApi();

  Future<void> createPost(String text, File imageFile) async {
    try {
      // ユーザーが認証されているか確認
      String? userId = _authApi.getCurrentUserId();
      if (userId == null) {
        throw Exception('ユーザーが認証されていません。再度ログインしてください。');
      }

      //画像をFirebase Storageにアップロード
      String imageUrl = await _storageApi.uploadUserImage(userId, imageFile);
      
      // 投稿データをFirestoreに保存
      Post post = Post(
        id: '',
        userId: userId,
        text: text,
        date: Timestamp.now(),
        imageUrl: imageUrl,
      );
      await _firestoreApi.addPostToFirestore(post);
    } catch (e) {
      throw Exception('投稿の作成に失敗しました: $e');
    }
  }

  Future<List<Post>> fetchPosts() async {
    try {
      // ユーザーが認証されているか確認
      String? userId = _authApi.getCurrentUserId();
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
      // ユーザーが認証されているか確認
      String? userId = _authApi.getCurrentUserId();
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