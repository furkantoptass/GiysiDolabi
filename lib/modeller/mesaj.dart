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
    var docData = doc.data;
    return Mesaj(
      id: doc.documentID,
      alanid: docData["alanId"],
      gonderenid: docData['gonderenId'],
      icerik: docData['icerik'],
      olusturmaZamani: docData['olusturmaZamani'],
    );
  }
}
