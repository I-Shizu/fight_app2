import 'package:fight_app2/Config/firebase_options.dart';
import 'package:fight_app2/Controller/auth_controller.dart';
import 'package:fight_app2/View/Pages/login_page.dart';
import 'package:fight_app2/View/Pages/top_page.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
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
  final AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.hachiMaruPopTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: FutureBuilder(
        future: authController.checkAndLogin(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }else if(authController.isAuthentificated()){
            return TopPage();
          }else {
            return LoginPage();
          }
        },
      ),
    );
  }
}