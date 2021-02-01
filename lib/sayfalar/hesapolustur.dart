import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class HesapOlustur extends StatefulWidget {
  @override
  _HesapOlusturState createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  bool yukleniyor = false;
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();

  String kullaniciAdi, email, sifre;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldAnahtari,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 50,
          title: Text(
            "Hesap Olustur",
            style: TextStyle(
              color: Colors.grey[100],
              fontSize: 22,
              fontFamily: 'LobsterTwoItalic',
            ),
          ),
          backgroundColor: Colors.orange[300],
        ),
        body: ListView(
          children: <Widget>[
            yukleniyor
                ? LinearProgressIndicator()
                : SizedBox(
                    height: 0.0,
                  ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: _formAnahtari,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autocorrect: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Kullanıcı Adı Girin",
                          labelText: "Kullanıcı Adı:",
                          errorStyle: TextStyle(fontSize: 17.0),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (girilenDeger) {
                          if (girilenDeger.isEmpty) {
                            return "Kullanıcı Adı boş bırakılmaz";
                          } else if (girilenDeger.trim().length < 4 ||
                              girilenDeger.trim().length > 10) {
                            return " Kullanıcı adı 4 karakterden küçük 10 karakterden büyük olamaz";
                          }
                          return null;
                        },
                        onSaved: (girilenDeger) {
                          kullaniciAdi = girilenDeger;
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email Adresinizi Girin",
                          labelText: "Email Adresi:",
                          errorStyle: TextStyle(fontSize: 17.0),
                          prefixIcon: Icon(Icons.mail),
                        ),
                        validator: (girilenDeger) {
                          if (girilenDeger.isEmpty) {
                            return "Email alanı boş bırakılmaz";
                          } else if (!girilenDeger.contains("@")) {
                            return "Girilen değer mail değil";
                          }
                          return null;
                        },
                        onSaved: (girilenDeger) {
                          email = girilenDeger;
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Şifrenizi  Girin",
                          labelText: "Şifre:",
                          errorStyle: TextStyle(fontSize: 17.0),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (girilenDeger) {
                          if (girilenDeger.isEmpty) {
                            return "Şifre alanı boş bırakılmaz";
                          } else if (girilenDeger.trim().length < 4) {
                            return "Şifre 4 karakterden az olamaz";
                          }
                          return null;
                        },
                        onSaved: (girilenDeger) {
                          sifre = girilenDeger;
                        },
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: FlatButton(
                          onPressed: _register,
                          child: Text(
                            "Hesap Oluştur",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          color: Colors.orange[300],
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ));
  }

  void _register() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    var _formState = _formAnahtari.currentState;
    if (_formState.validate()) {
      _formState.save();
      setState(() {
        yukleniyor = true;
      });
      try {
        Kullanici kullanici =
            await _yetkilendirmeServisi.mailileKayit(email, sifre);
        if (kullanici != null) {
          FireStoreServisi().kullaniciOlustur(
              id: kullanici.id, email: email, kullaniciAdi: kullaniciAdi);
        }
        Navigator.pop(context);
      } catch (err) {
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hatakodu: err.code);
      }
    }
  }

  uyariGoster({hatakodu}) {
    String errMsg;
    if (hatakodu == "ERROR_INVALID_EMAIL") {
      errMsg = "Email Adresi Geçersiz";
    } else if (hatakodu == "ERROR_EMAIL_ALREADY_IN_USE") {
      errMsg = "Email Adresi Kullanılıyor";
    } else if (hatakodu == "ERROR_WEAK_PASSWORD") {
      errMsg = "Şifre 6 karakterden az olamaz";
    }
    var snackBar = SnackBar(
      content: Text(errMsg),
    );
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}
