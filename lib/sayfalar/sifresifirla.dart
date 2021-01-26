import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class SifreSifirla extends StatefulWidget {
  @override
  _SifreSifirlaState createState() => _SifreSifirlaState();
}

class _SifreSifirlaState extends State<SifreSifirla> {
  bool yukleniyor = false;
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();

  String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldAnahtari,
        appBar: AppBar(
          title: Text("Şifre Sıfırla"),
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
                        height: 50.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: FlatButton(
                          onPressed: sifreSifirla,
                          child: Text(
                            "Şifre Sıfırla",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ));
  }

  void sifreSifirla() async {
    // ignore: unused_local_variable
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    var _formState = _formAnahtari.currentState;
    if (_formState.validate()) {
      _formState.save();
      setState(() {
        yukleniyor = true;
      });
      try {
        await YetkilendirmeServisi().sifreSifirla(email);
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
    } else if (hatakodu == "ERROR_USER_NOT_FOUND") {
      errMsg = "Bu mailde kullanici bulunmuyor";

      var snackBar = SnackBar(
        content: Text(errMsg),
      );
      _scaffoldAnahtari.currentState.showSnackBar(snackBar);
    }
  }
}
