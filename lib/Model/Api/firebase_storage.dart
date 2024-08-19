import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseStorageApi {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ファイルをアップロードし、そのダウンロードURLを返す
  Future<String> uploadFile(String path, File file) async {
    try {
      Reference ref = _storage.ref().child(path);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('ファイルのアップロードに失敗しました: $e');
    }
  }

  // ダウンロードURLを取得
  Future<String> getDownloadURL(String path) async {
    try {
      return await _storage.ref().child(path).getDownloadURL();
    } catch (e) {
      throw Exception('ダウンロードURLの取得に失敗しました: $e');
    }
  }

  // ファイルを削除
  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } catch (e) {
      throw Exception('ファイルの削除に失敗しました: $e');
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      // documentのプロパティ(imageUrl)のURLからファイルを抽出する
      final RegExp regex = RegExp(r'\/o\/(.*)\?alt');
      final match = regex.firstMatch(imageUrl);
      if (match != null) {
        final imageName = match.group(1);
        if (imageName != null) {
          await _storage.refFromURL(imageUrl).delete();
        }
      }
    } catch (e) {
      throw Exception('画像の削除に失敗しました: $e');
    }
  }
}