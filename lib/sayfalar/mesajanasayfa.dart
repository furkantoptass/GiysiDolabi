import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/mesajolustur.dart';
import 'package:socialapp/sayfalar/mesajsayfasi.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  List<String> users;
  String _aktifKullaniciId;

  @override
  void initState() {
    super.initState();
    _aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifkullaniciid;
    // getUserInfogetChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MESAJLAR"),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: sonuclariGetir(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MesajOlustur()));
          }),
    );
  }

  getUserInfogetChats() async {
    //Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    //FireStoreServisi().getUserChats2(_aktifKullaniciId).then((snapshots) {});
  }

  sonuclariGetir() {
    return FutureBuilder<List<Kullanici>>(
      future: FireStoreServisi().getUserChats2(_aktifKullaniciId),
      builder: (context, snapshots) {
        //print(snapshot);
        if (!snapshots.hasData) {
          return Center(child: Text("HİÇ MESAJ YOK"));
        }
        return ListView.builder(
          itemCount: snapshots.data.length,
          itemBuilder: (context, index) {
            Kullanici kullanici = snapshots.data[index];
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
