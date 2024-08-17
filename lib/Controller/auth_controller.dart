import 'package:fight_app2/Model/Api/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  final FirebaseAuthApi _authApi = FirebaseAuthApi();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> registerUser(String email, String password) async {
    try {
      User? user = await _authApi.signUpWithEmail(email, password);
      if (user != null) {
        Exception('登録成功: ${user.email}');
      }
    } catch (e) {
      Exception('登録に失敗しました: $e');
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      User? user = await _authApi.signInWithEmail(email, password);
      if (user != null) {
        Exception('ログイン成功: ${user.email}');
      }
    } catch (e) {
      Exception('ログインに失敗しました: $e');
    }
  }

  Future<void> logoutUser() async {
    await _authApi.signOut();
    Exception('ログアウトしました');
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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