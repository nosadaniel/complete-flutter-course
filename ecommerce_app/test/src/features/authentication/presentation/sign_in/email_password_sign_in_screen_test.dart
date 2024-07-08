import 'package:ecommerce_app/src/features/authentication/auth_robot.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mock_fake_auth_repository.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  late MockFakeAuthRepository auth;

  setUp(() {
    auth = MockFakeAuthRepository();
  });
  group('sign in', () {
    testWidgets('''
      Given formType is signIn
      When tap on the sign-in button
      Then signInWithEmailAndPassword is not called
''', (tester) async {
      final r = AuthRobot(tester);
      await r.pumpEmailPasswordSignInContents(
          auth: auth, formType: EmailPasswordSignInFormType.signIn);
      await r.tapEmailAndPasswordSubmitButton();
      verifyNever(
        () => auth.signInWithEmailAndPassword(
          any(),
          any(),
        ),
      );
    });
    testWidgets('callback test', (tester) async {
      //flag to keep track if the callback was called
      var didSignIn = false;
      final r = AuthRobot(tester);
      //stud
      when(() => auth.signInWithEmailAndPassword(testEmail, testPassword))
          .thenAnswer(Future.value);
      await r.pumpEmailPasswordSignInContents(
          auth: auth,
          formType: EmailPasswordSignInFormType.signIn,
          onSignedIn: () => didSignIn = true);
      await r.enterEmail(testEmail);
      await r.enterPassword(testPassword);
      await r.tapEmailAndPasswordSubmitButton();
      verify(
        () => auth.signInWithEmailAndPassword(testEmail, testPassword),
      ).called(1);
      r.expectErrorAlertNotFound();
      expect(didSignIn, true);
    });
  });
}
