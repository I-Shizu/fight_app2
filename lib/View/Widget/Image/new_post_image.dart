import 'package:flutter/material.dart';

class NewPostImage {
  String? _imageUrl;

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
}