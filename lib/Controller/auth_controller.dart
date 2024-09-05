import 'package:fight_app2/Model/Api/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  final FirebaseAuthApi _authApi = FirebaseAuthApi();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get _currentUser => _auth.currentUser;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Future<void> checkAndLogin() async {
    if (_currentUser == null) {
      print("ユーザーが認証されていません。ログインしてください。");
    } else {
      print("ユーザーが認証されています。ユーザーID: ${_currentUser!.uid}");
    }
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