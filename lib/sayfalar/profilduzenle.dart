import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/storageservis.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class ProfilDuzenle extends StatefulWidget {
  final Kullanici profil;

  const ProfilDuzenle({Key key, this.profil}) : super(key: key);
  @override
  _ProfilDuzenleState createState() => _ProfilDuzenleState();
}

class _ProfilDuzenleState extends State<ProfilDuzenle> {
  var _formkey = GlobalKey<FormState>();
  String _kullaniciAdi;
  String _hakkinda;
  File _secilmisFoto;
  bool _yukleniyor = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        //shadowColor: Colors.grey[400],
        centerTitle: true,
        backgroundColor: Colors.orange[300],
        title: Text(
          "Profil Düzenle",
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
        actions: [
          IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.grey[100],
              ),
              onPressed: _kaydet),
        ],
      ),
      body: ListView(
        children: [
          _yukleniyor
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
          profilFoto(),
          kullaniciBilgieri(),
        ],
      ),
    );
  }

  _kaydet() async {
    if (_formkey.currentState.validate()) {
      setState(() {
        _yukleniyor = true;
      });
      _formkey.currentState.save();
      String profilFotourl;
      if (_secilmisFoto == null) {
        profilFotourl = widget.profil.fotourl;
      } else {
        profilFotourl = await StorageServisi().profilResmiYukle(_secilmisFoto);
      }

      String aktifKullaniciId =
          Provider.of<YetkilendirmeServisi>(context, listen: false)
              .aktifkullaniciid;
      FireStoreServisi().kullaniciGuncelle(
        kullaniciID: aktifKullaniciId,
        kullaniciAdi: _kullaniciAdi,
        hakkinda: _hakkinda,
        fotoUrl: profilFotourl,
      );
      setState(() {
        _yukleniyor = false;
      });
      Navigator.pop(context);
    }
  }

  galeridenSec() async {
    var image = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 800.0,
        maxHeight: 600.0,
        imageQuality: 80);
    setState(() {
      _secilmisFoto = File(image.path);
    });
  }

  profilFoto() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 20.0),
      child: Center(
        child: InkWell(
          onTap: galeridenSec,
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 55.0,
            backgroundImage: _secilmisFoto == null
                ? NetworkImage(widget.profil.fotourl)
                : FileImage(_secilmisFoto),
          ),
        ),
      ),
    );
  }

  kullaniciBilgieri() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              initialValue: widget.profil.kullaniciAdi,
              decoration: InputDecoration(
                labelText: "Kullanıcı Adı",
              ),
              validator: (girilenDeger) {
                return girilenDeger.trim().length <= 3
                    ? "Kullanıcı Adı en az 4 karakter"
                    : null;
              },
              onSaved: (girilenDeger) {
                _kullaniciAdi = girilenDeger;
              },
            ),
            TextFormField(
              initialValue: widget.profil.hakkinda,
              decoration: InputDecoration(
                labelText: "Hakkında",
              ),
              validator: (girilenDeger) {
                return girilenDeger.trim().length >= 100
                    ? "Hakkında en az 100 karakter"
                    : null;
              },
              onSaved: (girilenDeger) {
                _hakkinda = girilenDeger;
              },
            ),
          ],
        ),
      ),
    );
  }
}
