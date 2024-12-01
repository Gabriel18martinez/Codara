import 'package:codara/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> entrarUsuario ({
    required String email,
    required String password
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      print("conta logada");
    } on FirebaseAuthException catch (e){
      switch (e.code) {
        case "user-not-found":
          return "Usuário não encontrado.";
        case "wrong-password":
          return "Senha incorreta.";
      }

      return e.code;
    }

    return null;
  }

  Future<String?> cadastrarUsuario ({
    required String email,
    required String password,
    required String name
  }) async {
    try {
      UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      await userCredential.user!.updateDisplayName(name);
      Users(id: userCredential.user!.uid, email: email, name: name);
    } on FirebaseAuthException catch (e) {
      switch(e.code){
        case "email-already-in-use":
          return "O email já está em uso.";
      }
      return e.code;
    }
    return null;
  }

  Future<String?> redefinicaoSenha({required email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e){
      if (e.code == "user-not-found"){
        return "Email não encontrado";
      }
      return e.code;
    }
    return null;
  }

  Future<String?> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      e.code;
    }

    return null;
  }

  Future<String?> removeAccount({required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: _firebaseAuth.currentUser!.email!,
          password: password);
      await _firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      e.code;
    }
    return null;
  }
}