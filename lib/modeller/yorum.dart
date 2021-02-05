import 'package:cloud_firestore/cloud_firestore.dart';

class Yorum {
  final String id;
  final String icerik;
  final String yayinlayanid;
  final Timestamp olusturmaZamani;

  Yorum({this.id, this.icerik, this.yayinlayanid, this.olusturmaZamani});

  factory Yorum.dokumandanuret(DocumentSnapshot doc) {
    return Yorum(
      id: doc.id,
      icerik: doc.data()["icerik"],
      yayinlayanid: doc.data()['yayinlayanID'],
      olusturmaZamani: doc.data()['olusturmaZamani'],
    );
  }
}
