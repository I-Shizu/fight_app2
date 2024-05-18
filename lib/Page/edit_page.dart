import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:fight_app/Page/album_page.dart';
import 'package:fight_app2/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


class EditPage extends StatefulWidget {
  const EditPage({super.key,});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final DateTime _postTime = DateTime.now();
  String? _imageUrl;
  //bool _upLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('今日頑張ったこと'),
        //backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'タイトル'),
            ),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'テキスト'),
            ),
            ElevatedButton(
              onPressed: ()  async{
               // 画像のアップロードを行う前に、画像が既に選択されているかを確認
                if (_imageUrl != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('エラー：既に画像が選択されています'),
                      duration: Duration(seconds: 3),
                    )
                  );
                  return; // 画像が既に選択されている場合は処理を中断
                }
                // 画像の選択とアップロードを行う
                await upload();
              },
              child: const Text('画像をアップロード'),
            ),
            if(_imageUrl != null)
              Image.network(_imageUrl!),
            ElevatedButton(
              onPressed: () async {
                if (_textController.text.isNotEmpty && _titleController.text.isNotEmpty && _imageUrl != null) {
                  // 画像のURLが取得されているかを確認
                  await _addToFirebase();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyApp()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('エラー：テキストとタイトルを入力し、画像をアップロードしてください'),
                      duration: Duration(seconds: 3),
                    )
                  );
                }
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }

  Future upload() async {
    // 画像をスマホのギャラリーから取得
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
        print('Uploaded image URL: $imageUrl');
        setState(() {
          _imageUrl = imageUrl;
        });
      } catch (e) {
        print('Error uploading image: $e'); 
      }
    }
    return;
  }

  Future<void> _addToFirebase() async {
    final db = FirebaseFirestore.instance;

    final post = <String, dynamic>{
      "title" : _titleController.text,
      "text" : _textController.text,
      "date" : Timestamp.fromDate(_postTime),
      "imageUrl" : _imageUrl,
    };
      
    await db.collection('posts').add(post);
  }
}