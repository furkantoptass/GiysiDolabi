import 'package:cloud_firestore/cloud_firestore.dart';

class Gonderi {
  final String id;
  final String gonderiResmiUrl;
  final String aciklama;
  final String yayinlayanId;
  final int begeniSayisi;
  final String konum;

  Gonderi(
      {this.id,
      this.gonderiResmiUrl,
      this.aciklama,
      this.yayinlayanId,
      this.begeniSayisi,
      this.konum});

  factory Gonderi.dokumandanuret(DocumentSnapshot doc) {
    return Gonderi(
      id: doc.id,
      gonderiResmiUrl: doc.data()["gonderiResmiUrl"],
      aciklama: doc.data()["aciklama"],
      yayinlayanId: doc.data()["yayinlayanId"],
      begeniSayisi: doc.data()["begeniSayisi"],
      konum: doc.data()["konum"],
    );
  }
}
