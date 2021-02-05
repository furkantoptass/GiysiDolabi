import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/hesapolustur.dart';
import 'package:socialapp/sayfalar/sifresifirla.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class EmailFieldValidator {
  static String validate(String girilenDeger) {
    if (girilenDeger.isEmpty) {
      return "Email alanı boş bırakılmaz";
    } else if (!girilenDeger.contains("@")) {
      return "Girilen değer mail değil";
    }
    return null;
  }
}

class PasswordFieldValidator {
  static String validate(String girilenDeger) {
    if (girilenDeger.isEmpty) {
      return "Şifre alanı boş bırakılmaz";
    } else if (girilenDeger.trim().length < 4) {
      return "Şifre 4 karakterden az olamaz";
    }
    return null;
  }
}

class GirisSayfasi extends StatefulWidget {
  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
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
      child: ListView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 60.0),
        children: <Widget>[
          Image.asset("assets/images/giysidolab-logo.png"),
          /*FlutterLogo(
            size: 90.0,
          ),*/
          SizedBox(
            height: 80.0,
          ),
          TextFormField(
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email Adresinizi Girin",
              errorStyle: TextStyle(fontSize: 17.0),
              prefixIcon: Icon(Icons.mail),
            ),
            validator: EmailFieldValidator.validate,
            onSaved: (girilenDeger) => email = girilenDeger,
          ),
          SizedBox(
            height: 40.0,
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Şifrenizi  Girin",
              errorStyle: TextStyle(fontSize: 17.0),
              prefixIcon: Icon(Icons.lock),
            ),
            validator: PasswordFieldValidator.validate,
            onSaved: (girilenDeger) => sifre = girilenDeger,
          ),
          SizedBox(
            height: 40.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HesapOlustur()));
                  },
                  child: Text(
                    "Hesap Oluştur",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),
              ),
              SizedBox(
                width: 35.0,
              ),
              Expanded(
                child: FlatButton(
                  onPressed: _girisyap,
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColorDark,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: Text("veya"),
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: InkWell(
              onTap: _googleIleGiris,
              child: Text(
                "Google İle Giriş Yap",
                style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SifreSifirla()));
              },
              child: Text("Şifremi Unuttum"),
            ),
          ),
        ],
      ),
    );
  }

  void _girisyap() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    if (_formAnahtari.currentState.validate()) {
      _formAnahtari.currentState.save();
      setState(() {
        yukleniyor = false;
      });
      try {
        await _yetkilendirmeServisi.mailileGiris(email, sifre);
      } catch (err) {
        uyariGoster(hatakodu: err.code);
        yukleniyor = false;
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
