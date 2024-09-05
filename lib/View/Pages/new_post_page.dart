import 'dart:io';

import 'package:fight_app2/Controller/auth_controller.dart';
import 'package:fight_app2/Controller/post_controller.dart';
import 'package:fight_app2/Controller/storage_controller.dart';
import 'package:fight_app2/View/Pages/top_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key,});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> with AutomaticKeepAliveClientMixin {

  final PostController _postController = PostController();
  final AuthController _authController = AuthController();
  final StorageController _storageController = StorageController();
  final TextEditingController _postTextController = TextEditingController(text: '');

  File? _imageFile;
  String? _postImageUrl;
  
  final formatter = DateFormat('yyyy-MM-dd');
  final _postTime = DateTime.now();

  @override
  bool get wantKeepAlive => true;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final ImageFile = File(pickedFile.path);
      setState(() {
        _postImageUrl = ImageFile.path;
      });

      String? userId = _authController.getCurrentUserId();
      _storageController.uploadUserImage(userId!, _imageFile!).then((imageUrl) {
        setState(() {
          _postImageUrl = imageUrl;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 230,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      await _pickImage();
                    },
                    child: _postImageUrl != null
                      ? (_postImageUrl!.startsWith('http')
                          ? Image.network(_postImageUrl!)
                          : Image.file(File(_postImageUrl!)))
                      : const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 230,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context, 
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('がんばったこと'),
                            content: TextField(
                              controller: _postTextController,
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
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        _postTextController.text.isNotEmpty
                            ? _postTextController.text
                            : 'テキストを入力してください',
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(//保存ボタン
              onPressed: () async {
                if (_postTextController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('エラー：テキストを入力してください'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else if (_postImageUrl == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('エラー：画像を選択してください'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  await _postController.createPost(_postTextController.text, File(_postImageUrl!));
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const TopPage()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, double.infinity),
              ),
              child: const Text('ほぞん'),
            ),
          ],
        ),
      ),
    );
  }

  Widget showImage() {
    if(_postImageUrl != null){
      return Container(
        margin: const EdgeInsets.all(5),
        child: Image.network(_postImageUrl!),
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
    if(_postTextController.text.isNotEmpty){
      return Container(//入力されたテキストを表示
        margin: const EdgeInsets.all(10),
        child: Text(
          _postTextController.text,
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