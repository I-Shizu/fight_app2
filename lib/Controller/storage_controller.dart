import 'package:fight_app2/Model/Api/firebase_storage.dart';

class StorageController {
  final FirebaseStorageApi _storageApi = FirebaseStorageApi();

  Future<void> deleteImage(String imageUrl) async {
    try {
      await _storageApi.deleteImage(imageUrl);
    } catch (e) {
      throw Exception('画像の削除に失敗しました: $e');
    }
  }
}