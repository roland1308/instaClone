import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
     required this.user,
  }) : super(key: key);

  final InstaUser user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(user.avatar ??
                    "https://cdn.dribbble.com/users/304574/screenshots/6222816/male-user-placeholder.png"),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? "NO_NAME",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Text(
                  user.email ?? "NO_EMAIL",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        // Text(
        //   "...",
        //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        // )
      ],
    );
  }
}