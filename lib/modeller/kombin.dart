import 'package:cloud_firestore/cloud_firestore.dart';

class Kombin {
  final String id;
  final String kombinResmiUrl;
  final String yayinlayanId;
  final Timestamp olusturmaZamani;

  Kombin(
      {this.id, this.kombinResmiUrl, this.yayinlayanId, this.olusturmaZamani});
  factory Kombin.dokumandanuret(DocumentSnapshot doc) {
    return Kombin(
      id: doc.documentID,
      kombinResmiUrl: doc["kombinResmiUrl"],
      yayinlayanId: doc["yayinlayanId"],
      olusturmaZamani: doc["olusturmaZamani"],
    );
  }
}
