import 'package:flutter/material.dart';
import 'package:insta_clone/pages/boot_page.dart';
import 'package:insta_clone/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'mock.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MockProvider().initDb();
  //
  http.Response response = await MockProvider().get("users");
  //print(response.body);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogged = false;
  bool isLoading = true;
  @override
  initState() {
    checkLoginOrHome();
  }

  Future<void> checkLoginOrHome() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isLogged = pref.containsKey("loginInfo");
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : MaterialApp(home: isLogged ? BootPage() : LoginPage());
  }
}
