// To parse this JSON data, do
//
//     final instaUser = instaUserFromJson(jsonString);

import 'dart:convert';

InstaUser instaUserFromJson(String str) => InstaUser.fromJson(json.decode(str));

String instaUserToJson(InstaUser data) => json.encode(data.toJson());

class InstaUser {
  InstaUser({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.avatar,
  });

  int id;
  String? name;
  String? username;
  String? email;
  String? avatar;

  factory InstaUser.fromJson(Map<String, dynamic> json) => InstaUser(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    email: json["email"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "email": email,
    "avatar": avatar,
  };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
