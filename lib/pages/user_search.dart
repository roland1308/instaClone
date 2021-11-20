import 'package:flutter/material.dart';
import 'package:insta_clone/DataRepository/data_repository.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:substring_highlight/substring_highlight.dart';

class UserSearch extends StatefulWidget {
  UserSearch({Key? key}) : super(key: key);

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  String filterText = "";

  Future<List<InstaUser>> getUsersList() {
    Future<List<InstaUser>> allUsers = DataRepository().getAllUsers();
    return allUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Search for User"),
        ),
        body: Container(
          child: FutureBuilder(
            future: getUsersList(),
            builder: (BuildContext context,
                AsyncSnapshot<List<InstaUser>> snapshot) {
              if (snapshot.hasData) {
                List<InstaUser> filteredUsers = snapshot.data!
                    .where((element) =>
                        (element.name!.toLowerCase().contains(filterText) ||
                            element.email!.toLowerCase().contains(filterText)))
                    .toList();

                return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              // controller: commentController,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  hintText: "Search for..."),
                              onChanged: (value) {
                                setState(() {
                                  filterText = value.toLowerCase();
                                });
                                ;
                              },
                            ),
                          ),
                        ),
                        filteredUsers.length > 0
                            ? Flexible(
                                flex: 4,
                                child: ListView.builder(
                                    itemCount: filteredUsers.length,
                                    itemBuilder: (_, index) {
                                      return ListTile(
                                        title: SubstringHighlight(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            text: filteredUsers[index].name ??
                                                "NO_NAME", // search result string from database or something
                                            term: filterText),
                                        subtitle: SubstringHighlight(
                                            text: filteredUsers[index].email ??
                                                "NO_EMAIL", // search result string from database or something
                                            term: filterText),
                                      );
                                    }),
                              )
                            : Center(child: Text("No users matching!"))
                      ],
                    ));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }
}
