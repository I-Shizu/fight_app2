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
  String email = '';
  String passWord = '';
  String infoText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Column(
          children: [
            //メルアド、パスワードでログイン
            TextFormField(
              decoration: InputDecoration(labelText: 'メールアドレス'),
              onChanged: (String value) {
                setState(() {
                  email = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'パスワード'),
              obscureText: true,
              onChanged: (String value) {
                setState(() {
                  passWord = value;
                });
              },
            ),
            Container(
              width: double.infinity,
              // ユーザー登録ボタン
              child: ElevatedButton(
                child: Text('ユーザー登録'),
                onPressed: () async {
                  try {
                    // メール/パスワードでユーザー登録
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    await auth.createUserWithEmailAndPassword(
                      email: email,
                      password: passWord,
                    );
                    // ユーザー登録に成功した場合
                    // チャット画面に遷移＋ログイン画面を破棄
                    await Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) {
                          return TopPage();
                        }
                      ),
                      (route) => false,
                    );
                  } catch (e) {
                    // ユーザー登録に失敗した場合
                    setState(() {
                      infoText = "登録に失敗しました：${e.toString()}";
                    });
                  }
                },
              ),
            ),
            
            Text('or'),

            //匿名認証
            ElevatedButton(
              onPressed: () async {
                anonymousLogin();
              }, 
              child: Text('登録しないでつかう'),
            ),

            Text('or'),

            //googleログイン
            ElevatedButton(
              onPressed: () async{
                signInWithGoogle(context);
              }, 
              child: const Text('Googleで登録'),
            ),
          ],
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

  Future<void> anonymousLogin() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signInAnonymously();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) {
              return const TopPage();
            }
          ),
          (route) => false,
      );
    } catch (e) {
      if(e is PlatformException && e.code == 'sign_in_canceled'){
      } else {
        throw e.toString();
      }
    }
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