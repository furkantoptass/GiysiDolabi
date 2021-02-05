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

  factory Kullanici.firebasedenuret(User kullanici) {
    return Kullanici(
      id: kullanici.uid,
      kullaniciAdi: kullanici.displayName,
      fotourl: kullanici.photoURL,
      email: kullanici.email,
    );
  }

  factory Kullanici.dokumandanuret(DocumentSnapshot doc) {
    return Kullanici(
      id: doc.id,
      kullaniciAdi: doc.data()['kullaniciAdi'],
      email: doc.data()['email'],
      fotourl: doc.data()['fotoUrl'],
      hakkinda: doc.data()['hakkinda'],
    );
  }
}
