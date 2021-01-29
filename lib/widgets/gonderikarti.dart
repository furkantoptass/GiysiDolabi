import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/gonderi.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/begenilistesi.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/sayfalar/yorumlar.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class GonderiKarti extends StatefulWidget {
  final Gonderi gonderi;
  final Kullanici yayinlayan;

  const GonderiKarti({Key key, this.gonderi, this.yayinlayan})
      : super(key: key);

  @override
  _GonderiKartiState createState() => _GonderiKartiState();
}

class _GonderiKartiState extends State<GonderiKarti> {
  int _begeniSayisi = 0;
  bool _begendin = false;
  String _aktifKullaniciID;
  @override
  // ignore: must_call_super
  void initState() {
    _begeniSayisi = widget.gonderi.begeniSayisi;
    _aktifKullaniciID =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifkullaniciid;
    begeniVarmi();
  }

  begeniVarmi() async {
    bool begeniVarMi =
        await FireStoreServisi().begeniVarmi(widget.gonderi, _aktifKullaniciID);
    if (begeniVarMi) {
      if (mounted) {
        setState(() {
          _begendin = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [gonderiBasligi(), gonderiResmi(), gonderiAlt()],
        ));
  }

  gonderiSecenekleri() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Seçiminiz Nedir",
            ),
            children: [
              SimpleDialogOption(
                child: Text("Gönderiyi Sil"),
                onPressed: () {
                  FireStoreServisi().gonderiSil(
                      aktifKullaniciId: _aktifKullaniciID,
                      gonderi: widget.gonderi);
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Geri Dön",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Widget gonderiBasligi() {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profil(
                          profilSahibiid: widget.gonderi.yayinlayanId,
                        )));
          },
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            backgroundImage: widget.yayinlayan.fotourl.isNotEmpty
                ? NetworkImage(widget.yayinlayan.fotourl)
                : AssetImage("assets/images/furkan.png"),
          ),
        ),
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Profil(
                        profilSahibiid: widget.gonderi.yayinlayanId,
                      )));
        },
        child: Text(
          widget.yayinlayan.kullaniciAdi,
          style: TextStyle(
              fontSize: 16.0,
              fontFamily: "RobotoLight",
              fontWeight: FontWeight.w700),
        ),
      ),
      trailing: _aktifKullaniciID == widget.gonderi.yayinlayanId
          ? IconButton(
              icon: Icon(
                Icons.more_vert,
              ),
              onPressed: () => gonderiSecenekleri(),
            )
          : null,
      contentPadding: EdgeInsets.all(0.0),
    );
  }

  Widget gonderiResmi() {
    return GestureDetector(
      onDoubleTap: _begeniDegistir,
      child: Image.network(
        widget.gonderi.gonderiResmiUrl,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget gonderiAlt() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //      widget.gonderi.aciklama.isNotEmpty ?
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: RichText(
                text: TextSpan(
                  text: widget.yayinlayan.kullaniciAdi + " ",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "RobotoBlack",
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                        text: widget.gonderi.aciklama,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: "RobotoLight",
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),

            Spacer(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: !_begendin
                        ? Icon(
                            Icons.favorite_border,
                            size: 35.0,
                          )
                        : Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 35.0,
                          ),
                    onPressed: _begeniDegistir,
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.commentDots,
                      size: 30.0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Yorumlar(
                            gonderi: widget.gonderi,
                          ),
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BegeniListesi(
                                gonderi: widget.gonderi,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "$_begeniSayisi Beğeni",
                          style: TextStyle(
                              fontSize: 15.0, fontFamily: "RobotoBlack"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 2.0,
        ),
        // widget.gonderi.aciklama.isNotEmpty
        //     ? Padding(
        //         padding: const EdgeInsets.only(left: 8.0),
        //         child: RichText(
        //           text: TextSpan(
        //             text: widget.yayinlayan.kullaniciAdi + " ",
        //             style: TextStyle(
        //               fontSize: 15.0,
        //               fontFamily: "RobotoBlack",
        //               color: Colors.black,
        //             ),
        //             children: [
        //               TextSpan(
        //                   text: widget.gonderi.aciklama,
        //                   style: TextStyle(
        //                       color: Colors.black,
        //                       fontSize: 14.0,
        //                       fontFamily: "RobotoBold")),
        //             ],
        //           ),
        //         ),
        //       )
        //     : SizedBox(
        //         height: 0.0,
        //       ),
      ],
    );
  }

  void _begeniDegistir() {
    if (_begendin) {
      setState(() {
        _begendin = false;
        _begeniSayisi = _begeniSayisi - 1;
      });
      FireStoreServisi().gonderiBegenKaldir(widget.gonderi, _aktifKullaniciID);
    } else {
      setState(() {
        _begendin = true;
        _begeniSayisi = _begeniSayisi + 1;
      });
      FireStoreServisi().gonderiBegen(widget.gonderi, _aktifKullaniciID);
    }
  }
}
