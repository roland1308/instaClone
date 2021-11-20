import 'package:flutter/material.dart';
import 'package:insta_clone/DataRepository/data_repository.dart';
import 'package:insta_clone/models/comments_model.dart';

class CommentsPage extends StatefulWidget {
  CommentsPage({Key? key, required this.comments, required this.userAvatar})
      : super(key: key);

  final List<InstaComments> comments;
  final String userAvatar;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  String newComment = "";
  final _controller = ScrollController();
  TextEditingController commentController = TextEditingController();
  final successBar = SnackBar(
    content: Text(
      'Comment added successfully',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.black.withOpacity(.5),
  );

  Future<void> postComment() async {
    FocusScope.of(context).unfocus();
    _controller.animateTo(_controller.position.maxScrollExtent,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    InstaComments comment = InstaComments(
      id: -1,
      postId: widget.comments[0].postId,
      name: "My user",
      email: "myemail@myemail.com",
      body: this.newComment,
    );
    await DataRepository().postComment(comment);

    setState(() {
      commentController.text = "";
      widget.comments.add(comment);
    });
    await Future.delayed(Duration(milliseconds: 500));
    ScaffoldMessenger.of(context).showSnackBar(successBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
        title: Text("Comments"),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: Container(
              child: ListView.builder(
                  controller: _controller,
                  itemCount: this.widget.comments.length,
                  itemBuilder: (_, int index) {
                    return Column(
                      children: [
                        Text(
                          widget.comments[index].body ?? "",
                          // overflow: TextOverflow.clip,
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  }),
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: Row(children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(widget.userAvatar),
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding:
                                const EdgeInsets.only(right: 15.0, top: 15.0),
                            child: InkWell(
                                onTap: () async {
                                  await postComment();
                                },
                                child: Text("Publish")),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          hintText: "Add a comment as..."),
                      onChanged: (value) {
                        this.newComment = value;
                      },
                    ),
                  ),
                )
              ]))
        ],
      ),
    );
  }
}
