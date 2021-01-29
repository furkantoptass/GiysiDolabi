import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/mesajsayfasi.dart';
//import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class MesajOlustur extends StatefulWidget {
  @override
  _MesajOlusturState createState() => _MesajOlusturState();
}

class _MesajOlusturState extends State<MesajOlustur> {
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
    FireStoreServisi().takipedilenListesi(_aktifKullaniciId);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarOlustur(),
      body: sonuclariGetir(),
    );
  }

  AppBar _appbarOlustur() {
    return AppBar(
      titleSpacing: 0.0,
      toolbarHeight: 50,
      //shadowColor: Colors.grey[400],
      centerTitle: true,
      backgroundColor: Colors.orange[300],
      title: Text(
        "Takip Edilen Listesi",
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
      future: FireStoreServisi().takipedilenListesi(_aktifKullaniciId),
      builder: (context, snapshot) {
        //print(snapshot);

        if (!snapshot.hasData) {
          return Center(child: Text("Kimseyi Takip Etmiyorsunuz"));
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
    Icon(Icons.message);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MesajSayfasi(
                      mesajgideniid: kullanici.id,
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
