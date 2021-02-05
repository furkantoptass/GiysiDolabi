import 'package:flutter/material.dart';
import 'package:socialapp/modeller/gonderi.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/widgets/gonderikarti.dart';

class TekliGonderi extends StatefulWidget {
  final String gonderiId;
  final String gonderiSahibiId;

  const TekliGonderi({Key key, this.gonderiId, this.gonderiSahibiId})
      : super(key: key);

  @override
  _TekliGonderiState createState() => _TekliGonderiState();
}

class _TekliGonderiState extends State<TekliGonderi> {
  Gonderi _gonderi;
  Kullanici _gonderiSahibi;
  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    gonderiGetir();
  }

  gonderiGetir() async {
    Gonderi gonderi = await FireStoreServisi()
        .tekliGonderiGetir(widget.gonderiId, widget.gonderiSahibiId);
    if (gonderi != null) {
      Kullanici gonderiSahibi =
          await FireStoreServisi().kullanicilariGetir(widget.gonderiSahibiId);
      setState(() {
        _gonderi = gonderi;
        _gonderiSahibi = gonderiSahibi;
        _yukleniyor = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        centerTitle: true,
        title: Text(
          "Gönderi",
          style: TextStyle(color: Colors.black, fontFamily: "RobotoBlack"),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: !_yukleniyor
          ? GonderiKarti(
              gonderi: _gonderi,
              yayinlayan: _gonderiSahibi,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
