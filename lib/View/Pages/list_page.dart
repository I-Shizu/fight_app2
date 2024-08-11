import 'package:fight_app2/View/Pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('リストページ'),
      ),
      body: ElevatedButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
        }, 
        child: Text('ログアウト'),
      ),
    );
  }
}