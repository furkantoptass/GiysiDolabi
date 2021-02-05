import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialapp/modeller/kullanici.dart';

class YetkilendirmeServisi {
  final FirebaseAuth auth;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String aktifkullaniciid;

  YetkilendirmeServisi({this.auth});

  Stream<User> get user => auth.authStateChanges();

  Kullanici _kullaniciOlustur(User kullanici) {
    return kullanici == null ? null : Kullanici.firebasedenuret(kullanici);
  }

  Stream<Kullanici> get durumTakipcisi {
    return _firebaseAuth.authStateChanges().map(_kullaniciOlustur);
  }

  Future<Kullanici> mailileKayit(String eposta, String sifre) async {
    var girisKarti = await _firebaseAuth.createUserWithEmailAndPassword(
        email: eposta.trim(), password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<Kullanici> mailileGiris(String eposta, String sifre) async {
    var girisKarti = await _firebaseAuth.signInWithEmailAndPassword(
        email: eposta, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<void> cikisYap() {
    return _firebaseAuth.signOut();
  }

  Future<Kullanici> googleIleGiris() async {
    GoogleSignInAccount googleHesabi = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleYetkiKartim =
        await googleHesabi.authentication;
    AuthCredential sifresizGiris = GoogleAuthProvider.credential(
        idToken: googleYetkiKartim.idToken,
        accessToken: googleYetkiKartim.accessToken);
    UserCredential girisKarti =
        await _firebaseAuth.signInWithCredential(sifresizGiris);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<void> sifreSifirla(String eposta) async {
    await _firebaseAuth.sendPasswordResetEmail(email: eposta);
  }
}
