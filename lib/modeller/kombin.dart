import 'package:cloud_firestore/cloud_firestore.dart';

class Kombin {
  final String id;
  final String kombinResmiUrl;
  final String yayinlayanId;

  Kombin({this.id, this.kombinResmiUrl, this.yayinlayanId});
  factory Kombin.dokumandanuret(DocumentSnapshot doc) {
    return Kombin(
      id: doc.documentID,
      kombinResmiUrl: doc["kombinResmiUrl"],
      yayinlayanId: doc["yayinlayanId"],
    );
  }
}
