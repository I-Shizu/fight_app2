import 'package:flutter/material.dart';

class NewPostText {
  final TextEditingController textEditingController = TextEditingController(text: '');

  Widget showText() {
    if(textEditingController.text != ''){
      return Container(//入力されたテキストを表示
        margin: const EdgeInsets.all(10),
        child: Text(
          textEditingController.text,
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