import 'package:fight_app2/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    Future<UserCredential?> signInWithGoogle(BuildContext context) async {
      try {
        final googleUser = await GoogleSignIn().signIn();
        final googleAuth = await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        //firebaseの認証情報をuserCredentialに入れる
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        if(context.mounted){
          print('ログインに成功しました');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) {
                return FightApp();
              }
            ),
            (route) => false,
          );
        };
        return userCredential;
      } catch (e) {
        if(e is PlatformException && e.code == 'sign_in_canceled'){
          print('ログインをキャンセルしました');
        } else {
          throw e.toString();
        }
      }
      return null;
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
            signInWithGoogle(context);
          }, 
          child: Text('Sign In'),
        ),
      ),
    );
  }
}