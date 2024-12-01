import 'content.dart';

class Chapters {
  String id;
  String name;
  List<Content> content;

  Chapters({required this.id, required this.name, required this.content});

  Chapters.fromMap(Map<String, dynamic>map)
      :id = map["id"],
        name = map["name"],
        content = map["content"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "content": content,
    };
  }
}