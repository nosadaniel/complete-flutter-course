import 'dart:math';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testEmail = "test@test.com";
  const testPassword = "1234";
  final testUser =
      AppUser(uid: testEmail.split('').reversed.join(), email: testEmail);

  FakeAuthRepository makeAuthRepo() => FakeAuthRepository(addDelay: false);

  group('fake auth repository ...', () {
    test('currentUser is null', () {
      final authRepo = makeAuthRepo();
      expect(authRepo.authStateChanges(), emits(null));
    });

    test('authStateChanges is not null after signIn ', () async {
      //setup
      final authRepo = makeAuthRepo();

      //run
      await authRepo.signInWithEmailAndPassword(
        testEmail,
        testPassword,
      );

      //test
      expect(authRepo.currentUser, testUser);
    });
    test('authStateChanges is not null after registering ', () async {
      //setup
      final authRepo = makeAuthRepo();

      //run
      await authRepo.createUserWithEmailAndPassword(testEmail, testPassword);

      //test
      expect(authRepo.authStateChanges(), emits(testUser));
    });

    test('currentUser is not null after registering ', () async {
      //setup
      final authRepo = makeAuthRepo();

      //run
      await authRepo.createUserWithEmailAndPassword(testEmail, testPassword);

      //test
      expect(authRepo.currentUser, testUser);
    });

    test('currentUser is null after sign out ', () async {
      final authRepo = makeAuthRepo();
      //signIn
      await authRepo.signInWithEmailAndPassword(testEmail, testPassword);
      //test
      expect(authRepo.currentUser, testUser);
      expect(authRepo.authStateChanges(), emits(testUser));

      //signout
      authRepo.signOut();
      //test
      expect(authRepo.currentUser, null);
      expect(authRepo.authStateChanges(), emits(null));
    });
  });
}
