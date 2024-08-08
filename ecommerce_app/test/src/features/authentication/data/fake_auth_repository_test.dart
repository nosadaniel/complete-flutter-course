import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';

import 'package:ecommerce_app/src/features/authentication/domain/fake_app_user.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const testEmail = "test@test.com";
  const testPassword = "test1234";
  final testUser = FakeAppUser(
      uid: testEmail.split('').reversed.join(),
      email: testEmail,
      password: testPassword);

  FakeAuthRepository makeAuthRepo() => FakeAuthRepository(addDelay: false);

  group('fake auth repository ...', () {
    test('currentUser is null', () {
      final authRepo = makeAuthRepo();
      //register this upfront - will be called even if the test throw an exception later
      addTearDown(authRepo.dispose);
      expect(authRepo.authStateChanges(), emits(null));
      expect(authRepo.currentUser, null);
    });

    test('sign in throws when user not found ', () async {
      //setup
      final authRepo = makeAuthRepo();
//register this upfront - will be called even if the test throw an exception later
      addTearDown(authRepo.dispose);
      //run
      await expectLater(
          () => authRepo.signInWithEmailAndPassword(testEmail, testPassword),
          throwsA(isA<Exception>()));

      //test
      expect(authRepo.currentUser, null);
      expect(authRepo.authStateChanges(), emits(null));
    });
    test('authStateChanges is not null after registering ', () async {
      //setup
      final authRepo = makeAuthRepo();
//register this upfront - will be called even if the test throw an exception later
      addTearDown(authRepo.dispose);
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
      //register this upfront - will be called even if the test throw an exception later
      addTearDown(authRepo.dispose);
      //signIn
      await authRepo.createUserWithEmailAndPassword(testEmail, testPassword);
      expect(authRepo.currentUser, testUser);
      expect(authRepo.authStateChanges(), emits(testUser));

      //signout
      await authRepo.signOut();

      //test
      expect(authRepo.currentUser, null);
      expect(authRepo.authStateChanges(), emits(null));
    });
  });
}
