import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/gonderi.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/profilduzenle.dart';
import 'package:socialapp/sayfalar/takipcilistesi.dart';
import 'package:socialapp/sayfalar/takipedilenlistesi.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';
import 'package:socialapp/widgets/gonderikarti.dart';

class Profil extends StatefulWidget {
  final String profilSahibiid;

  const Profil({Key key, this.profilSahibiid}) : super(key: key);
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  int _gonderiSayisi = 0;
  int _takipSayisi = 0;
  int _takipciSayisi = 0;
  List<Gonderi> _gonderiler = [];
  String gonderiStili = "Liste";
  String _aktifKullaniciId;
  Kullanici profilSahibi;
  bool takipedildi = false;
  _takipciSayisigetir() async {
    int takipciSayisi =
        await FireStoreServisi().takipciSayisi(widget.profilSahibiid);
    if (mounted) {
      setState(() {
        _takipciSayisi = takipciSayisi;
      });
    }
  }

  _takipEdilenSayisigetir() async {
    int takipEdilenSayisi =
        await FireStoreServisi().takipEdilenSayisi(widget.profilSahibiid);
    if (mounted) {
      setState(() {
        _takipSayisi = takipEdilenSayisi;
      });
    }
  }

  _gonderileriGetir() async {
    List<Gonderi> gonderiler =
        await FireStoreServisi().gonderileriGetir(widget.profilSahibiid);
    if (mounted) {
      setState(() {
        _gonderiler = gonderiler;
        _gonderiSayisi = _gonderiler.length;
      });
    }
  }

  _takipKontrol() async {
    bool takipVarMi = await FireStoreServisi().takipKontrol(
      profilSahibiId: widget.profilSahibiid,
      aktifKullaniciId: _aktifKullaniciId,
    );
    setState(() {
      takipedildi = takipVarMi;
    });
  }

  @override
  void initState() {
    super.initState();
    _takipciSayisigetir();
    _takipEdilenSayisigetir();
    _gonderileriGetir();
    _aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifkullaniciid;
    _takipKontrol();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(
          "Profil",
          style: TextStyle(
            color: Colors.grey[100],
            fontSize: 22,
            fontFamily: 'LobsterTwoItalic',
          ),
        ),
        backgroundColor: Colors.orange[300],
        actions: <Widget>[
          widget.profilSahibiid == _aktifKullaniciId
              ? IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: _cikisYap,
                  color: Colors.grey[100],
                )
              : SizedBox(
                  height: 0.0,
                ),
        ],
        iconTheme: IconThemeData(
          color: Colors.grey[100],
        ),
      ),
      body: FutureBuilder<Object>(
          future: FireStoreServisi().kullanicilariGetir(widget.profilSahibiid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            profilSahibi = snapshot.data;
            return ListView(
              children: [
                _profilDetaylari(snapshot.data),
                _gonderileriGoster(snapshot.data),
              ],
            );
          }),
    );
  }

  Widget _gonderileriGoster(Kullanici profilData) {
    if (gonderiStili == "Liste") {
      return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: _gonderiler.length,
        itemBuilder: (context, index) {
          return GonderiKarti(
            gonderi: _gonderiler[index],
            yayinlayan: profilData,
          );
        },
      );
    } else {
      List<GridTile> fayanslar = [];
      _gonderiler.forEach((gonderi) {
        fayanslar.add(_fayansOlustur(gonderi));
      });
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 1.0,
        physics: NeverScrollableScrollPhysics(),
        children: fayanslar,
      );
    }
  }

  GridTile _fayansOlustur(Gonderi gonderi) {
    return GridTile(
        child: Image.network(
      gonderi.gonderiResmiUrl,
      fit: BoxFit.cover,
    ));
  }

  Widget _profilDetaylari(Kullanici profilData) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 50.0,
                backgroundImage: profilData.fotourl.isNotEmpty
                    ? NetworkImage(profilData.fotourl)
                    : NetworkImage(
                        "https://iitee.org/wp-content/uploads/2020/05/AnonimReal.jpg"),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _sosyalSayaclar("Gönderiler", _gonderiSayisi),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TakipciListesi(
                                profilSahibiid: widget.profilSahibiid,
                              ),
                            ),
                          );
                        },
                        child: _sosyalSayaclar("Takipci", _takipciSayisi)),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TakipEdilenListesi(
                                profilSahibiid: widget.profilSahibiid,
                              ),
                            ),
                          );
                        },
                        child: _sosyalSayaclar("Takip", _takipSayisi)),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            profilData.kullaniciAdi,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(profilData.hakkinda),
          SizedBox(
            height: 25.0,
          ),
          widget.profilSahibiid == _aktifKullaniciId
              ? _profilDuzenleButonu()
              : _takipButonu(),
        ],
      ),
    );
  }

  Widget _takipButonu() {
    return takipedildi ? _takipdenCikildi() : _takipEtButonu();
  }

  Widget _takipEtButonu() {
    return Container(
      width: double.infinity,
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        onPressed: () {
          FireStoreServisi().takipEt(
            profilSahibiId: widget.profilSahibiid,
            aktifKullaniciId: _aktifKullaniciId,
          );
          setState(() {
            takipedildi = true;
            _takipciSayisi = _takipciSayisi + 1;
          });
        },
        child: Text(
          "Takip Et",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _takipdenCikildi() {
    return Container(
      width: double.infinity,
      child: OutlineButton(
        onPressed: () {
          FireStoreServisi().takipdenCik(
            profilSahibiId: widget.profilSahibiid,
            aktifKullaniciId: _aktifKullaniciId,
          );
          setState(() {
            takipedildi = false;
            _takipciSayisi = _takipciSayisi - 1;
          });
        },
        child: Text(
          "Takipden Çık",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _profilDuzenleButonu() {
    return Container(
      width: double.infinity,
      child: OutlineButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilDuzenle(
                        profil: profilSahibi,
                      )));
        },
        child: Text("Profil Düzenle"),
      ),
    );
  }

  void _cikisYap() {
    Provider.of<YetkilendirmeServisi>(context, listen: false).cikisYap();
  }

  Widget _sosyalSayaclar(String baslik, int sayi) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          sayi.toString(),
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 2.0,
        ),
        Text(
          baslik.toString(),
          style: TextStyle(fontSize: 15.0),
        ),
      ],
    );
  }
}
