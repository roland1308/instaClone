// To parse this JSON data, do
//
//     final instaAlbum = instaAlbumFromJson(jsonString);

import 'dart:convert';

InstaAlbum instaAlbumFromJson(String str) => InstaAlbum.fromJson(json.decode(str));

String instaAlbumToJson(InstaAlbum data) => json.encode(data.toJson());

class InstaAlbum {
  InstaAlbum({
    required this.id,
    required this.userId,
    required this.title,
  });

  int id;
  int userId;
  String? title;

  factory InstaAlbum.fromJson(Map<String, dynamic> json) => InstaAlbum(
    id: json["id"],
    userId: json["userId"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "title": title,
  };
}
