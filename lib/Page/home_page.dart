import 'package:fight_app2/Page/calendar_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.blue,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8),//ここの調節をどうにかする
              //child: Text('頑張る日記'),
            ),
          ],
        ),
      ),
      body: CalendarPage(),//columnするとエラーになる
    );
  }
}
