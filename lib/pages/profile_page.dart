import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers.dart';
import '../mock.dart';

class ProfilePage extends StatefulWidget {
  final InstaUser user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FocusNode _focusName = FocusNode();
  FocusNode _focusUsername = FocusNode();
  FocusNode _focusEmail = FocusNode();
  bool isEditing = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final successBar = SnackBar(
    content: Text(
      'Profile Updated successfully',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.black.withOpacity(.5),
  );

  final notValidDataBar = SnackBar(
    content: Text(
      'Please correct errors',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.black.withOpacity(.5),
  );

  final noChangesBar = SnackBar(
    content: Text(
      'No changes have been done',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.black.withOpacity(.5),
  );

  final undoBar = SnackBar(
    content: Text(
      'Previous values restored',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.black.withOpacity(.5),
  );

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    setState(() {
      nameController.text = widget.user.name!;
      usernameController.text = widget.user.username!;
      emailController.text = widget.user.email!;
    });

    _focusName.addListener(() {
      setState(() {
        isEditing = _focusName.hasFocus;
      });
    });
    _focusUsername.addListener(() {
      setState(() {
        isEditing = _focusUsername.hasFocus;
      });
    });
    _focusEmail.addListener(() {
      setState(() {
        isEditing = _focusEmail.hasFocus;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          child: Column(
            children: [
              Flexible(
                flex: isEditing ? 2 : 3,
                fit: FlexFit.loose,
                child: Column(
                  children: [
                    if (!isEditing)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 10),
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "Profile Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                                      title: Text('Update profile image'),
                                      content: Text(
                                          'Where do you want to take image from?'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Text('Camera'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Text('Album'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: isEditing ? 30 : 60,
                                  backgroundImage: NetworkImage(widget
                                          .user.avatar ??
                                      "https://cdn.dribbble.com/users/304574/screenshots/6222816/male-user-placeholder.png"),
                                ),
                                if (!isEditing)
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.redAccent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: isEditing ? 6 : 5,
                fit: FlexFit.tight,
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.indigo.shade600,
                              Colors.indigo.shade900,
                            ])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                          child: Form(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (text) {
                                    text ??= "";
                                    if (text.isEmpty) {
                                      return "This field is required";
                                    } else if (text.length < 3) {
                                      return "Please use at least 3 characters";
                                    }
                                    return null;
                                  },
                                  focusNode: _focusName,
                                  controller: nameController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: buildInputProfileDecoration(
                                      hintText: "Name"),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  validator: (text) {
                                    text ??= "";
                                    if (text.isEmpty) {
                                      return "This field is required";
                                    } else if (text.length < 3) {
                                      return "Please use at least 3 characters";
                                    }
                                    return null;
                                  },
                                  focusNode: _focusUsername,
                                  controller: usernameController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: buildInputProfileDecoration(
                                      hintText: "Username"),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  validator: (text) {
                                    text ??= "";
                                    if (text.isEmpty) {
                                      return "This field is required";
                                    } else if (!isEmail(text)) {
                                      return "Incorrect email format";
                                    }
                                    return null;
                                  },
                                  focusNode: _focusEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: buildInputProfileDecoration(
                                      hintText: "Email"),
                                ),
                                SizedBox(height: 60),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (!_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              await Future.delayed(Duration(milliseconds: 500));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(notValidDataBar);
                            } else if (widget.user.name ==
                                    nameController.text &&
                                widget.user.username ==
                                    usernameController.text &&
                                widget.user.email == emailController.text) {
                              FocusScope.of(context).unfocus();
                              await Future.delayed(Duration(milliseconds: 500));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(noChangesBar);
                            } else {
                              widget.user.name = nameController.text;
                              widget.user.username = usernameController.text;
                              widget.user.email = emailController.text;
                              saveUserInfo(widget.user);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    nameController.text = widget.user.name!;
                                    usernameController.text =
                                        widget.user.username!;
                                    emailController.text = widget.user.email!;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15.0),
                                  child: Icon(Icons.undo, color: Colors.white),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .6,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Change",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  saveUserInfo(InstaUser? user) async {
    FocusScope.of(context).unfocus();
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("loginInfo", user.toString());

      await MockProvider().update("users", user.toJson());

      await Future.delayed(Duration(milliseconds: 500));
      ScaffoldMessenger.of(context).showSnackBar(successBar);
    }
  }
}
