import 'package:flutter/material.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';

class Ara extends StatefulWidget {
  @override
  _AraState createState() => _AraState();
}

class _AraState extends State<Ara> {
  TextEditingController _aramaKontrol = TextEditingController();
  Future<List<Kullanici>> aramaSonucu;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarOlustur(),
      body: aramaSonucu != null ? sonuclariGetir() : aramaYok(),
    );
  }

  AppBar _appbarOlustur() {
    return AppBar(
      toolbarHeight: 50,
      // titleSpacing: 0.0,
      backgroundColor: Colors.orange[300],
      title: TextFormField(
        onFieldSubmitted: (girilenDeger) {
          setState(() {
            aramaSonucu = FireStoreServisi().kullaniciAra(girilenDeger);
          });
        },
        controller: _aramaKontrol,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            size: 30.0,
            color: Colors.grey[400],
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.grey[400],
            ),
            onPressed: () {
              _aramaKontrol.clear();
              setState(() {
                aramaSonucu = null;
              });
            },
          ),
          border: new OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange[400],
            ),
            borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
          ), //InputBorder.none,
          fillColor: Colors.grey[100],
          filled: true,
          hintText: "Kullanıcı Ara",
          contentPadding: EdgeInsets.only(top: 16.0),
        ),
      ),
    );
  }

  aramaYok() {
    return Container(
      decoration: new BoxDecoration(color: Colors.orange[300]),
      child: Center(child: Text("Kullanici Ara")),
    );
  }

  sonuclariGetir() {
    return FutureBuilder<List<Kullanici>>(
      future: aramaSonucu,
      builder: (context, snapshot) {
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
