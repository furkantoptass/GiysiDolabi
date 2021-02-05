import 'package:cloud_firestore/cloud_firestore.dart';

class Mesaj {
  final String id;
  final String gonderenid;
  final String alanid;
  final String icerik;
  final Timestamp olusturmaZamani;

  Mesaj(
      {this.gonderenid,
      this.alanid,
      this.icerik,
      this.olusturmaZamani,
      this.id});
  factory Mesaj.dokumandanuret(DocumentSnapshot doc) {
    return Mesaj(
      id: doc.id,
      alanid: doc.data()["alanId"],
      gonderenid: doc.data()['gonderenId'],
      icerik: doc.data()['icerik'],
      olusturmaZamani: doc.data()['olusturmaZamani'],
    );
  }
}
