import 'package:cloud_firestore/cloud_firestore.dart';

class Kombin {
  final String id;
  final String kombinResmiUrl;
  final String yayinlayanId;
  final String mevsim;
  final Timestamp olusturmaZamani;

  Kombin(
      {this.id,
      this.kombinResmiUrl,
      this.yayinlayanId,
      this.mevsim,
      this.olusturmaZamani});
  factory Kombin.dokumandanuret(DocumentSnapshot doc) {
    return Kombin(
      id: doc.id,
      kombinResmiUrl: doc.data()["kombinResmiUrl"],
      yayinlayanId: doc.data()["yayinlayanId"],
      olusturmaZamani: doc.data()["olusturmaZamani"],
      mevsim: doc.data()["mevsim"],
    );
  }
}
