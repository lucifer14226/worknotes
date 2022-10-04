import 'dart:math';

import 'package:test/test.dart';
import 'package:worknotes/services/auth/auth_exception.dart';
import 'package:worknotes/services/auth/auth_provider.dart';
import 'package:worknotes/services/auth/auth_user.dart';

void main() {
  group("MockAuthentication", () {
    final provider = MockAuthProvider();
    test("Should not be initialize to begin with", () {
      expect(provider.isInitialized, false);
    });
    test("Cannot logout if not initialized", () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitiaLizedException>()));
    });
    test("Should be able to initialized", () async {
      await provider.initalize();
      expect(provider.isInitialized, true);
    });
    test("User Should be null after initialization", () {
      expect(provider.currentUser, null);
    });
    test(
      "Should be able to initialize in less than 2 second",
      () async {
        await provider.initalize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test("Create user Should delegate to login Function", () async {
      final badEmailUser = provider.createUser(
        email: "foo@bar.com",
        password: "anypassword",
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPassword = provider.createUser(
        email: "Any@bar.com",
        password: "foobar",
      );
      expect(badPassword,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));
      final user = await provider.createUser(
        email: "foo",
        password: "bar",
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('Login Function Should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to login and logout  again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'user',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitiaLizedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitiaLizedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initalize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitiaLizedException();
    if (email == "foo@bar.com") throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitiaLizedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitiaLizedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
