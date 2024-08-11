import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageApi {

  Future upload() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // 画像を取得できた場合はFirebaseStorageにアップロードする
    if (image != null) {
      final imageFile = File(image.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      final imageName = 'image_$timeStamp.jpg';

      try {
        final TaskSnapshot uploadTask = await storage.ref(imageName).putFile(imageFile);
        final String imageUrl = await uploadTask.ref.getDownloadURL();
        return imageUrl;
      } catch (e) {
        return null;
      }
    }
    return;
  }
}