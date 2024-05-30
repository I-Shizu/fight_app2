import 'package:fight_app2/calendar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8),//ここの調節をどうにかする
            ),
          ],
        ),
      ),
      // ignore: prefer_const_constructors
      body: CalendarPage(),//columnするとエラーになる
    );
  }
}
