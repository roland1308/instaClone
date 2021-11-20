import 'package:flutter/material.dart';
import 'package:insta_clone/pages/comments_page.dart';
import 'package:insta_clone/pages/home_page.dart';
import 'package:insta_clone/pages/user_search.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          bottomNavigationBar: TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(icon: Icon(Icons.directions)),
              // Tab(icon:Icon(Icons.dialpad_outlined)),
              Tab(icon: Icon(Icons.bookmark))
            ],
          ),
          body: TabBarView(children: [
            HomePage(),
            // CommentsPage(),
            UserSearch(),
          ])),
    );
  }
}
