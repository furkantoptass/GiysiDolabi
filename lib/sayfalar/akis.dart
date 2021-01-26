import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/gonderi.dart';
import 'package:socialapp/modeller/kombin.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/kombinler.dart';
import 'package:socialapp/sayfalar/kombinyukle.dart';
import 'package:socialapp/sayfalar/mesajanasayfa.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';
import 'package:socialapp/widgets/akisuturebuilder.dart';
import 'package:socialapp/widgets/gonderikarti.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Akis extends StatefulWidget {
  @override
  _AkisState createState() => _AkisState();
}

class _AkisState extends State<Akis> {
  List<Gonderi> _gonderiler = [];
  List<Kombin> _kombinler = [];
  Future<void> _akisKombinleriveGonderileriGetir() async {
    String aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifkullaniciid;
    List<Kombin> kombinler =
        await FireStoreServisi().akisKombinleriniGetir(aktifKullaniciId);
    List<Gonderi> gonderiler =
        await FireStoreServisi().akisGonderileriniGetir(aktifKullaniciId);
    if (mounted) {
      setState(() {
        _kombinler = kombinler;
        _gonderiler = gonderiler;
      });
    }
  }

  @override
  @override
  void initState() {
    super.initState();
    _akisKombinleriveGonderileriGetir();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          //shadowColor: Colors.grey[400],
          centerTitle: true,
          backgroundColor: Colors.orange[300],
          title: Text(
            "Giysi Dolabı",
            style: TextStyle(
              color: Colors.grey[100],
              fontSize: 22,
              fontFamily: 'LobsterTwoItalic',
            ),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChatRoom()));
            },
            child: Icon(
              Icons.message,
              color: Colors.grey[100],
              size: 25,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => KombinYukle()));
              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(FontAwesomeIcons.camera)

                  // Icon(
                  //   Icons.photo_camera,
                  //  color: Colors.grey[100],
                  //   size: 25,
                  ),
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(0.0),
            child: RefreshIndicator(
                child: kombinVeAkisGetir(),
                onRefresh: _akisKombinleriveGonderileriGetir)));
  }

  ListView kombinVeAkisGetir() {
    return ListView(
      children: [
        Container(
          height: 100.0,
          color: Colors.grey[200],
          child: kombinGetir(),
        ),
        Container(child: gonderiGetir()),
      ],
    );
  }

  ListView kombinGetir() {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        itemCount: _kombinler.length,
        itemBuilder: (context, index) {
          Kombin kombin = _kombinler[index];

          return FutureBuilder(
            future: FireStoreServisi().kullanicilariGetir(kombin.yayinlayanId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              }
              Kullanici kombinSahibi = snapshot.data;
              return kombinKarti(kombin, kombinSahibi);
            },
          );
        });
  }

  Column kombinKarti(Kombin kombin, Kullanici yayinlayan) {
    return Column(
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
                      builder: (context) => Kombinler(
                            kombin: _kombinler,
                            yayinlayan: yayinlayan,
                          )));
            },
            child: CircleAvatar(
              backgroundColor: Colors.orange[300],
              //radius: 500,
              child: CircleAvatar(
                radius: 27,
                backgroundImage: NetworkImage(yayinlayan.fotourl),
                // width: 60.0,
                // height: 60.0,
                // image: ,
                // fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text(
          yayinlayan.kullaniciAdi,
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  ListView gonderiGetir() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: _gonderiler.length,
      itemBuilder: (context, index) {
        Gonderi gonderi = _gonderiler[index];
        return SilinmeyenFuturuBuilder(
          future: FireStoreServisi().kullanicilariGetir(gonderi.yayinlayanId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            }
            Kullanici gonderiSahibi = snapshot.data;
            return GonderiKarti(gonderi: gonderi, yayinlayan: gonderiSahibi);
          },
        );
      },
    );
  }
}
