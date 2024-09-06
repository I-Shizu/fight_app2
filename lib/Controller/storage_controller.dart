import 'dart:io';

import 'package:fight_app2/Model/Api/firebase_storage_api.dart';

class StorageController {
  final FirebaseStorageApi _storageApi = FirebaseStorageApi();

  Future<String> uploadUserImage(String userId, File file) async {
    try {
      return await _storageApi.uploadUserImage(userId, file);
    } catch (e) {
      throw Exception('ファイルのアップロードに失敗しました: $e');
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      await _storageApi.deleteImage(imageUrl);
    } catch (e) {
      throw Exception('画像の削除に失敗しました: $e');
    }
  }
}