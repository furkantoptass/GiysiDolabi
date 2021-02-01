import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/sayfalar/akis.dart';
import 'package:socialapp/sayfalar/ara.dart';
import 'package:socialapp/sayfalar/duyurular.dart';
import 'package:socialapp/sayfalar/havadurumu.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/sayfalar/yukle.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int aktifsayfano = 0;
  PageController sayfaKumandasi;
  @override
  void initState() {
    super.initState();
    sayfaKumandasi = PageController();
  }

  @override
  void dispose() {
    sayfaKumandasi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String aktifkullaniciid =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifkullaniciid;
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (acilanSayfaNo) {
          setState(() {
            aktifsayfano = acilanSayfaNo;
          });
        },
        controller: sayfaKumandasi,
        children: <Widget>[
          Akis(),
          Ara(),
          Yukle(),
          HavaDurumu(),
          Duyurular(),
          Profil(
            profilSahibiid: aktifkullaniciid,
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 48,
        animationDuration: Duration(
          milliseconds: 900,
        ),
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.grey[500],
          ),
          Icon(
            Icons.search,
            size: 30,
            color: Colors.grey[500],
          ),
          Icon(
            Icons.add_a_photo,
            size: 30,
            color: Colors.grey[500],
          ),
          Icon(
            FontAwesomeIcons.cloudSunRain,
            size: 30,
            color: Colors.grey[500],
          ),
          Icon(
            Icons.favorite_border,
            size: 30,
            color: Colors.grey[500],
          ),
          Icon(
            FontAwesomeIcons.user,
            size: 27,
            color: Colors.grey[500],
          ),
        ],
        onTap: (secilenSayfaNo) {
          setState(() {
            sayfaKumandasi.jumpToPage(secilenSayfaNo);
          });
        },
        backgroundColor: Colors.orange[300],
      ),
    );
  }
}
