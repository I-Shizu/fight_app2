import 'package:flutter/material.dart';

class NewPostText {
  final String text;

  NewPostText({required this.text});

  Widget showText() {
    if(text != ''){
      return Container(//入力されたテキストを表示
        margin: const EdgeInsets.all(10),
        child: Text(
          text,
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