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

  // 画像がない場合に表示するプレースホルダー
  Widget showImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.image, size: 50, color: Colors.grey),
    );
  }
}