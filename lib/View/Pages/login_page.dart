import 'package:fight_app2/Controller/login_controller.dart';
import 'package:fight_app2/Controller/register_controller.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
            //グーグルログイン機能使えないのでコメントアウト
            /*Center(
              child: ElevatedButton(
                onPressed: () async{
                  LoginController().signInWithGoogle(context);
                }, 
                child: const Text('Sign In with Google'),
              ),
            ),*/
            TextFormField(
              controller: LoginController().emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: LoginController().passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                RegisterController().registerWithMailAndPassWord(context);
              }, 
              child: const Text('新規登録'),
            ),
            ElevatedButton(
              onPressed: () {
                LoginController().signInWithMailAndPassword(context);
              },
              child: const Text('ログイン'),
            ),
          ],
        ),
      ),
    );
  }
}