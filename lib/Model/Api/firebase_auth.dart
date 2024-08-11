import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationApi {
  final _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInEmail({required String email, required String password}) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUpEmail({required String email, required String password}) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> delete() async {
    await _auth.currentUser!.delete();
  }

}