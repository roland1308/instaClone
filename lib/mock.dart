import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';


Map<String,dynamic> tables = {
  "posts":["userId","id","title","body"],
  "comments":["postId","id","name","email","body"],
  "albums":["userId","id","title"],
  "photos":["albumId","id","title","url","thumbnailUrl"],
  "users":["id","name","username","email","avatar"],
  "auth":[]
};


class MockProvider{
  static const _jsonDir = 'assets/mockups/';
  static const _jsonExtension = '.json';


  Future<bool> initDb() async {

    Completer<bool> completer = Completer();
    print("initializing db...");


    for( var key in tables.keys) {

      final resourcePath = _jsonDir + key + _jsonExtension;
      final data = await rootBundle.load(resourcePath);


      var newFileContent = utf8.decode(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );

      final directory = await getApplicationDocumentsDirectory();
      var file =  File('${directory.path}/$key$_jsonExtension');
      await file.writeAsString(newFileContent);


      print("FILE WRITTEN in $key");



    };


    completer.complete(true);


    return completer.future;



  }

  Future<Response> get(String path,{int? id}) async {

    final directory = await getApplicationDocumentsDirectory();
    final resourcePath = "${directory.path}/$path$_jsonExtension";

    var file =  File(resourcePath);
    final data = await file.readAsBytes();

    final List map = json.decode(
      utf8.decode(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      ),
    );

    //print("MAP: $id");

    if(id != null){
      var index = map.indexWhere((element) => element["id"] == id);
      //print("ELEMENT: $index");
      return Response(jsonEncode(map[index]),200);

    }
    //print("Returning here");
    return Response(jsonEncode(map),200);
  }


  Future<Response> auth({String? email, String ? password}) async {

    if(email == null || password == null){
      return Response("Email and password are needed to log in",500);
    }

    if(email == "test@test.com" && password == "123456") {

      final directory = await getApplicationDocumentsDirectory();
      final resourcePath = "${directory.path}/users$_jsonExtension";

      var file =  File(resourcePath);
      final data = await file.readAsBytes();

      final List map = json.decode(
        utf8.decode(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        ),
      );


      var i = map.indexWhere((element) => element["id"] == 1);

      //print("Returning here");
      return Response(jsonEncode(map[i]),200);


    }else{
      return Response("Invalid username or password", 500);

    }
  }


  bool checkObject(String table,Map<String,dynamic> object){
    var fields = tables[table];

    print("FIELDS: $fields");

    if(object.keys.length != fields.length) return false;

    bool keyNotFound = true;

    fields.forEach((element) {
      if(!object.containsKey(element)){
        keyNotFound = false;
      }
    });

    return keyNotFound;
  }

  Future<Response> update(String path,Map<String,dynamic> newObject) async {

    final directory = await getApplicationDocumentsDirectory();
    final resourcePath = "${directory.path}/$path$_jsonExtension";

    var file =  File(resourcePath);
    final data = await file.readAsBytes();

    List<dynamic> listMap = json.decode(
      utf8.decode(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      ),
    );

    if(!checkObject(path, newObject)){
      //print("Object incorrect");
      return Response("Incorrect object type for table $path",500);
    }

    var index = listMap.indexWhere((element) => element["id"] == newObject["id"]);

    if(index >= 0){
      listMap[index] = newObject;

      await file.writeAsString(jsonEncode(listMap));


    }else{
      return Response("Requested resource does not exist",500);

    }

    return Response(jsonEncode(newObject),200);
  }


  Future<Response> delete(String path,int id) async {

    final directory = await getApplicationDocumentsDirectory();
    final resourcePath = "${directory.path}/$path$_jsonExtension";

    var file =  File(resourcePath);
    final data = await file.readAsBytes();

    List<dynamic> listMap = json.decode(
      utf8.decode(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      ),
    );


    var index = listMap.indexWhere((element) => element["id"] == id);

    if(index >= 0){
      //print("deleting object");
      listMap.removeAt(index);

      await file.writeAsString(jsonEncode(listMap));


    }else{
      return Response("Requested resource does not exist",500);

    }

    return Response("Object deleted correctly",200);
  }




  Future<Response> post(String path,Map<String,dynamic> newObject) async {
    print(newObject);
    final directory = await getApplicationDocumentsDirectory();
    final resourcePath = "${directory.path}/$path$_jsonExtension";

    var file =  File(resourcePath);
    final data = await file.readAsBytes();

    List<Map<String,dynamic>> listMap = List.from(json.decode(
      utf8.decode(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      ),
    ));

    if(!checkObject(path, newObject)){
      print("Object incorrect");
      return Response("Incorrect object type for table $path",500);
    }

    newObject["id"] = listMap.last["id"]+1;
    listMap.add(newObject);

    await file.writeAsString(jsonEncode(listMap));


    return Response(jsonEncode(newObject),200);
  }
}