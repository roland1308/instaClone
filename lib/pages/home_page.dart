import 'package:flutter/material.dart';
import 'package:insta_clone/DataRepository/data_repository.dart';
import 'package:insta_clone/components/histories_list.dart';
import 'package:insta_clone/components/single_card.dart';
import 'package:insta_clone/models/posts_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<InstaPosts> posts = [];

  @override
  void initState() {
    super.initState();
    getInitialPosts();
  }

  Future<void> getInitialPosts() async {
    var postReceived = await DataRepository().getPosts();
    setState(() {
      posts = postReceived;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HistoriesList(),
        Expanded(
          child: ListView.builder(
            itemCount: posts.length + 1,
            itemBuilder: (_, int index) {
              if (index == 0) {
                return HistoriesList();
              } else {
                // print(index - 1);
                return SingleCard(
                  post: posts[index - 1],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
