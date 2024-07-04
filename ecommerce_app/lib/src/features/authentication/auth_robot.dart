///https://verygood.ventures/blog/robot-testing-in-flutter
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../common_widgets/alert_dialogs.dart';
import 'domain/app_user.dart';
import 'presentation/account/account_screen.dart';

class AuthRobot {
  AuthRobot(this.tester);
  final WidgetTester tester;

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

  Future<void> tapLogoutDialog() async {
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

  void expectLogoutError() {
    final dialogTitle = find.text('Error');
    expect(dialogTitle, findsOneWidget);
  }

  void expectLogoutErrorDialogNotFound() {
    final dialogTitle = find.text('Error');
    expect(dialogTitle, findsNothing);
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

  void studSignOutException(FakeAuthRepository auth) {
    final exception = Exception("Connection error");
    when(() => auth.signOut()).thenThrow(exception);
  }
}
