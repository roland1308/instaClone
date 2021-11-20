// To parse this JSON data, do
//
//     final instaComments = instaCommentsFromJson(jsonString);

import 'dart:convert';

List<InstaComments> instaCommentsFromJson(String str) => List<InstaComments>.from(json.decode(str).map((x) => InstaComments.fromJson(x)));

String instaCommentsToJson(List<InstaComments> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InstaComments {
  InstaComments({
    required this.postId,
    required this.id,
    this.name,
    this.email,
    this.body,
  });

  int postId;
  int id;
  String? name;
  String? email;
  String? body;

  factory InstaComments.fromJson(Map<String, dynamic> json) => InstaComments(
    postId: json["postId"],
    id: json["id"],
    name: json["name"],
    email: json["email"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "postId": postId,
    "id": id,
    "name": name,
    "email": email,
    "body": body,
  };
}
