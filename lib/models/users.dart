class Users {
  String id;
  String name;
  String email;
  int experience;

  Users({required this.id, required this.name, required this.email, this.experience = 0});

  Users.fromMap(Map<String, dynamic>map)
      :id = map["id"],
      name = map["name"],
      email = map["email"] ,
      experience = map["experience"];

  Map<String,dynamic> toMap(){
    return {
      "id": id,
      "name": name,
      "email": email,
      "experience": experience,
    };
  }
}