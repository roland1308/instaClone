import 'package:flutter/material.dart';
import 'package:insta_clone/DataRepository/data_repository.dart';
import 'package:insta_clone/models/album_model.dart';
import 'package:insta_clone/models/user_model.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({
    Key? key,
    required this.user,
  }) : super(key: key);

  final InstaUser user;

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late List<InstaAlbum> userAlbums = [];
  bool isLoading = true;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    var userAlbums = await DataRepository().getAlbum();
    setState(() {
      userAlbums = userAlbums
        .where((element) => element.userId == widget.user.id)
        .toList();
      isLoading = false;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.user.name} details"),
      ),
      body: isLoading
      ? Center(child: CircularProgressIndicator())
      : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: UserDetailsHeader(user: widget.user)),
            Expanded(
              flex: 4,
              child: ListView.builder(
                itemCount: userAlbums.length,
                itemBuilder: (_, int index) {
                  return Text(userAlbums[index].title ?? "NO_TITLE");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserDetailsHeader extends StatelessWidget {
  const UserDetailsHeader({
    Key? key,
    required this.user,
  }) : super(key: key);

  final InstaUser user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
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
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(user.avatar ??
                "https://cdn.dribbble.com/users/304574/screenshots/6222816/male-user-placeholder.png"),
          ),
        ),
      ],
    );
  }
}
