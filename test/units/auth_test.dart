import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';

typedef Callback(MethodCall call);

setupCloudFirestoreMocks([Callback customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': {},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    if (customHandlers != null) {
      customHandlers(call);
    }

    return null;
  });
}

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]);
  }
}

main() async {
  setupCloudFirestoreMocks();
  await Firebase.initializeApp();

  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final YetkilendirmeServisi auth =
      YetkilendirmeServisi(auth: mockFirebaseAuth);
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });
  tearDown(() {});
  //if (MockUser() == MockUser()) //return false always

  test("emit occurs", () async {
    expect(auth.user, emitsInOrder({_mockUser}));
  });
  test("create account", () async {
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "tadas@gmail.com", password: "123456"))
        .thenAnswer((realInvocation) => null);
    expect(await auth.mailileKayit("tadas@gmail.com", "123456"), "Succes");
  });
}
