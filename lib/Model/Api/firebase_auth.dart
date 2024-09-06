import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthApi {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? checkCurrentUser() {
    return _auth.currentUser;
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password
      );
    return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('ユーザー登録に失敗しました: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('ログアウトに失敗しました: $e');
    }
  }

  Future<void> delete() async {
    await _auth.currentUser!.delete();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('パスワードリセットメールの送信に失敗しました: $e');
    }
  }

}