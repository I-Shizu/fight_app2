import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String? message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('エラー'),
        content: Text(message ?? '不明なエラーが発生しました。'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}