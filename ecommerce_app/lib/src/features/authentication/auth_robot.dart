import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'presentation/account/account_screen.dart';

class AuthRobot {
  AuthRobot(this.tester);
  final WidgetTester tester;

  Future<void> pumpAccountScreen() async {
    await tester.pumpWidget(
      const ProviderScope(
          child: MaterialApp(
        home: AccountScreen(),
      )),
    );
  }

  Future<void> tapLogoutButton() async {
    final logoutButton = find.text("Logout");
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    //execute ui
    await tester.pump();
  }

  void expectLogoutDialogFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsOneWidget);
  }

  void _expectCancelButton() {
    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);
  }

  Future<void> tapCancelDialog() async {
    _expectCancelButton();
    final cancelButton = find.text('Cancel');
    await tester.tap(cancelButton);
    //execute ui
    await tester.pump();
  }

  void expectLogoutDialogNotFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsNothing);
  }
}
