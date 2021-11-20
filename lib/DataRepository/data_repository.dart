import 'dart:convert';

import 'package:insta_clone/models/album_model.dart';
import 'package:insta_clone/models/comments_model.dart';
import 'package:insta_clone/models/photo_model.dart';
import 'package:insta_clone/models/posts_model.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:http/http.dart' as http;

import '../mock.dart';

class DataRepository {
  Future getPosts() async {
    try {
      var response = await MockProvider().get('posts');
      // print(response);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var receivedPosts = instaPostsFromJson(response.body);
        return receivedPosts;
      } else {
        throw Exception("Error requesting categories");
      }
    } catch (e) {
      throw Exception("There was an error $e");
    }
  }

  Future getUser(int id) async {
    // print("ID IS: $id");
    try {
      var response = await MockProvider().get('users', id: id);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var receivedUser = InstaUser.fromJson(json.decode(response.body));
        return receivedUser;
      } else {
        throw Exception("Error requesting categories");
      }
    } catch (e) {
      throw Exception("There was an error $e");
    }
  }

  Future <List<InstaUser>> getAllUsers() async {
    try {
      var response = await MockProvider().get('users');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var decodedResponse = json.decode(response.body);
        var receivedUsers = List.from(decodedResponse).map((e) => InstaUser.fromJson(e)).toList();
        print (receivedUsers);
        return receivedUsers;
      } else {
        throw Exception("Error requesting categories");
      }
    } catch (e) {
      throw Exception("There was an error $e");
    }
  }

  Future getComments() async {
    try {
      var response = await MockProvider().get('comments');
      // print(response);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var receivedComments = instaCommentsFromJson(response.body);
        return receivedComments;
      } else {
        throw Exception("Error requesting categories");
      }
    } catch (e) {
      throw Exception("There was an error $e");
    }
  }

  Future getAlbum() async {
    try {
      var response = await MockProvider().get('albums');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var decodedResponse = json.decode(response.body);
        var receivedAlbum = List.from(decodedResponse).map((e) => InstaAlbum.fromJson(e)).toList();
        return receivedAlbum;
      } else {
        throw Exception("Error requesting categories");
      }
    } catch (e) {
      throw Exception("There was an error $e");
    }
  }

  postComment(InstaComments comment) async {
    await MockProvider().post("comments", comment.toJson());
  }

  // Future postComments() async {
  //   try {
  //     var response = await MockProvider().post('comments');
  //     // print(response);
  //     if (response.statusCode >= 200 && response.statusCode < 300) {
  //       var receivedComments = instaCommentsFromJson(response.body);
  //       return receivedComments;
  //     } else {
  //       throw Exception("Error requesting categories");
  //     }
  //   } catch (e) {
  //     throw Exception("There was an error $e");
  //   }
  // }

  Future<String?> uploadImage(filepath) async {
    var uri = Uri.parse('https://api.sharetoevent.indalter.es/api/v1/public/live/db2aa05a-98c9-433b-8df5-ff2bb9fabc89?type=image');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', filepath));
    var res = await request.send();
    final respStr = await res.stream.bytesToString();
    return json.decode(respStr)["url"];
  }

  Future getPhoto({required int albumId}) async {
    try {
      var response = await MockProvider().get('photos');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var decodedResponse = json.decode(response.body);
        var receivedPhoto = List.from(decodedResponse).map((e) => InstaPhoto.fromJson(e)).toList();
        receivedPhoto = receivedPhoto.where((element) => element.albumId == albumId).toList();
        List<String> imagesUrl = receivedPhoto.map((element) => element.url).toList();
        return imagesUrl;
      } else {
        throw Exception("Error requesting categories");
      }
    } catch (e) {
      throw Exception("There was an error $e");
    }
  }

}