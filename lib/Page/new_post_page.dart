import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fight_app2/Page/top_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key,});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> with AutomaticKeepAliveClientMixin {

  final TextEditingController _textController = TextEditingController(text: '');
  final DateTime _postTime = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd');
  String? _imageUrl;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(//今日の日付
              formatter.format(_postTime),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
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
                        return; // 画像が既に選択されている場合
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
                            title: const Text('がんばったこと'),
                            content: TextField(
                              controller: _textController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {});
                                  Navigator.of(context).pop();
                                }, 
                                child: const Text('おけ'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: showText(),//入力したテキストの表示
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(//保存ボタン
              onPressed: () async {
                if (_textController.text.isNotEmpty && _imageUrl != null) {
                  await _addToFirebase();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const TopPage(),
                    )
                  );
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

  Future upload() async {//画像をFirebaseStorageへアップロード
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
        setState(() {
          _imageUrl = imageUrl;
        });
      } catch (e) {
        return null;
      }
    }
    return;
  }

  Future<void> _addToFirebase() async {//ログインしてるユーザー情報を取得して、IDを作る
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final db = FirebaseFirestore.instance;

      final post = <String, dynamic>{
        "uid": user.uid,
        "text": _textController.text,
        "date": Timestamp.fromDate(_postTime),
        "imageUrl": _imageUrl,
      };
      
      await db.collection('posts').add(post);
    }
  }

  Widget showImage() {
    if(_imageUrl != null){
      return Container(
        margin: const EdgeInsets.all(5),
        child: Image.network(_imageUrl!),
      );
    } else {
      return Container(
        margin: const EdgeInsets.all(5),
        child: const Center(
          child: Text(
            'あっぷろーど',
            style: TextStyle(
              fontSize: 25,
            ),
          )
        ),
      );
    }
  }

  Widget showText() {
    if(_textController.text != ''){
      return Container(//入力されたテキストを表示
        margin: const EdgeInsets.all(10),
        child: Text(
          _textController.text,
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'てきすと',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      );
    }
  }
}