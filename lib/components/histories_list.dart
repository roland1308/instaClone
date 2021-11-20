import 'dart:math';

import 'package:flutter/material.dart';

class HistoriesList extends StatelessWidget {
  const HistoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry(),
          StoryEntry()
        ],
      ),
    );
  }
}

class StoryEntry extends StatelessWidget {
  const StoryEntry({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right:4.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.orange,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage("https://picsum.photos/200?ew=${Random().nextInt(50)}"),
            ),
          ),
          SizedBox(height: 5),
          Text("My history", style: TextStyle(fontSize: 10))
        ],
      ),
    );
  }
}
