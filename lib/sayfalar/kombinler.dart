import 'package:flutter/material.dart';
import 'package:socialapp/modeller/kombin.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/akis.dart';
import 'package:socialapp/sayfalar/anasayfa.dart';
import 'package:story_view/story_view.dart';

class Kombinler extends StatefulWidget {
  final List<Kombin> kombin;
  final Kullanici yayinlayan;

  const Kombinler({Key key, this.kombin, this.yayinlayan}) : super(key: key);
  @override
  _KombinlerState createState() => _KombinlerState();
}

class _KombinlerState extends State<Kombinler> {
  final storyController = StoryController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        storyItems: [
          StoryItem.pageImage(
            url: widget.kombin[0].kombinResmiUrl,
            caption: widget.yayinlayan.kullaniciAdi,
            controller: storyController,
          ),
          StoryItem.pageImage(
            url: widget.kombin[1].kombinResmiUrl,
            caption: "Still sampling",
            controller: storyController,
          ),
          StoryItem.pageImage(
              url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
              caption: "Working with gifs",
              controller: storyController),
          StoryItem.pageImage(
            url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
            caption: "Hello, from the other side",
            controller: storyController,
          ),
        ],
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AnaSayfa()));

          // print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}
