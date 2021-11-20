import 'dart:convert';

import 'package:insta_clone/models/album_model.dart';
import 'package:insta_clone/models/comments_model.dart';
import 'package:insta_clone/models/posts_model.dart';
import 'package:insta_clone/models/user_model.dart';

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

}