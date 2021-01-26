import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class TakipciListesi extends StatefulWidget {
  final String profilSahibiid;

  const TakipciListesi({Key key, this.profilSahibiid}) : super(key: key);
  @override
  _TakipciListesiState createState() => _TakipciListesiState();
}

class _TakipciListesiState extends State<TakipciListesi> {
  // ignore: unused_field
  String _aktifKullaniciId;
  @override
  @override
  void initState() {
    super.initState();
    _aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifkullaniciid;
  }

  void setState(fn) {
    FireStoreServisi().takipciListesi(widget.profilSahibiid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarOlustur(),
      body: sonuclariGetir(),
    );
  }

  AppBar _appbarOlustur() {
    return AppBar(
      toolbarHeight: 50,
      titleSpacing: 0.0,
      backgroundColor: Colors.orange[400],
      title: Text(
        "Takipci Listesi",
        style: TextStyle(
          color: Colors.grey[100],
          fontSize: 22,
          fontFamily: 'LobsterTwoBoldItalic',
        ),
      ),
      leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.grey[100],
          ),
          onPressed: () => Navigator.pop(context)),
    );
  }

  sonuclariGetir() {
    return FutureBuilder<List<Kullanici>>(
      future: FireStoreServisi().takipciListesi(widget.profilSahibiid),
      builder: (context, snapshot) {
        //print(snapshot);

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.length == 0) {
          return Center(child: Text("Bu arama için Sonuç bulunamadı"));
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            Kullanici kullanici = snapshot.data[index];
            return kullaniciSatiri(kullanici);
          },
        );
      },
    );
  }

  kullaniciSatiri(Kullanici kullanici) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Profil(
                      profilSahibiid: kullanici.id,
                    )));
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            kullanici.fotourl,
          ),
        ),
        title: Text(
          kullanici.kullaniciAdi,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
