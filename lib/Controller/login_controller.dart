import 'package:fight_app2/Utils/dialog_util.dart';
import 'package:fight_app2/View/Pages/top_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithMailAndPassword(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return const TopPage();
            }
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      showErrorDialog(context, e.message);  // エラーダイアログを表示
    } catch (e) {
      showErrorDialog(context, e.toString());  // エラーダイアログを表示
    }
  }
  
  //グーグルログイン機能使えないのでコメントアウト
  /*Future<User?> signInWithGoogle(BuildContext context) async {
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
  }*/
}