///https://verygood.ventures/blog/robot-testing-in-flutter
import 'dart:math';

import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';

import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';

class AuthRobot {
  AuthRobot(this.tester);
  final WidgetTester tester;

  Future<void> openEmailPasswordSignInScreen() async {
    final finder = find.byKey(MoreMenuButton.signInKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> pumpEmailPasswordSignInContents(
      {required auth,
      required EmailPasswordSignInFormType formType,
      VoidCallback? onSignedIn}) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: EmailPasswordSignInContents(
            formType: formType,
            onSignedIn: onSignedIn,
          ),
        ),
      ),
    ));
  }

  Future<void> tapEmailAndPasswordSubmitButton() async {
    final primaryBtn = find.byType(PrimaryButton);
    expect(primaryBtn, findsOneWidget);
    await tester.tap(primaryBtn);
    await tester.pumpAndSettle();
  }

  Future<void> enterEmail(String email) async {
    final emailField = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);
  }

  Future<void> enterPassword(String password) async {
    final emailField = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, password);
  }

  Future<void> signInWithEmailAndPassword() async {
    await enterEmail('test@test.com');
    await enterPassword('1234');
    await tapEmailAndPasswordSubmitButton();
  }

  Future<void> openAccountScreen() async {
    final finder = find.byKey(MoreMenuButton.accountKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> pumpAccountScreen({FakeAuthRepository? authRepository}) async {
    await tester.pumpWidget(
      ProviderScope(
          overrides: [
            if (authRepository != null)
              authRepositoryProvider.overrideWithValue(authRepository)
          ],
          child: const MaterialApp(
            home: AccountScreen(),
          )),
    );
  }

  Future<void> tapLogoutButton() async {
    final logoutButton = find.byKey(defaultAccountLogoutKey);
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    //execute ui
    await tester.pump();
  }

  void expectLogoutDialogFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsOneWidget);
  }

  Future<void> tapCancelDialog() async {
    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);

    await tester.tap(cancelButton);
    //execute ui
    await tester.pump();
  }

  Future<void> tapLogoutDialogButton() async {
    final logoutButton = find.byKey(defaultDialogKey);
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    //execute ui
    await tester.pump();
  }

  void expectLogoutDialogNotFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsNothing);
  }

  void expectErrorAlert() {
    final dialogTitle = find.text('Error');
    expect(dialogTitle, findsOneWidget);
  }

  void expectErrorAlertNotFound() {
    final dialogTitle = find.text('Error');
    expect(dialogTitle, findsNothing);
  }

  void expectCirculatorIndicator() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }

  void studStreamAppUser(FakeAuthRepository auth) {
    when(
      () => auth.authStateChanges(),
    ).thenAnswer(
      (_) => Stream.value(
        const AppUser(uid: "123", email: "test@test.com"),
      ),
    );
  }

  void studSignOut(FakeAuthRepository auth) {
    when(auth.signOut).thenAnswer(Future.value);
  }

  void studSignOutDelay(FakeAuthRepository auth) {
    when(auth.signOut).thenAnswer(
      (_) => Future.delayed(
        const Duration(seconds: 1),
      ),
    );
  }

  void studSignOutException(FakeAuthRepository auth) {
    final exception = Exception("Connection error");
    when(() => auth.signOut()).thenThrow(exception);
  }
}
