import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/modeller/duyuru.dart';
import 'package:socialapp/modeller/gonderi.dart';
import 'package:socialapp/modeller/kombin.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/servisler/storageservis.dart';

class FireStoreServisi {
  final Firestore _firestore = Firestore.instance;
  int j = 0;
  final zaman = DateTime.now();
  List<String> followers = [];
  List<String> begeniler = [];
  List<String> mesajlar = [];
  List<String> mesajlar2 = [];

  List<String> chatKullanicilari = [];
  Future<void> kullaniciOlustur({id, email, kullaniciAdi, fotoUrl = ""}) async {
    await _firestore.collection("kullanicilar").document(id).setData({
      "kullaniciAdi": kullaniciAdi,
      "email": email,
      "fotoUrl": fotoUrl,
      "hakkinda": "",
      "olusturulmaZamani": zaman
    });
  }

  Future<Kullanici> kullanicilariGetir(id) async {
    DocumentSnapshot doc =
        await _firestore.collection("kullanicilar").document(id).get();
    if (doc.exists) {
      Kullanici kullanici = Kullanici.dokumandanuret(doc);
      return kullanici;
    }
    return null;
  }

  void kullaniciGuncelle(
      {String kullaniciID,
      String kullaniciAdi,
      String fotoUrl = "",
      String hakkinda}) {
    _firestore.collection("kullanicilar").document(kullaniciID).updateData({
      "kullaniciAdi": kullaniciAdi,
      "hakkinda": hakkinda,
      "fotoUrl": fotoUrl
    });
  }

  Future<List<Kullanici>> kullaniciAra(String kelime) async {
    QuerySnapshot snapshot = await _firestore
        .collection("kullanicilar")
        .where("kullaniciAdi", isGreaterThanOrEqualTo: kelime)
        .getDocuments();

    List<Kullanici> kullanicilar =
        snapshot.documents.map((doc) => Kullanici.dokumandanuret(doc)).toList();
    return kullanicilar;
  }

  Future<List<Kullanici>> takipciListesi(String kullaniciId) async {
    QuerySnapshot snapshot;
    QuerySnapshot snapshots = await _firestore
        .collection("takipciler")
        .document(kullaniciId)
        .collection("kullanicininTakipcileri")
        .getDocuments();

    followers = snapshots.documents.map((doc) => doc.documentID).toList();

    //String field = followers[i];
    if (followers.isEmpty) {
      return null;
    }
    snapshot = await _firestore
        .collection("kullanicilar")
        .where(FieldPath.documentId, whereIn: followers)
        .getDocuments();

    List<Kullanici> kullanicilar =
        snapshot.documents.map((doc) => Kullanici.dokumandanuret(doc)).toList();
    //print(kullanicilar);
    return kullanicilar;
  }

  Future<List<Kullanici>> takipedilenListesi(String kullaniciId) async {
    QuerySnapshot snapshot;
    QuerySnapshot snapshots = await _firestore
        .collection("takipedilenler")
        .document(kullaniciId)
        .collection("kullanicininTakipedilenleri")
        .getDocuments();

    followers = snapshots.documents.map((doc) => doc.documentID).toList();

    //String field = followers[i];
    if (followers.isEmpty) {
      return null;
    }
    snapshot = await _firestore
        .collection("kullanicilar")
        .where(FieldPath.documentId, whereIn: followers)
        .getDocuments();

    List<Kullanici> kullanicilar =
        snapshot.documents.map((doc) => Kullanici.dokumandanuret(doc)).toList();
    //print(kullanicilar);
    return kullanicilar;
  }

  Future<List<Kullanici>> begeniListesi(String gonderiId) async {
    QuerySnapshot snapshot;
    QuerySnapshot snapshots = await _firestore
        .collection("begeniler")
        .document(gonderiId)
        .collection("gonderiBegenileri")
        .getDocuments();

    begeniler = snapshots.documents.map((doc) => doc.documentID).toList();

    //String field = followers[i];
    if (begeniler.isEmpty) {
      return null;
    }
    snapshot = await _firestore
        .collection("kullanicilar")
        .where(FieldPath.documentId, whereIn: begeniler)
        .getDocuments();

    List<Kullanici> kullanicilar =
        snapshot.documents.map((doc) => Kullanici.dokumandanuret(doc)).toList();
    //print(kullanicilar);
    return kullanicilar;
  }

  void takipEt({String aktifKullaniciId, String profilSahibiId}) {
    _firestore
        .collection("takipciler")
        .document(profilSahibiId)
        .collection("kullanicininTakipcileri")
        .document(aktifKullaniciId)
        .setData({});
    _firestore
        .collection("takipedilenler")
        .document(aktifKullaniciId)
        .collection("kullanicininTakipedilenleri")
        .document(profilSahibiId)
        .setData({});

    duyuruEkle(
      aktiviteTipi: "takip",
      aktiviteYapanId: aktifKullaniciId,
      profilSahibiId: profilSahibiId,
    );
  }

  void takipdenCik({String aktifKullaniciId, String profilSahibiId}) {
    _firestore
        .collection("takipciler")
        .document(profilSahibiId)
        .collection("kullanicininTakipcileri")
        .document(aktifKullaniciId)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    _firestore
        .collection("takipedilenler")
        .document(aktifKullaniciId)
        .collection("kullanicininTakipedilenleri")
        .document(profilSahibiId)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  Future<bool> takipKontrol(
      {String aktifKullaniciId, String profilSahibiId}) async {
    DocumentSnapshot doc = await _firestore
        .collection("takipedilenler")
        .document(aktifKullaniciId)
        .collection("kullanicininTakipedilenleri")
        .document(profilSahibiId)
        .get();
    if (doc.exists) {
      return true;
    }
    return false;
  }

  Future<int> takipciSayisi(kullaniciID) async {
    QuerySnapshot snapshot = await _firestore
        .collection("takipciler")
        .document(kullaniciID)
        .collection("kullanicininTakipcileri")
        .getDocuments();
    return snapshot.documents.length;
  }

  Future<int> takipEdilenSayisi(kullaniciID) async {
    QuerySnapshot snapshot = await _firestore
        .collection("takipedilenler")
        .document(kullaniciID)
        .collection("kullanicininTakipedilenleri")
        .getDocuments();
    return snapshot.documents.length;
  }

  Future<void> gonderiOlustur(
      {gonderiResmiUrl, aciklama, yayinlayanId, konum}) async {
    await _firestore
        .collection("gonderiler")
        .document(yayinlayanId)
        .collection("kullanicigonderileri")
        .add({
      "gonderiResmiUrl": gonderiResmiUrl,
      "aciklama": aciklama,
      "yayinlayanId": yayinlayanId,
      "begeniSayisi": 0,
      "konum": konum,
      "olusturmaZamani": zaman,
    });
  }

  Future<void> kombinOlustur({
    kombinResmiUrl,
    yayinlayanid,
  }) async {
    await _firestore
        .collection("kombinler")
        .document(yayinlayanid)
        .collection("kullaniciKombinleri")
        .add({
      "kombinResmiUrl": kombinResmiUrl,
      "yayinlayanId": yayinlayanid,
      "olusturmaZamani": zaman,
    });
  }

  Future<List<Gonderi>> gonderileriGetir(kullaniciID) async {
    QuerySnapshot snapshot = await _firestore
        .collection("gonderiler")
        .document(kullaniciID)
        .collection("kullanicigonderileri")
        .orderBy("olusturmaZamani", descending: true)
        .getDocuments();
    List<Gonderi> gonderiler =
        snapshot.documents.map((doc) => Gonderi.dokumandanuret(doc)).toList();
    return gonderiler;
  }

  Future<List<Gonderi>> akisGonderileriniGetir(kullaniciID) async {
    QuerySnapshot snapshot = await _firestore
        .collection("akislar")
        .document(kullaniciID)
        .collection("kullaniciAkisGonderileri")
        .orderBy("olusturmaZamani", descending: true)
        .getDocuments();
    List<Gonderi> gonderiler =
        snapshot.documents.map((doc) => Gonderi.dokumandanuret(doc)).toList();
    return gonderiler;
  }

  Future<List<Kombin>> akisKombinleriniGetir(kullaniciID) async {
    // var addDt = DateTime.now();
    var saatKurali = DateTime.now().subtract(Duration(hours: 24));
    QuerySnapshot snapshot = await _firestore
        .collection("kombinakislari")
        .document(kullaniciID)
        .collection("kullaniciAkisKombinleri")
        .where("olusturmaZamani", isGreaterThanOrEqualTo: saatKurali)
        .orderBy("olusturmaZamani", descending: true)
        .getDocuments();
    List<Kombin> kombinler =
        snapshot.documents.map((doc) => Kombin.dokumandanuret(doc)).toList();
    return kombinler;
  }

  Future<List<Kombin>> kullaniciKombinleriGetir(kullaniciID) async {
    QuerySnapshot snapshot = await _firestore
        .collection("kombinler")
        .document(kullaniciID)
        .collection("kullaniciKombinleri")
        .orderBy("olusturmaZamani", descending: true)
        .getDocuments();
    List<Kombin> kombinler =
        snapshot.documents.map((doc) => Kombin.dokumandanuret(doc)).toList();
    return kombinler;
  }

  /*Future<List<Kombin>> istenilenAkisKombinleriniGetir(
      kullaniciID, istenilenId) async {
    // var addDt = DateTime.now();
    var saatKurali = DateTime.now().subtract(Duration(hours: 24));
    QuerySnapshot snapshot = await _firestore
        .collection("kombinakislari")
        .document(kullaniciID)
        .collection("kullaniciAkisKombinleri")
        .where("yayinlayanId", isEqualTo: istenilenId)
        .where("olusturmaZamani", isGreaterThanOrEqualTo: saatKurali)
        .getDocuments();
    List<Kombin> kombinler =
        snapshot.documents.map((doc) => Kombin.dokumandanuret(doc)).toList();
    return kombinler;
  }*/

  Future<void> gonderiSil({String aktifKullaniciId, Gonderi gonderi}) async {
    _firestore
        .collection("gonderiler")
        .document(aktifKullaniciId)
        .collection("kullanicigonderileri")
        .document(gonderi.id)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    QuerySnapshot yorumlarsnapshot = await _firestore
        .collection("yorumlar")
        .document(gonderi.id)
        .collection("gonderiYorumlari")
        .getDocuments();
    yorumlarsnapshot.documents.forEach((DocumentSnapshot doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    QuerySnapshot duyurularSnapshot = await _firestore
        .collection("duyurular")
        .document(gonderi.yayinlayanId)
        .collection("kullanicininDuyurulari")
        .where("gonderiId", isEqualTo: gonderi.id)
        .getDocuments();
    duyurularSnapshot.documents.forEach((DocumentSnapshot doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //Gönderinin Fotoğrafları FB den silinmesi
    StorageServisi().gonderiResmiSil(gonderi.gonderiResmiUrl);
  }

  Future<void> gonderiBegen(Gonderi gonderi, String aktifKullaniciID) async {
    DocumentReference docRef = _firestore
        .collection("gonderiler")
        .document(gonderi.yayinlayanId)
        .collection("kullanicigonderileri")
        .document(gonderi.id);
    DocumentSnapshot doc = await docRef.get();
    if (doc.exists) {
      Gonderi gonderi = Gonderi.dokumandanuret(doc);
      int yeniBegeniSayisi = gonderi.begeniSayisi + 1;
      docRef.updateData({
        "begeniSayisi": yeniBegeniSayisi,
      });
      _firestore
          .collection("begeniler")
          .document(gonderi.id)
          .collection("gonderiBegenileri")
          .document(aktifKullaniciID)
          .setData({});
    }
    //beğen notificationu
    duyuruEkle(
      aktiviteTipi: "beğeni",
      aktiviteYapanId: aktifKullaniciID,
      gonderi: gonderi,
      profilSahibiId: gonderi.yayinlayanId,
    );
  }

  Future<void> gonderiBegenKaldir(
      Gonderi gonderi, String aktifKullaniciID) async {
    DocumentReference docRef = _firestore
        .collection("gonderiler")
        .document(gonderi.yayinlayanId)
        .collection("kullanicigonderileri")
        .document(gonderi.id);
    DocumentSnapshot doc = await docRef.get();
    if (doc.exists) {
      Gonderi gonderi = Gonderi.dokumandanuret(doc);
      int yeniBegeniSayisi = gonderi.begeniSayisi - 1;
      docRef.updateData({
        "begeniSayisi": yeniBegeniSayisi,
      });
      DocumentSnapshot docBegeni = await _firestore
          .collection("begeniler")
          .document(gonderi.id)
          .collection("gonderiBegenileri")
          .document(aktifKullaniciID)
          .get();
      if (docBegeni.exists) {
        docBegeni.reference.delete();
      }
    }
  }

  Future<bool> begeniVarmi(Gonderi gonderi, String aktifKullaniciID) async {
    DocumentSnapshot docBegeni = await _firestore
        .collection("begeniler")
        .document(gonderi.id)
        .collection("gonderiBegenileri")
        .document(aktifKullaniciID)
        .get();
    if (docBegeni.exists) {
      return true;
    }
    return false;
  }

  Stream<QuerySnapshot> yorumlariGetir(String gonderiId) {
    return _firestore
        .collection("yorumlar")
        .document(gonderiId)
        .collection("gonderiYorumlari")
        .orderBy("olusturmaZamani", descending: true)
        .snapshots();
  }

  void yorumEkle({String aktifKullaniciId, Gonderi gonderi, String icerik}) {
    _firestore
        .collection("yorumlar")
        .document(gonderi.id)
        .collection("gonderiYorumlari")
        .add({
      "icerik": icerik,
      "yayinlayanID": aktifKullaniciId,
      "olusturmaZamani": zaman,
    });

    duyuruEkle(
      aktiviteTipi: "yorum",
      aktiviteYapanId: aktifKullaniciId,
      gonderi: gonderi,
      profilSahibiId: gonderi.yayinlayanId,
      yorum: icerik,
    );
  }

  void duyuruEkle(
      {String aktiviteYapanId,
      String profilSahibiId,
      String aktiviteTipi,
      String yorum,
      Gonderi gonderi}) {
    if (aktiviteYapanId == profilSahibiId) {
      return;
    }
    _firestore
        .collection("duyurular")
        .document(profilSahibiId)
        .collection("kullanicininDuyurulari")
        .add({
      "aktiviteYapanId": aktiviteYapanId,
      "aktiviteTipi": aktiviteTipi,
      "gonderiId": gonderi?.id,
      "gonderiFoto": gonderi?.gonderiResmiUrl,
      "yorum": yorum,
      "olusturmaZamani": zaman,
    });
  }

  Future<List<Duyuru>> duyurulariGetir(String profilSahibiId) async {
    QuerySnapshot snapshot = await _firestore
        .collection("duyurular")
        .document(profilSahibiId)
        .collection("kullanicininDuyurulari")
        .orderBy("olusturmaZamani", descending: true)
        .limit(20)
        .getDocuments();

    List<Duyuru> duyurular = [];
    snapshot.documents.forEach((DocumentSnapshot doc) {
      Duyuru duyuru = Duyuru.dokumandanuret(doc);
      duyurular.add(duyuru);
    });
    return duyurular;
  }

  Future<Gonderi> tekliGonderiGetir(
      String gonderiId, String gonderiSahibiId) async {
    DocumentSnapshot doc = await _firestore
        .collection("gonderiler")
        .document(gonderiSahibiId)
        .collection("kullanicigonderileri")
        .document(gonderiId)
        .get();
    Gonderi gonderi = Gonderi.dokumandanuret(doc);
    return gonderi;
  }

  void mesajEkle(
      {String aktifKullaniciId,
      String alanId,
      String icerik,
      String chatRoomId,
      users}) {
    chatKullanicilari = [aktifKullaniciId, alanId];
    _firestore
        .collection("chatRooms")
        .document(chatRoomId)
        .collection("chats")
        .add({
      "gonderenId": aktifKullaniciId,
      "icerik": icerik,
      "olusturmaZamani": zaman,
    });

    /*_firestore.collection("chatRooms").document(chatRoomId).setData(users);*/
  }

  chatOdasiOlustur(users, chatRoomId) {
    Firestore.instance
        .collection("chatRooms")
        .document(chatRoomId)
        .setData(users)
        .catchError((e) {
      print(e);
    });
  }

  Stream<QuerySnapshot> mesajGoster(
      {String alanId, String aktifKullaniciId, String chatRoomId}) {
    Stream<QuerySnapshot> q1 = _firestore
        .collection("chatRooms")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("olusturmaZamani", descending: false)
        .snapshots();

    return q1;
  }

  /*getUserChats(String itIsMyName) async {
    return await Firestore.instance
        .collection("chatRooms")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }*/

  Future<List<Kullanici>> getUserChats2(String kid) async {
    QuerySnapshot snapshot;
    QuerySnapshot snapshots = await _firestore
        .collection("chatRooms")
        .where('users', arrayContains: kid)
        .getDocuments();

    mesajlar = snapshots.documents
        .map((doc) => doc.data["users"][0].toString())
        .toList();
    mesajlar2 = snapshots.documents
        .map((doc) => doc.data["users"][1].toString())
        .toList();

    for (var i = 0; i < mesajlar.length; i++) {
      if (mesajlar[i] == kid) {
        mesajlar[i] = mesajlar2[i];
      }
    }

    /*if (mesajlar[0] == kid) {
      mesajlar = snapshots.documents
          .map((doc) => doc.data["users"][1].toString())
          .toList();
    }
    if (mesajlar[1] == kid) {
      mesajlar = snapshots.documents
          .map((doc) => doc.data["users"][0].toString())
          .toList();
    }*/
    //String field = followers[i];
    if (mesajlar.isEmpty) {
      return null;
    }
    snapshot = await _firestore
        .collection("kullanicilar")
        .where(FieldPath.documentId, whereIn: mesajlar)
        .getDocuments();

    List<Kullanici> kullanicilar =
        snapshot.documents.map((doc) => Kullanici.dokumandanuret(doc)).toList();
    //print(kullanicilar);
    return kullanicilar;
  }

  /*Future<List<Kullanici>> kullaniciChatGetir(userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection("kullanicilar")
        .where(FieldPath.documentId, isEqualTo: userId)
        .getDocuments();

    List<Kullanici> kullanicilar =
        snapshot.documents.map((doc) => Kullanici.dokumandanuret(doc)).toList();
    return kullanicilar;
  }*/
}
