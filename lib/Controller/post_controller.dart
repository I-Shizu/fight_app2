import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fight_app2/Model/Api/firebase_firestore.dart';
import 'package:fight_app2/Model/Api/firebase_storage.dart';
import 'package:fight_app2/Model/post.dart';

class PostController {
  final FirebaseStorageApi _storageApi = FirebaseStorageApi();
  final FirestoreApi _postApi = FirestoreApi();

  Future<void> createPost(String text, File imageFile) async {
    try {
      // 画像ファイルをFirebase Storageにアップロード
      String imageUrl = await _storageApi.uploadFile('uploads/images/${imageFile.path.split('/').last}', imageFile);
      
      // 投稿データをFirestoreに保存
      Post post = Post(
        id: '',
        userId: 'someUserId',
        text: text,
        date: Timestamp.now(),
        imageUrl: imageUrl,
      );
      await _postApi.addPostToFirestore(post);

    } catch (e) {
      Exception('投稿の作成に失敗しました: $e');
    }
  }
}