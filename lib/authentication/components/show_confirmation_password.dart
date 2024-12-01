import 'package:codara/authentication/services/auth_service.dart';
import 'package:flutter/material.dart';

showConfirmationPasswordDialog ({
  required BuildContext context,
  required String email,}) {
  showDialog(context: context, builder: (context) {
    TextEditingController confirmationPasswordController = TextEditingController();
    return AlertDialog(
      title: Text("Deseja confirmar a remoção do email $email?"),
      content: SizedBox(
        height: 175,
        child: Column(
          children: [
            const Text("Para confirmar a remoção digite a sua senha:"),
            TextFormField(
              controller: confirmationPasswordController,
              obscureText: true,
              decoration: const InputDecoration(label: Text("Senha")),
            )
          ]
        ),
      ),
      actions: [
        TextButton(
          onPressed: (){
            AuthService().removeAccount(password: confirmationPasswordController.text)
            .then((String? error) {
              if(error == null) {
                Navigator.pop(context);
              }
            });
          },
          child: const Text("EXCLUIR CONTA"),)
      ],
    );
  });
}