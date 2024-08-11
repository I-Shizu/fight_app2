import 'package:fight_app2/View/Pages/list_page.dart';
import 'package:fight_app2/calendar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.list,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ListPage())
              );
            },
          )
        ],
      ),
      body: const Calendar(),//columnするとエラーになる
    );
  }
}
