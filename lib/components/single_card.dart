import 'dart:math';

import 'package:flutter/material.dart';
import 'package:insta_clone/DataRepository/data_repository.dart';
import 'package:insta_clone/components/user_details.dart';
import 'package:insta_clone/components/user_info.dart';
import 'package:insta_clone/models/comments_model.dart';
import 'package:insta_clone/models/posts_model.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/pages/comments_page.dart';

class SingleCard extends StatefulWidget {
  final InstaPosts post;

  SingleCard({Key? key, required this.post}) : super(key: key);

  @override
  State<SingleCard> createState() => _SingleCardState();
}

class _SingleCardState extends State<SingleCard> {
  late InstaUser user;
  // late List<InstaComments> comments = [];
  // int nrOfComments = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getInitialData();
  }

  Future<void> getInitialData() async {
    InstaUser receivedUser = await DataRepository().getUser(widget.post.userId);
    // List<InstaComments> receivedComments = await DataRepository().getComments();
    setState(() {
      user = receivedUser;
      // comments = receivedComments;
      isLoading = false;
    });
    return;
  }

  Future<List<InstaComments>> getComments() async {
    List<InstaComments> receivedComments = await DataRepository().getComments();
    receivedComments = (receivedComments
        .where((element) => element.postId == widget.post.id)).toList();
    return receivedComments;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: getComments(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        InkWell(
                          child: UserInfo(user: user),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => UserDetails(user: user)),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CardImage(context),
                        const SizedBox(
                          height: 8,
                        ),
                        CardFooter(),
                        CardReactions(
                            user: user, widget: widget, comments: snapshot.data)
                      ],
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
                ;
              }),
    );
  }

  SizedBox CardImage(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.network(
          "https://picsum.photos/200?ew=${Random().nextInt(50)}",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class CardReactions extends StatelessWidget {
  const CardReactions({
    Key? key,
    required this.user,
    required this.comments,
    required this.widget,
  }) : super(key: key);

  final InstaUser user;
  final List<InstaComments> comments;
  final SingleCard widget;

  @override
  Widget build(BuildContext context) {
    List<InstaComments> filteredComments = (comments
        .where((element) => element.postId == widget.post.id)).toList();
    int nrOfComments = filteredComments.length;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "66.356 Me gusta",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: RichText(
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 1,
            text: TextSpan(
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(text: "${user.name}"),
                  TextSpan(
                    text: " ${widget.post.title}",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                ]),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => CommentsPage(
                      comments: filteredComments,
                  userAvatar: user.avatar ?? "",
                )),
          ),
          child: Text(
            "Check all $nrOfComments comments",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        "https://picsum.photos/200?ew=${Random().nextInt(50)}"),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => CommentsPage(
                          comments: filteredComments,
                          userAvatar: user.avatar ?? "",
                        )),
                  ),
                  child: Text(
                    "Add a comment...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.favorite_outline, color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0, left: 10.0),
                  child: Icon(Icons.chat_bubble_outline, color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.send, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          "3 hours ago",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

class CardFooter extends StatelessWidget {
  const CardFooter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(right: 30.0),
              child: Icon(Icons.favorite_outline, color: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.only(right: 30.0),
              child: Icon(Icons.chat_bubble_outline, color: Colors.black),
            ),
            Icon(Icons.send, color: Colors.black),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: Icon(Icons.mail_outline, color: Colors.black),
        ),
      ],
    );
  }
}
