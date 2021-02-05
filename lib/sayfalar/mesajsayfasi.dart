import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/modeller/mesaj.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';
import 'package:timeago/timeago.dart' as timeago;

class MesajSayfasi extends StatefulWidget {
  final String mesajgideniid;
  final String chatroomId;
  const MesajSayfasi({Key key, this.mesajgideniid, this.chatroomId})
      : super(key: key);
  @override
  _MesajSayfasiState createState() => _MesajSayfasiState();
}

class _MesajSayfasiState extends State<MesajSayfasi> {
  List<String> users = [];
  bool sendByMe = false;

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
    //mesajOdasiOlustur();
    _aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifkullaniciid;

    timeago.setLocaleMessages('tr', timeago.TrMessages());
  }

  String _aktifKullaniciId;
  TextEditingController _mesajkontrol = TextEditingController();
  Kullanici gidenmesajsahibi;

  Future<List<Kullanici>> aramaSonucu;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: kullaniGetir(),
    );
  }

  FutureBuilder<Object> kullaniGetir() {
    return FutureBuilder<Object>(
      future: FireStoreServisi().kullanicilariGetir(widget.mesajgideniid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        gidenmesajsahibi = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profil(
                            profilSahibiid: gidenmesajsahibi.id,
                          ),
                        ),
                      );
                    });
                  },
                  child: Container(
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(gidenmesajsahibi.fotourl),
                      radius: 20,
                    ),
                  ),
                ),
              ),
            ],
            centerTitle: true,
            toolbarHeight: 50.0,
            backgroundColor: Colors.orange[300],
            title: Text(
              gidenmesajsahibi.kullaniciAdi + " İle Mesaj",
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 17,
                fontFamily: 'RobotoLightItalic',
              ),
            ),
          ),
          body: Column(
            children: [
              _mesajlariGoster(),
              mesajYaz(),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        );
      },
    );
  }

  _mesajlariGoster() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FireStoreServisi().mesajGoster(
            chatRoomId: getChatRoomId(widget.mesajgideniid, _aktifKullaniciId),
            alanId: widget.mesajgideniid,
            aktifKullaniciId: _aktifKullaniciId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              Mesaj yorum = Mesaj.dokumandanuret(snapshot.data.docs[index]);
              print(context);
              return mesajSatiri(yorum);
            },
          );
        },
      ),
    );
  }

  mesajSatiri(Mesaj mesaj) {
    return FutureBuilder<Kullanici>(
      future: FireStoreServisi().kullanicilariGetir(mesaj.gonderenid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          );
        }
        Kullanici yayinlayan = snapshot.data;
        if (_aktifKullaniciId == mesaj.gonderenid) {
          sendByMe = true;
        } else {
          sendByMe = false;
        }
        return mesajalign(mesaj, yayinlayan, sendByMe);
      },
    );
  }

  Align mesajalign(Mesaj mesaj, Kullanici yayinlayan, sendByMe) {
    return Align(
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin:
              sendByMe ? EdgeInsets.only(left: 15) : EdgeInsets.only(right: 15),
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
          decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [Colors.black, Colors.grey]
                  : [Colors.brown, Colors.brown],
            ),
          ),
          child: Column(
            children: [
              Text(
                mesaj.icerik,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.grey[100],
                  fontSize: 15,
                  fontFamily: 'RobotoLight',
                ),
              ),
              Text(
                timeago.format(mesaj.olusturmaZamani.toDate(), locale: "tr"),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  mesajYaz() {
    return ListTile(
      title: TextFormField(
        controller: _mesajkontrol,
        decoration: InputDecoration(
          hintText: "Mesajı Buraya Yazın",
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.send),
        onPressed: _mesajYaz,
      ),
    );
  }

  void _mesajYaz() {
    mesajOdasiOlustur();
    FireStoreServisi().mesajEkle(
      chatRoomId: getChatRoomId(widget.mesajgideniid, _aktifKullaniciId),
      alanId: widget.mesajgideniid,
      aktifKullaniciId: _aktifKullaniciId,
      icerik: _mesajkontrol.text,
    );
    _mesajkontrol.clear();
  }

  void mesajOdasiOlustur() {
    List<String> users = [widget.mesajgideniid, _aktifKullaniciId];
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": getChatRoomId(widget.mesajgideniid, _aktifKullaniciId),
    };

    FireStoreServisi().chatOdasiOlustur(
      chatRoom,
      getChatRoomId(widget.mesajgideniid, _aktifKullaniciId),
    );
  }
}
