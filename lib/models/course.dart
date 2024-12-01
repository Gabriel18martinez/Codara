import 'package:codara/models/chapters.dart';

class Course {
  String id;
  String name;
  List<Chapters> chapters;

  Course({required this.id, required this.name, this.chapters = const <Chapters>[]});

  Course.fromMap(Map<String, dynamic>map)
    :id = map["id"],
    name = map["name"],
    chapters = map["chapters"];

  Map<String,dynamic> toMap(){
    return {
      "id": id,
      "name": name,
      "chapters": chapters,
    };
  }
}