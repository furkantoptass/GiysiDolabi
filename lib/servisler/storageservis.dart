import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageServisi {
  Reference _storage = FirebaseStorage.instance.ref();
  String resimid;

  Future<String> gonderResmiYukle(File resimDosyasi) async {
    resimid = Uuid().v4();
    UploadTask yuklemeYoneticisi = _storage
        .child("resimler/gonderiler/gonderi_$resimid.jpg")
        .putFile(resimDosyasi);
    TaskSnapshot snapshot = await yuklemeYoneticisi;
    String yuklenenResimUrl = await snapshot.ref.getDownloadURL();
    return yuklenenResimUrl;
  }

  Future<String> kombinResmiYukle(File kombinDosyasi) async {
    resimid = Uuid().v4();
    UploadTask yuklemeYoneticisi = _storage
        .child("resimler/kombinler/gonderi_$resimid.jpg")
        .putFile(kombinDosyasi);
    TaskSnapshot snapshot = await yuklemeYoneticisi;
    String yuklenenResimUrl = await snapshot.ref.getDownloadURL();
    return yuklenenResimUrl;
  }

  Future<String> profilResmiYukle(File resimDosyasi) async {
    resimid = Uuid().v4();
    UploadTask yuklemeYoneticisi = _storage
        .child("resimler/profil/profil_$resimid.jpg")
        .putFile(resimDosyasi);
    TaskSnapshot snapshot = await yuklemeYoneticisi;
    String yuklenenResimUrl = await snapshot.ref.getDownloadURL();
    return yuklenenResimUrl;
  }

  void gonderiResmiSil(String gonderiResmiUrl) {
    RegExp arama = RegExp(r"gonderi_.+\.jpg");
    var eslesme = arama.firstMatch(gonderiResmiUrl);
    String dosyaAdi = eslesme[0];
    if (dosyaAdi.isEmpty) {
      _storage.child("resimler/gonderiler/$dosyaAdi").delete();
    }
  }
}
