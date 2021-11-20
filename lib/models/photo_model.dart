// To parse this JSON data, do
//
//     final instaPhoto = instaPhotoFromJson(jsonString);

import 'dart:convert';

InstaPhoto instaPhotoFromJson(String str) => InstaPhoto.fromJson(json.decode(str));

String instaPhotoToJson(InstaPhoto data) => json.encode(data.toJson());

class InstaPhoto {
  InstaPhoto({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  int albumId;
  int id;
  String title;
  String url;
  String thumbnailUrl;

  factory InstaPhoto.fromJson(Map<String, dynamic> json) => InstaPhoto(
    albumId: json["albumId"],
    id: json["id"],
    title: json["title"],
    url: json["url"],
    thumbnailUrl: json["thumbnailUrl"],
  );

  Map<String, dynamic> toJson() => {
    "albumId": albumId,
    "id": id,
    "title": title,
    "url": url,
    "thumbnailUrl": thumbnailUrl,
  };
}
