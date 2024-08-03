import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fight_app2/Page/top_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fight_app2/Utils/dialog_utils.dart';
//import 'package:flutter/services.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),

      body: Column(
        children: [
          //グーグルログイン機能使えないのでコメントアウト
          /*Center(
            child: ElevatedButton(
              onPressed: () async{
                signInWithGoogle(context);
              }, 
              child: const Text('Sign In with Google'),
            ),
          ),*/
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () {
              registerWithMailAndPassWord(context);
            }, 
            child: const Text('新規登録'),
          ),
          ElevatedButton(
            onPressed: () {
              signInWithMailAndPassword(context);
            },
            child: const Text('ログイン'),
          ),
        ],
      ),
    );
  }

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
        await _addUserToFirestore(user);
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

  Future<void> ?_addUserToFirestore(User user) async {
    final usersRef = FirebaseFirestore.instance.collection('user_data');
    final userDoc = await usersRef.doc(user.uid).get();

    if (!userDoc.exists) {
      await usersRef.doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
      });
    }
  }
}