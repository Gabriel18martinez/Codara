import 'package:codara/HomePage.dart';
import 'package:codara/authentication/components/show_snackbar.dart';
import 'package:codara/authentication/services/auth_service.dart';
import 'package:codara/authentication/screens/signUpEmail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color customColor = Color(0xFF175268);

class LoginPage extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  LoginPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body:
      SingleChildScrollView(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20), // Espaçamento do topo
            const Image(
              image: AssetImage("assets/images/4513b6fe-9c5c-4211-9d1e-2fb78abe4be3.png"),
              width: 300,
            ),
            const SizedBox(height: 30),
            const Text(
              "Digite os dados de acesso nos campos abaixo.",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            CupertinoTextField(
              controller: emailController,
              cursorColor: Colors.pinkAccent,
              padding: const EdgeInsets.all(15),
              placeholder: "Digite o seu e-mail",
              placeholderStyle: const TextStyle(color: customColor, fontSize: 14),
              style: const TextStyle(color: customColor, fontSize: 14),
              decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  )),
            ),
            const SizedBox(height: 5),
            CupertinoTextField(
              controller: passwordController,
              padding: const EdgeInsets.all(15),
              cursorColor: Colors.pinkAccent,
              placeholder: "Digite sua senha",
              obscureText: true,
              placeholderStyle: const TextStyle(color: customColor, fontSize: 14),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  )),
            ),
            TextButton(onPressed: () {
              esqueciMinhaSenha(context: context, email: emailController.text);
            }, child: Text("Esqueci minha senha")),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                padding: const EdgeInsets.all(17),
                color: customColor,
                child: const Text(
                  "Acessar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                      signIn(
                          context: context,
                          email: emailController.text,
                          password: passwordController.text
                      );
                },
              ),
            ),
            const SizedBox(height: 7),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: customColor, width: 0.8),
                  borderRadius: BorderRadius.circular(7)),
              child: CupertinoButton(
                color: customColor,
                child: const Text(
                  "Crie sua conta",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpEmail()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  esqueciMinhaSenha({
    required String email,
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController redefincaoSenhaController =
        TextEditingController(text: email);
        return AlertDialog(
          title: const Text("Confirme o e-mail para redefinição de senha"),
          content: TextFormField(
            controller: redefincaoSenhaController,
            decoration: const InputDecoration(label: Text("Confirme o e-mail")),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32))),
          actions: [
            TextButton(
              onPressed: () {
                _auth
                    .redefinicaoSenha(email: redefincaoSenhaController.text)
                    .then((String? erro) {
                  if (erro == null) {
                    showSnackBar(
                      context: context,
                      mensagem: "E-mail de redefinição enviado!",
                      isErro: false,
                    );
                  } else {
                    showSnackBar(context: context, mensagem: erro);
                  }
                  Navigator.pop(context);
                });
              },
              child: const Text("Redefinir senha"),
            ),
          ],
        );
      },
    );
  }

  signIn({
    required BuildContext context,
    required String email,
    required String password
  }) {
    _auth.entrarUsuario(
        email: email,
        password: password).then(
          (String? error) {
            if (error != null) {
              showSnackBar(
                  context: context,
                  mensagem: error
              );
            }
          }
        );
  }

}