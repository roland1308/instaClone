import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:insta_clone/mock.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/pages/boot_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Colors.amber,
            Colors.purpleAccent,
          ])),
      child: Container(
        constraints: BoxConstraints(
          minWidth: 200,
          maxWidth: 300,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/instaclone-logo-dark.png",
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (text) {
                  text ??= "";
                  if (!isEmail(text)) {
                    return "Incorrect email format!";
                  }
                  return null;
                },
                cursorColor: Colors.black,
                keyboardType: TextInputType.emailAddress,
                controller: usernameController,
                decoration: buildInputDecoration(
                    hintText: "Username",
                    prefixIcon:
                        Icon(Icons.person_outline, color: Colors.black26)),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (text) {
                  text ??= "";
                  if (text.length < 6) {
                    return "Password must be at least 6 characters length!";
                  }
                  return null;
                },
                cursorColor: Colors.black,
                controller: passwordController,
                obscureText: true,
                decoration: buildInputDecoration(
                  hintText: "Password",
                    prefixIcon:
                        Icon(Icons.lock_outline, color: Colors.black26)),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      Response response = await MockProvider().auth(
                          email: usernameController.text,
                          password: passwordController.text);
                      if (response.statusCode == 200) {
                        var responseDecoded = jsonDecode(response.body);
                        InstaUser user = InstaUser.fromJson(responseDecoded);
                        saveDataAndGoHome(user: user);
                      } else {
                        print("ERROR");
                      }
                      print(response.body);
                    } else {
                      print("Not valid");
                    }
                    ;
                  },
                  child: Text("Sign in"),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }


  Future<void> saveDataAndGoHome({required InstaUser user}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userString = jsonEncode(user.toJson());
    prefs.setString("loginInfo", userString);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => BootPage()),
      (Route<dynamic> route) => false,
    );
  }
}
