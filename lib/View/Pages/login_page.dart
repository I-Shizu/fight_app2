import 'package:fight_app2/Controller/auth_controller.dart';
import 'package:fight_app2/Utils/dialog_util.dart';
import 'package:fight_app2/View/Pages/top_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //グーグルログイン機能使えないのでとりあえずコメントアウト
            /*Center(
              child: ElevatedButton(
                onPressed: () async{
                  LoginController().signInWithGoogle(context);
                }, 
                child: const Text('Sign In with Google'),
              ),
            ),*/
            Text(
              'まだアカウントをお持ちでない方はこちら',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            TextFormField(
              controller: _authController.emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: _authController.passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = await _authController.registerUser(
                  _authController.emailController.text,
                  _authController.passwordController.text,
                );
                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const TopPage(),
                    ),
                  );
                } else {
                  showErrorDialog(context, "認証に失敗しました。再度お試しください。");
                }
              }, 
              child: const Text('新規登録'),
            ),
            SizedBox(height: 20),
            Text(
              'すでにアカウントをお持ちの方はこちら',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = await _authController.loginUser(
                  _authController.emailController.text,
                  _authController.passwordController.text,
                );
                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const TopPage(),
                    ),
                  );
                } else {
                  showErrorDialog(context, "認証に失敗しました。再度お試しください。");
                }
              },
              child: const Text('ログイン'),
            ),
          ],
        ),
      ),
    );
  }
}