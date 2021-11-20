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
    var receivedAlbums = await DataRepository().getAlbum();
    setState(() {
      userAlbums = receivedAlbums
          .where((InstaAlbum element) => element.userId == widget.user.id)
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
        title: Text("${widget.user.name} Albums"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Column(
                children: [
                  Expanded(
                      flex: 1, child: UserDetailsHeader(user: widget.user)),
                  Expanded(
                    flex: 9,
                    child: ListView.builder(
                      itemCount: userAlbums.length,
                      itemBuilder: (_, int index) {
                        return SinglePhotosAlbum(
                            userAlbums: userAlbums, index: index);
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class SinglePhotosAlbum extends StatelessWidget {
  const SinglePhotosAlbum(
      {Key? key, required this.userAlbums, required this.index})
      : super(key: key);

  final List<InstaAlbum> userAlbums;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 2),
            child: Text(
              userAlbums[index].title ?? "NO_TITLE",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 200,
            child: FutureBuilder(
                future: getPhotos(userAlbums[index].id),
                builder: (context, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        scrollDirection: Axis.horizontal,
                        crossAxisCount: 2,
                        children: snapshot.data!.map((String url) {
                          return GridTile(
                              child: Image.network(url, fit: BoxFit.cover));
                        }).toList());
                  } else {
                    return Text("Loading...");
                  }
                }),
          ),
        ],
      ),
    );
  }
}

Future<List<String>> getPhotos(int albumId) async {
  List<String> imagesUrl = await DataRepository().getPhoto(albumId: albumId);
  return imagesUrl;
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
