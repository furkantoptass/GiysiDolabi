import 'package:flutter_test/flutter_test.dart';
import 'package:socialapp/sayfalar/girissayfasi.dart';

void main() {
  test('girisUnitTest', () {
    //setup
    //run
    //verify
  });

  test('Email boş bırakılmış', () {
    var result = EmailFieldValidator.validate('');
    expect(result, 'Email alanı boş bırakılmaz');
  });

  test('Email formatında değil', () {
    var result = EmailFieldValidator.validate('email');
    expect(result, 'Girilen değer mail değil');
  });
  test('Başarılı Email', () {
    var result = EmailFieldValidator.validate('email@');
    expect(result, null);
  });

  test('Şifre boş bırakılmış', () {
    var result = PasswordFieldValidator.validate('');
    expect(result, 'Şifre alanı boş bırakılmaz');
  });

  test('Başarılı Şifre', () {
    var result = PasswordFieldValidator.validate('password');
    expect(result, null);
  });
}
