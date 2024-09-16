import 'package:fight_app2/Model/Api/firebase_auth_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  final FirebaseAuthApi _authApi = FirebaseAuthApi();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Future<User?> checkAndLogin() async {
    if (_auth.currentUser == null) {
      try {
        // 認証されていない場合、ログインを試行
        UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        return credential.user;
      } catch (e) {
        // エラーハンドリング (例: エラーメッセージの表示)
        debugPrint('ログインに失敗しました: $e');
        return null;
      }
    }
    return _auth.currentUser;
  }
 
  Future<User?> registerUser(String email, String password) async {
    try {
      User? user = await _authApi.signUpWithEmail(email, password);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      User? user = await _authApi.signInWithEmail(email, password);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> logoutUser() async {
    await _authApi.signOut();
  }

  bool isAuthentificated() {
    return _auth.currentUser != null;
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}