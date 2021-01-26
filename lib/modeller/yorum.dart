import 'package:cloud_firestore/cloud_firestore.dart';

class Yorum {
  final String id;
  final String icerik;
  final String yayinlayanid;
  final Timestamp olusturmaZamani;

  Yorum({this.id, this.icerik, this.yayinlayanid, this.olusturmaZamani});

  factory Yorum.dokumandanuret(DocumentSnapshot doc) {
    var docData = doc.data;
    return Yorum(
      id: doc.documentID,
      icerik: docData['icerik'],
      yayinlayanid: docData['yayinlayanID'],
      olusturmaZamani: docData['olusturmaZamani'],
    );
  }
}
