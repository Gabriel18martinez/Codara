import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codara/authentication/components/show_confirmation_password.dart';
import 'package:codara/authentication/services/auth_service.dart';
import 'package:codara/models/course.dart';
import 'package:codara/navigationBar/screen/chapterScreen.dart';
import 'package:codara/navigationBar/screen/learnScreen.dart';
import 'package:codara/services/courseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePage();

}

class _HomePage extends State<HomePage> {
  CollectionReference listCourses = FirebaseFirestore.instance.collection('course');
  CourseService courseService = CourseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.grey,
                ),
                accountName: Text(
                    (widget.user.displayName != null)
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
          future: fetchUsers(),
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
                    final course = snapshot.data![index];
                    return ListTile(
                      title: Text(course['name']),
                      onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterScreen(
                            courseId: course['uid'],
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
        ],),
    );
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    List<Map<String, dynamic>> course = [];
    try {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('course');
      QuerySnapshot querySnapshot = await usersCollection.get();

      for (var doc in querySnapshot.docs) {
        course.add({
          'uid': doc.id,
          'name': doc['name'],
        });
      }
    } catch (e) {
      print('Erro ao buscar dados: $e');
    }
    return course;
  }

  // showFormModal({
  //   Course? model,
  //   required BuildContext context,
  // }) {
  //   // Labels à serem mostradas no Modal
  //   String labelTitle = "Adicionar Listin";
  //   String labelConfirmationButton = "Salvar";
  //   String labelSkipButton = "Cancelar";
  //
  //   // Controlador do campo que receberá o nome do Listin
  //   TextEditingController nameController = TextEditingController();
  //
  //   // Caso esteja editando
  //   if (model != null) {
  //     labelTitle = "Editando ${model.name}";
  //     nameController.text = model.name;
  //   }
  //
  //   // Função do Flutter que mostra o modal na tela
  //   showModalBottomSheet(
  //     context: context,
  //
  //     // Define que as bordas verticais serão arredondadas
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(24),
  //       ),
  //     ),
  //     builder: (context) {
  //       return Container(
  //         height: MediaQuery.of(context).size.height,
  //         padding: const EdgeInsets.all(32.0),
  //
  //         // Formulário com Título, Campo e Botões
  //         child: ListView(
  //           children: [
  //             Text(labelTitle, style: Theme.of(context).textTheme.headlineSmall),
  //             TextFormField(
  //               controller: nameController,
  //               decoration:
  //               const InputDecoration(label: Text("Nome do Listin")),
  //             ),
  //             const SizedBox(
  //               height: 16,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text(labelSkipButton),
  //                 ),
  //                 const SizedBox(
  //                   width: 16,
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     // Criar um objeto Listin com as infos
  //                     Course course = Course(
  //                       id: const Uuid().v1(),
  //                       name: nameController.text,
  //                     );
  //
  //                     // Usar id do model
  //                     if (model != null) {
  //                       course.id = model.id;
  //                     }
  //
  //                     // Salvar no Firestore
  //                     courseService.addCourse(course: course);
  //
  //                     // Atualizar a lista
  //                     refresh();
  //
  //                     // Fechar o Modal
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text(labelConfirmationButton),
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // refresh() async {
  //   List<Course> listaCourse = await courseService.readCourses();
  //   setState(() {
  //     listCourses = listaCourse;
  //   });
  // }

  // void remove(Course model) async {
  //   await courseService.removeCourse(courseId: model.id);
  //   refresh();
  // }
}

