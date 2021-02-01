import 'package:flutter/material.dart';
import 'package:socialapp/modeller/kombin.dart';
import 'package:timeago/timeago.dart' as timeago;

class TekliKombin extends StatefulWidget {
  final Kombin kombin;

  const TekliKombin({Key key, this.kombin}) : super(key: key);
  @override
  _TekliKombinState createState() => _TekliKombinState();
}

class _TekliKombinState extends State<TekliKombin> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    timeago.setLocaleMessages('tr', timeago.TrMessages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.orange[300],
          title: Text(
            timeago.format(widget.kombin.olusturmaZamani.toDate(),
                locale: "tr"),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: 'LobsterTwoItalic',
            ),
          )),
      body: PageView(
        children: [
          Image(
            image: NetworkImage(widget.kombin.kombinResmiUrl),
          )
        ],
      ),
    );
  }
}
