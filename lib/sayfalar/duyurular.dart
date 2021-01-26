import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/duyuru.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/sayfalar/tekligonderi.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';
import 'package:timeago/timeago.dart' as timeago;

class Duyurular extends StatefulWidget {
  @override
  _DuyurularState createState() => _DuyurularState();
}

class _DuyurularState extends State<Duyurular> {
  List<Duyuru> _duyurular;
  String _aktifKullaniciId;
  bool _yukleniyor = true;
  @override
  // ignore: must_call_super
  void initState() {
    _aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifkullaniciid;
    duyurulariGetir();
    timeago.setLocaleMessages('tr', timeago.TrMessages());
  }

  Future<void> duyurulariGetir() async {
    List<Duyuru> duyurular =
        await FireStoreServisi().duyurulariGetir(_aktifKullaniciId);
    if (mounted) {
      setState(() {
        _duyurular = duyurular;
        _yukleniyor = false;
      });
    }
  }

  duyurulariGoster() {
    if (_yukleniyor) {
      return Center(child: CircularProgressIndicator());
    }
    if (_duyurular.isEmpty) {
      return Center(child: Text("Hiç Duyurunuz Yok"));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: RefreshIndicator(
        onRefresh: duyurulariGetir,
        child: ListView.builder(
          itemCount: _duyurular.length,
          itemBuilder: (context, index) {
            Duyuru duyuru = _duyurular[index];
            return duyuruSatiri(duyuru);
          },
        ),
      ),
    );
  }

  duyuruSatiri(Duyuru duyuru) {
    String mesaj = mesajOlustur(duyuru.aktiviteTipi);
    return FutureBuilder(
      future: FireStoreServisi().kullanicilariGetir(duyuru.aktiviteYapanId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: 0.0,
          );
        }
        Kullanici aktiviteYapan = snapshot.data;
        return ListTile(
          leading: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profil(
                    profilSahibiid: duyuru.aktiviteYapanId,
                  ),
                ),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                aktiviteYapan.fotourl,
              ),
            ),
          ),
          title: RichText(
            text: TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profil(
                          profilSahibiid: duyuru.aktiviteYapanId,
                        ),
                      ),
                    );
                  },
                text: "${aktiviteYapan.kullaniciAdi} ",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: duyuru.yorum == null
                        ? "$mesaj"
                        : "$mesaj ${duyuru.yorum}",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  )
                ]),
          ),
          subtitle: Text(
              timeago.format(duyuru.olusturulmaZamani.toDate(), locale: "tr")),
          trailing: gonderiGorsel(
            duyuru.aktiviteTipi,
            duyuru.gonderiFoto,
            duyuru.gonderiId,
          ),
        );
      },
    );
  }

  gonderiGorsel(String aktiviteTipi, String gonderiFoto, String gonderiId) {
    if (aktiviteTipi == "takip") {
      return null;
    } else if (aktiviteTipi == "beğeni" || aktiviteTipi == "yorum") {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TekliGonderi(
                gonderiId: gonderiId,
                gonderiSahibiId: _aktifKullaniciId,
              ),
            ),
          );
        },
        child: Image.network(
          gonderiFoto,
          width: 50.0,
          fit: BoxFit.cover,
          height: 50.0,
        ),
      );
    }
  }

  mesajOlustur(String aktiviteTipi) {
    if (aktiviteTipi == "beğeni") {
      return "gönderini beğendi";
    } else if (aktiviteTipi == "takip") {
      return "Seni Takip Etti";
    } else if (aktiviteTipi == "yorum") {
      return ("Gonderine Yorum yaptı");
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(
          "Duyurular",
          style: TextStyle(
            color: Colors.grey[100],
            fontSize: 22,
            fontFamily: 'LobsterTwoItalic',
          ),
        ),
        backgroundColor: Colors.orange[300],
      ),
      body: duyurulariGoster(),
    );
  }
}
