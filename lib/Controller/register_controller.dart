import 'package:fight_app2/Model/firebase_model.dart';
import 'package:fight_app2/Utils/dialog_util.dart';
import 'package:fight_app2/View/Pages/top_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class RegisterController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> registerWithMailAndPassWord(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        await FirebaseController().addUserToFirestore(user);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return const TopPage();
            }
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showErrorDialog(context, 'このメールアドレスは既に登録されています。');
      } else if (e.code == 'invalid-email') {
        showErrorDialog(context, '無効なメールアドレスです。');
      } else if (e.code == 'operation-not-allowed') {
        showErrorDialog(context, 'メール/パスワードのアカウントは有効になっていません。');
      } else if (e.code == 'weak-password') {
        showErrorDialog(context, 'パスワードが弱すぎます。');
      } else {
        showErrorDialog(context, e.message);  // その他のエラーの場合もメッセージを表示
      }
    } catch (e) {
      showErrorDialog(context, e.toString());  // エラーダイアログを表示
    }
  }
}