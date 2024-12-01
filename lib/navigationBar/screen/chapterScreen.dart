import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codara/navigationBar/screen/learnScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../HomePage.dart';
import '../../authentication/components/show_confirmation_password.dart';
import '../../authentication/services/auth_service.dart';

class ChapterScreen extends StatefulWidget {
  final String courseId;
  final User user;

  const ChapterScreen({Key? key, required this.courseId, required this.user});

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Map<String, dynamic>> chapters = [];

    Future<List<Map<String, dynamic>>> fetchChapters(String courseId) async {
      List<Map<String, dynamic>> chapters = [];
      try {
        // Referência à coleção 'quizzes' aninhada em 'users'
        CollectionReference contentsCollection = FirebaseFirestore.instance
            .collection('course')
            .doc(courseId)
            .collection('chapters');

        // Buscar documentos
        QuerySnapshot querySnapshot = await contentsCollection.get();

        // Iterar pelos documentos e adicionar os dados à lista
        for (var doc in querySnapshot.docs) {
          chapters.add({
            'uid': doc.id,
            'name': doc['name'],
          });
        }
      } catch (e) {
        print('Erro ao buscar contents: $e');
      }
      return chapters;
    }

    return Scaffold(
      drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.grey,
                  ),
                  accountName: Text(
                      (widget.user != null)
                          ? widget.user.displayName!
                          : ""
                  ),
                  accountEmail: Text(widget.user.email!)
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red,),
                title: const Text("Deletar conta"),
                onTap: () {
                  showConfirmationPasswordDialog(context: context, email: "");
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Sair"),
                onTap: () {
                  AuthService().logOut();
                },
              ),
            ],
          )
      ),
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchChapters(widget.courseId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erro: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Nenhum dado encontrado"));
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final chapters = snapshot.data![index];
                    return ListTile(
                      title: Text(chapters['name']),
                      onTap: () {
                        print(widget.courseId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LearnScreen(
                              chapterId: chapters['uid'],
                              courseId: widget.courseId,
                              user: widget.user,
                            ),
                          ),
                        );
                      },
                    );
                  }
              );
            }
          }
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Aprender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Perfil",
          ),
        ],
        onTap: (index) {
          setState((){
            if(index == 0){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(user: widget.user),)
              );
            }
          });
      })
    );
  }

}