import 'dart:ffi';

class Content {
  String id;
  String question;
  List<String> answers;
  int rightAnswer;

  Content({required this.id, required this.question, this.answers = const <String> [], this.rightAnswer = 99});
}