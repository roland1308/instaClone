// To parse this JSON data, do
//
//     final instaPosts = instaPostsFromJson(jsonString);

import 'dart:convert';

List<InstaPosts> instaPostsFromJson(String str) => List<InstaPosts>.from(json.decode(str).map((x) => InstaPosts.fromJson(x)));

String instaPostsToJson(List<InstaPosts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InstaPosts {
  InstaPosts({
    required this.userId,
    required this.id,
    this.title = 'NO TITLE',
    this.body = 'NO BODY',
  });

  int userId;
  int id;
  String title;
  String body;

  factory InstaPosts.fromJson(Map<String, dynamic> json) => InstaPosts(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "body": body,
  };
}
