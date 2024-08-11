import 'package:fight_app2/Model/Api/firebase_firestore.dart';
import 'package:fight_app2/Model/Api/firebase_storage.dart';
import 'package:fight_app2/View/Pages/top_page.dart';
import 'package:fight_app2/View/Widget/Image/new_post_image.dart';
import 'package:fight_app2/View/Widget/Text/new_post_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key,});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> with AutomaticKeepAliveClientMixin {

  final TextEditingController _textController = TextEditingController(text: '');
  String? _imageUrl;
  final formatter = DateFormat('yyyy-MM-dd');
  final _postTime = DateTime.now();

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
                        await FirebaseStorageApi().upload();
                      }
                    },
                    child: NewPostImage().showImage(),
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
                    child: NewPostText().showText(),//入力したテキストの表示
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(//保存ボタン
              onPressed: () async {
                if (_textController.text.isNotEmpty && _imageUrl != null) {
                  //修正の可能性あり
                  await FirebaseFirestoreApi().addUserToFirestore(User as User);
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
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, double.infinity),
              ),
            ),
          ],
        ),
      ),
    );
  }
}