import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kombin.dart';
import 'package:socialapp/sayfalar/teklikombin.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';
import 'package:timeago/timeago.dart' as timeago;

class Kombinlerim extends StatefulWidget {
  @override
  _KombinlerimState createState() => _KombinlerimState();
}

class _KombinlerimState extends State<Kombinlerim> {
  List<Kombin> _kombinler = [];
  Future<void> _kullaniciKombinleriGetir() async {
    String aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifkullaniciid;
    List<Kombin> kombinler =
        await FireStoreServisi().kullaniciKombinleriGetir(aktifKullaniciId);

    if (mounted) {
      setState(() {
        _kombinler = kombinler;
      });
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    _kullaniciKombinleriGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kombinlerim",
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'LobsterTwoItalic',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange[300],
      ),
      body: ListView.builder(
        itemCount: _kombinler.length,
        itemBuilder: (BuildContext context, int index) {
          Kombin kombin = _kombinler[index];
          if (_kombinler.isEmpty) {
            return Center(
              child: Text("data"),
            );
          }
          return kombinKarti(kombin);
        },
      ),
    );
  }

  Row kombinKarti(Kombin kombin) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          width: 80.0,
          height: 60.0,
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 2), blurRadius: 6.0)
          ]),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TekliKombin(
                            kombin: kombin,
                          )));
            },
            child: CircleAvatar(
              backgroundColor: Colors.orange[300],
              //radius: 500,
              child: CircleAvatar(
                radius: 27,
                backgroundImage: NetworkImage(kombin.kombinResmiUrl),
                // width: 60.0,
                // height: 60.0,
                // image: ,
                // fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text(
          timeago.format(kombin.olusturmaZamani.toDate(), locale: "tr"),
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
