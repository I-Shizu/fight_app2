import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fight_app2/Page/top_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
            signInWithGoogle(context);
          }, 
          child: const Text('Sign In with Google'),
        ),
      ),
    );
  }

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
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) {
                return const TopPage();
              }
            ),
            (route) => false,
          );
        }
        if(user != null){
          await _addUserToFirestore(user);
        }
        return user;
      } catch (e) {
        if(e is PlatformException && e.code == 'sign_in_canceled'){
        } else {
          throw e.toString();
        }
      }
      return null;
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