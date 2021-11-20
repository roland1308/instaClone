import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/pages/login_page.dart';
import 'package:insta_clone/pages/profile_page.dart';
import 'package:insta_clone/pages/user_search.dart';
import 'package:insta_clone/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BootPage extends StatefulWidget {
  const BootPage({Key? key}) : super(key: key);

  @override
  State<BootPage> createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {

  late InstaUser currentUser;
  bool isLoading = true;

  @override
  initState() {
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.containsKey("loginInfo")) {
      var currentUserString = await pref.getString("loginInfo");
      setState(() {
        currentUser = instaUserFromJson(currentUserString!);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
        child: Center(child: CircularProgressIndicator())
    )
    : DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Image.asset(
            "assets/images/instaclone-logo-dark.png",
            width: MediaQuery.of(context).size.width * 0.3,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(Icons.logout),
                color: Colors.black,
                onPressed: () {
                  clearDataAndLogout();
                },
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(right: 20.0),
            //   child: Icon(Icons.favorite_outline, color: Colors.black),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(right: 10),
            //   child: IconButton(
            //       color: Colors.black,
            //       onPressed: () => Navigator.of(context).push(
            //             MaterialPageRoute(builder: (_) => UserSearch()),
            //           ),
            //       icon: Icon(Icons.people_outline)),
            // ),

          ],
        ),
        // body: PrincipalBody(),
          body: TabBarView(children: [
            HomePage(),
            UserSearch(),
            ProfilePage(
                user: currentUser,
                setFooterAvatar: (newAvatar) {
                  setState(() {
                    currentUser.avatar = newAvatar;
                  });
                })
          ]),
          bottomNavigationBar: TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.search)),
              Tab(icon:CircleAvatar(
                backgroundImage: NetworkImage(currentUser.avatar ??
                    "https://cdn.dribbble.com/users/304574/screenshots/6222816/male-user-placeholder.png"),
              ))
            ],
          )
      ),
    );
  }

  Future<void> clearDataAndLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
