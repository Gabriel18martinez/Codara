import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codara/HomePage.dart';
import 'package:codara/navigationBar/screen/chapterScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LearnScreen extends StatefulWidget {

  final String chapterId;

  final String courseId;

  final User user;

  const LearnScreen({Key? key, required this.chapterId, required this.courseId, required this.user});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {

  List<Map<String, dynamic>> contents = [];
  int currentQuestionIndex = 0; // Índice da pergunta atual
  bool isLoading = true;

  Future<List<Map<String, dynamic>>> fetchContents(String chapterId, String courseId) async {
    List<Map<String, dynamic>> contents = [];
    try {
      // Referência à coleção 'quizzes' aninhada em 'users'
      CollectionReference contentsCollection = FirebaseFirestore.instance
          .collection('course')
          .doc(courseId)
          .collection('chapters')
          .doc(chapterId)
          .collection('content');

      // Buscar documentos
      QuerySnapshot querySnapshot = await contentsCollection.get();

      // Iterar pelos documentos e adicionar os dados à lista
      for (var doc in querySnapshot.docs) {
        contents.add(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Erro ao buscar contents: $e');
    }
    return contents;
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < contents.length - 1) {
        currentQuestionIndex++;
      } else {
        _showCompletionDialog();

      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Parabéns!"),
          content: const Text("Você completou o capítulo!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChapterScreen(courseId: widget.courseId, user: widget.user))
              ),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _LoadContents();
  }

  Future<void> _LoadContents() async {
    List<Map<String, dynamic>> loadedContents = await fetchContents(widget.chapterId, widget.courseId);
    setState(() {
      contents = loadedContents;
      isLoading = false;
    });
  }

  void _checkAnswer(int selectedIndex) {
    int correctAnswerIndex = contents[currentQuestionIndex]['rightAnswer'];

    if (selectedIndex == correctAnswerIndex) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Resposta Correta!")),
      );
      nextQuestion();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Resposta Errada!")),
      );
    }
  
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Questionário")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (contents.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Questionário")),
        body: const Center(child: Text("Nenhum questionário disponível.")),
      );
    }

    // Dados da pergunta atual
    final questionData = contents[currentQuestionIndex];
    final String pergunta = questionData['question'];
    final List<dynamic> respostas = questionData['answers'];

    return Scaffold(
      appBar: AppBar(title: const Text("Questionário")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pergunta ${currentQuestionIndex + 1}/${contents.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              pergunta,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 16),
            ...respostas.asMap().entries.map((entry) {
              int index = entry.key;
              String resposta = entry.value;

              return ElevatedButton(
                onPressed: () => _checkAnswer(index),
                child: Text(resposta),
              );
            }).toList(),
          ],
        ),
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
          setState(() {
            if(index == 0){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(user: widget.user),
                  )
              );
            }
          });
        },
      ),
    );
  }
}