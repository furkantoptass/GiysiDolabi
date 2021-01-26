import 'package:provider/provider.dart';
import 'package:socialapp/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/hesapolustur.dart';
import 'package:socialapp/sayfalar/sifresifirla.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  bool yukleniyor = false;
  String email, sifre;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      body: Stack(
        children: <Widget>[
          _sayfaelemanlari(),
          _yuklemeanimasyonu(),
        ],
      ),
    );
  }

  Widget _yuklemeanimasyonu() {
    if (yukleniyor) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Center();
    }
  }

  Widget _sayfaelemanlari() {
    return Form(
      key: _formAnahtari,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.orange[900],
          Colors.orange[800],
          Colors.orange[400]
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Giriş",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                      1.3,
                      Text(
                        "Hoşgeldiniz",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ],
              ),
            ),
            SizedBox(height: 0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                            1.4,
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(225, 95, 27, .3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextFormField(
                                      autocorrect: true,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          errorStyle: TextStyle(fontSize: 13.0),
                                          prefixIcon: Icon(Icons.mail),
                                          hintText: "Email",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                      validator: (girilenDeger) {
                                        if (girilenDeger.isEmpty) {
                                          return "Email alanı boş bırakılmaz";
                                        } else if (!girilenDeger
                                            .contains("@")) {
                                          return "Girilen değer mail değil";
                                        }
                                        return null;
                                      },
                                      onSaved: (girilenDeger) =>
                                          email = girilenDeger,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextFormField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          errorStyle: TextStyle(fontSize: 13.0),
                                          prefixIcon: Icon(Icons.lock),
                                          hintText: "Şifre",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                      validator: (girilenDeger) {
                                        if (girilenDeger.isEmpty) {
                                          return "Şifre alanı boş bırakılmaz";
                                        } else if (girilenDeger.trim().length <
                                            4) {
                                          return "Şifre 4 karakterden az olamaz";
                                        }
                                        return null;
                                      },
                                      onSaved: (girilenDeger) =>
                                          sifre = girilenDeger,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                          1.5,
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SifreSifirla()));
                            },
                            child: Text(
                              "Şifremi Unuttum",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        FadeAnimation(
                          1.5,
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HesapOlustur()));
                            },
                            child: Text(
                              "Hesap Oluştur",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                            1.6,
                            InkWell(
                              onTap: _girisyap,
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orange[900]),
                                child: Center(
                                  child: Text(
                                    "Giriş",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                          1.7,
                          Text(
                            "Veya",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: _googleIleGiris,
                                child: Image(
                                    image:
                                        AssetImage('assets/images/google.png')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _girisyap() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    if (_formAnahtari.currentState.validate()) {
      _formAnahtari.currentState.save();
      setState(() {
        yukleniyor = true;
      });
      try {
        await _yetkilendirmeServisi.mailileGiris(email, sifre);
      } catch (err) {
        uyariGoster(hatakodu: err.code);
      }
    }
  }

  void _googleIleGiris() async {
    var _yetkilendirmeservisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    setState(() {
      yukleniyor = true;
    });
    try {
      Kullanici kullanici = await _yetkilendirmeservisi.googleIleGiris();
      if (kullanici != null) {
        Kullanici _firestoreKullanici =
            await FireStoreServisi().kullanicilariGetir(kullanici.id);
        if (_firestoreKullanici == null) {
          FireStoreServisi().kullaniciOlustur(
              id: kullanici.id,
              email: kullanici.email,
              kullaniciAdi: kullanici.kullaniciAdi,
              fotoUrl: kullanici.fotourl);
          print("ssssss");
        }
      }
    } catch (err) {
      uyariGoster(hatakodu: err.code);
      setState(() {
        yukleniyor = false;
      });
    }
  }

  uyariGoster({hatakodu}) {
    String errMsg;
    if (hatakodu == "ERROR_INVALID_EMAIL") {
      errMsg = "Email Adresi Geçersiz";
    } else if (hatakodu == "ERROR_WRONG_PASSWORD") {
      errMsg = "Şifre Hatalı";
    } else if (hatakodu == "ERROR_USER_NOT_FOUND") {
      errMsg = "Kullanıcı bulunamadı";
    } else if (hatakodu == "ERROR_USER_DISABLED") {
      errMsg = "Kullanıcı engellenmiş";
    } else {
      errMsg = "Tanımlanamayan Hata $hatakodu";
    }
    var snackBar = SnackBar(
      content: Text(errMsg),
    );
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}
