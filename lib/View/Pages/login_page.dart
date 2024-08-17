import 'package:fight_app2/Controller/auth_controller.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = AuthController().emailController;
  final password = AuthController().passwordController;

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
              controller: email,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: password,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                AuthController().registerUser(email as String, password as String);
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
              onPressed: () {
                AuthController().loginUser(email as String, password as String);
              },
              child: const Text('ログイン'),
            ),
          ],
        ),
      ),
    );
  }
}