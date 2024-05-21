import 'package:fight_app2/Page/album_page.dart';
import 'package:fight_app2/Page/new_post_page.dart';
import 'package:fight_app2/Page/home_page.dart';
import 'package:fight_app2/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( 
     MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.hachiMaruPopTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: FightApp(),
    );
  }
}
class FightApp extends StatefulWidget {
  const FightApp({super.key});

  @override
  State<FightApp> createState() => _FightAppState();
}

class _FightAppState extends State<FightApp> {
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'new'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_album), label: 'Album'),
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


