import 'package:fight_app2/Page/album_page.dart';
import 'package:fight_app2/Page/home_page.dart';
import 'package:fight_app2/Page/new_post_page.dart';
import 'package:flutter/material.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int _currentIndex = 0;
  final _pageWidgets = [
    HomePage(),
    const NewPostPage(),
    const AlbumPage(),
  ];
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body:  _pageWidgets.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ほーむ'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'にゅー'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_album), label: 'あるばむ'),
        ],
        currentIndex: _currentIndex,
        fixedColor: Colors.blueAccent,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ), 
    );
  }

  void _onItemTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }
}