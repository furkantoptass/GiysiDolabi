import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
//import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class TakipEdilenListesi extends StatefulWidget {
  final String profilSahibiid;

  const TakipEdilenListesi({Key key, this.profilSahibiid}) : super(key: key);
  @override
  _TakipEdilenListesiState createState() => _TakipEdilenListesiState();
}

class _TakipEdilenListesiState extends State<TakipEdilenListesi> {
  @override
  @override
  void initState() {
    super.initState();
  }

  void setState(fn) {
    FireStoreServisi().takipedilenListesi(widget.profilSahibiid);
  }

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
        "Takip Edilen Listesi",
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
      future: FireStoreServisi().takipedilenListesi(widget.profilSahibiid),
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
