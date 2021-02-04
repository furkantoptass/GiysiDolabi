import 'package:flutter/material.dart';
import 'package:socialapp/modeller/kombin.dart';
import 'package:socialapp/modeller/kullanici.dart';
//import 'package:socialapp/sayfalar/akis.dart';
//import 'package:socialapp/sayfalar/anasayfa.dart';
import 'package:story_view/story_view.dart';
import 'package:timeago/timeago.dart' as timeago;

class Kombinler extends StatefulWidget {
  final List<Kombin> kombin;
  final Kullanici yayinlayan;

  const Kombinler({Key key, this.kombin, this.yayinlayan}) : super(key: key);
  @override
  _KombinlerState createState() => _KombinlerState();
}

class _KombinlerState extends State<Kombinler> {
  final storyController = StoryController();
  // ignore: deprecated_member_use
  List<StoryItem> stories = new List();
  final controller = PageController();
  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    for (var i = 0; i < widget.kombin.length; i++) {
      if (widget.kombin[i].yayinlayanId == widget.yayinlayan.id) {
        stories.add(
          StoryItem.pageImage(
            url: widget.kombin[i].kombinResmiUrl,
            controller: storyController,
            caption: widget.yayinlayan.kullaniciAdi +
                "    " +
                timeago.format(widget.kombin[i].olusturmaZamani.toDate(),
                    locale: "tr"),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoryView(
      storyItems: stories,
      controller: storyController,
      onStoryShow: (s) {
        print("Showing a story");
      },
      onComplete: () {
        print("Completed a cycle");
        Navigator.pop(context);
      },
      progressPosition: ProgressPosition.top,
      repeat: true,
    );
  }

  PageView buildPage2(Kombin kombin) {
    return PageView(
      controller: controller,
      children: [
        Image(
          image: NetworkImage(kombin.kombinResmiUrl),
        ),
      ],
      physics: BouncingScrollPhysics(),
    );
  }
}
