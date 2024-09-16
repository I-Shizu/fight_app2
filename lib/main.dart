import 'package:fight_app2/Config/firebase_options.dart';
import 'package:fight_app2/Controller/auth_controller.dart';
import 'package:fight_app2/View/Pages/login_page.dart';
import 'package:fight_app2/View/Pages/top_page.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
  appleProvider: kReleaseMode ? AppleProvider.deviceCheck : AppleProvider.debug,
  );

  runApp( 
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final AuthController authController = AuthController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.hachiMaruPopTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }else if(authController.isAuthentificated()){
            return const TopPage();
          }else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}