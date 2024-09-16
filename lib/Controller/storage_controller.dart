import 'dart:io';

import 'package:fight_app2/Controller/auth_controller.dart';
import 'package:fight_app2/Model/Api/firebase_storage_api.dart';

class StorageController {
  final FirebaseStorageApi _storageApi = FirebaseStorageApi();
  final AuthController _authController = AuthController();

  Future<String> uploadUserImage(String userId, File file) async {
    if(_authController.getCurrentUserId() == null) {
      await _authController.checkAndLogin();
    }
    return await _storageApi.uploadImageToStorage(userId, file);
  }

  Future<void> deleteImage(String imageUrl) async {
    await _storageApi.deleteImage(imageUrl);
  }
}