import 'package:fight_app2/Model/Api/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  final FirebaseAuthApi _authApi = FirebaseAuthApi();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  User? get currentUser => _currentUser;

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Future<void> checkAndLogin() async {
    _currentUser = await _authApi.checkCurrentUser();

    if (_currentUser == null) {
      return null;
    }
  }

  void checkUserAuthentication() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print("ユーザーが認証されていません。ログインしてください。");
    // 必要に応じてログインページに遷移するコードを追加
  } else {
    print("ユーザーが認証されています。ユーザーID: ${user.uid}");
  }
}
 
  Future<User?> registerUser(String email, String password) async {
    try {
      _currentUser = await _authApi.signUpWithEmail(email, password);
      return _currentUser;
    } catch (e) {
      return null;
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      _currentUser = await _authApi.signInWithEmail(email, password);
      return _currentUser;
    } catch (e) {
      return null;
    }
  }

  Future<void> logoutUser() async {
    await _authApi.signOut();
    return _currentUser = null;
  }

  bool isAuthentificated() {
    return _currentUser != null;
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}