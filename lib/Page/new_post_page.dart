import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fight_app2/Utils/tategaki.dart';
import 'package:fight_app2/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key,});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {

  final TextEditingController _textController = TextEditingController();
  final DateTime _postTime = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd');
  String? _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(//今日の日付
              formatter.format(_postTime),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Container(//画像のアップロード
                  width: double.infinity,// 横幅いっぱいまで広がる
                  height: 230,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GestureDetector(//タップやドラックなど、ユーザーのアクションに対して関数を返すことができる
                    onTap: () async {
                      // 画像のアップロードを行う前に、画像が既に選択されているかを確認
                      if (_imageUrl != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('エラー：もうがぞうあるよ'),
                            duration: Duration(seconds: 3),
                          )
                        );
                        return; // 画像が既に選択されている場合は処理を中断
                      } else {
                        await upload();
                      }
                    },
                    child: showImage(),
                  ),
                ),
                Container(//テキストの入力
                  width: double.infinity,// 横幅いっぱいまで広がる
                  height: 230,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GestureDetector(//タップやドラックなど、ユーザーのアクションに対して関数を返すことができる
                    onTap: () {
                      showDialog(
                        context: context, 
                        builder: (context) {
                          return AlertDialog(
                            title: Text('がんばったこと'),
                            content: TextField(
                              controller: _textController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {});
                                  Navigator.of(context).pop();
                                }, 
                                child: Text('おけ'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(//入力されたテキストを表示
                      width: double.infinity,
                      height: 230,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Tategaki(
                        text: _textController.text,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            ElevatedButton(//保存ボタン
              onPressed: () async {
                if (_textController.text.isNotEmpty && _imageUrl != null) {
                  // 画像のURLが取得されているかを確認
                  await _addToFirebase();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyApp()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('エラー：テキストを入力し、画像をアップロードしてください'),
                      duration: Duration(seconds: 2),
                    )
                  );
                }
              },
              child: const Text('ほぞん'),
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
      "text" : _textController.text,
      "date" : Timestamp.fromDate(_postTime),
      "imageUrl" : _imageUrl,
    };
      
    await db.collection('posts').add(post);
  }

  Widget showImage() {
    if(_imageUrl != null){
      return Container(
        width: double.infinity,
        height: 230,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(13),
        ),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Image.network(_imageUrl!)
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: 230,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text('あっぷろーど')
        ),
      );
    }
  }
}