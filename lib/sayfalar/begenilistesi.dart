import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:socialapp/modeller/gonderi.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
//import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class BegeniListesi extends StatefulWidget {
  final Gonderi gonderi;

  const BegeniListesi({Key key, this.gonderi}) : super(key: key);
  @override
  _BegeniListesiState createState() => _BegeniListesiState();
}

class _BegeniListesiState extends State<BegeniListesi> {
  @override
  @override
  void initState() {
    super.initState();
  }

  void setState(fn) {
    FireStoreServisi().begeniListesi(widget.gonderi.id);
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
      titleSpacing: 0.0,
      backgroundColor: Colors.orange[400],
      toolbarHeight: 50,
      title: Text(
        "Gönderi Beğenileri",
        style: TextStyle(
          color: Colors.grey[100],
          fontSize: 22,
          fontFamily: 'LobsterTwoItalic',
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
      future: FireStoreServisi().begeniListesi(widget.gonderi.id),
      builder: (context, snapshot) {
        //print(snapshot);
        if (!snapshot.hasData) {
          return Center(child: Text("Henüz Hiç Beğeni Yok"));
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
