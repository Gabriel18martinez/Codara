import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codara/authentication/components/show_snackbar.dart';
import 'package:codara/authentication/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'login.dart';
import '../../models/users.dart';

class SignUpEmail extends StatelessWidget {

  SignUpEmail({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
              "Digite os dados de cadastro nos campos abaixo.",
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
                )
              ),
            ),
            CupertinoTextField(
              controller: passwordController,
              cursorColor: Colors.pinkAccent,
              padding: const EdgeInsets.all(15),
              placeholder: "Digite a sua senha",
              placeholderStyle: const TextStyle(color: customColor, fontSize: 14),
              style: const TextStyle(color: customColor, fontSize: 14),
              decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  )
              ),
            ),
            const CupertinoTextField(
              cursorColor: Colors.pinkAccent,
              padding: EdgeInsets.all(15),
              placeholder: "Digite a sua senha novamente",
              placeholderStyle: TextStyle(color: customColor, fontSize: 14),
              style: TextStyle(color: customColor, fontSize: 14),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  )
              ),
            ),
            CupertinoTextField(
              controller: nameController,
              cursorColor: Colors.pinkAccent,
              padding: const EdgeInsets.all(15),
              placeholder: "Digite o seu nome",
              placeholderStyle: const TextStyle(color: customColor, fontSize: 14),
              style: const TextStyle(color: customColor, fontSize: 14),
              decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  )
              ),
            ),
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
                  _createUsuer(
                      context: context,
                      email: emailController.text,
                      name: nameController.text,
                      password: passwordController.text);
                },
              ),
            ),
          ],
        )
      )
    );
  }

  _createUsuer({
    required BuildContext context,
    required String email,
    required String name,
    required String password
  }){
    authService.cadastrarUsuario(
        email: email,
        password: password,
        name: name).then(
            (String? error) {
              if (error != null) {
                showSnackBar(
                    context: context,
                    mensagem: error);
              } else {

              }
            }
    );
  }
}

