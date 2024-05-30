import 'package:cloud_firestore/cloud_firestore.dart';
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
    Future<User?> signInWithGoogle(BuildContext context) async {
      try {
        final googleUser = await GoogleSignIn().signIn();
        //ログインキャンセル
        if(googleUser == null){
          return null;
        }
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        //firebaseの認証情報をuserCredentialに入れる
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;//ユーザー情報をuserに入れる
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
        if(user != null){
          await _addUserToFirestore(user);
        }
        return user;
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
          child: Text('Sign In with Google'),
        ),
      ),
    );
  }

  Future<void> ?_addUserToFirestore(User user) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final userDoc = await usersRef.doc(user.uid).get();

    if (!userDoc.exists) {
      await usersRef.doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'role': 'user',
      });
    }
  }
}