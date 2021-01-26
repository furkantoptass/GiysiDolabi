import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Kullanici {
  final String id;
  final String kullaniciAdi;
  final String fotourl;
  final String email;
  final String hakkinda;

  Kullanici(
      {@required this.id,
      this.kullaniciAdi,
      this.fotourl,
      this.email,
      this.hakkinda});

  factory Kullanici.firebasedenuret(FirebaseUser kullanici) {
    return Kullanici(
      id: kullanici.uid,
      kullaniciAdi: kullanici.displayName,
      fotourl: kullanici.photoUrl,
      email: kullanici.email,
    );
  }

  factory Kullanici.dokumandanuret(DocumentSnapshot doc) {
    return Kullanici(
      id: doc.documentID,
      kullaniciAdi: doc['kullaniciAdi'],
      email: doc['email'],
      fotourl: doc['fotoUrl'],
      hakkinda: doc["hakkinda"],
    );
  }
}
