import '../../auth_robot.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  testWidgets('Cancel logout', (tester) async {
    final robot = AuthRobot(tester);
    //pump account screen
    await robot.pumpAccountScreen();
    //press the logout button
    await robot.tapLogoutButton();

    ///expect to show the logout dialog
    robot.expectLogoutDialogFound();
    //press the cancel button
    await robot.tapCancelDialog();
    //expect not to see logout dialog
    robot.expectLogoutDialogNotFound();
  });
  testWidgets('Confirm logout, success', (tester) async {
    final robot = AuthRobot(tester);
    final auth = MockFakeAuthRepository();
    //stud, in order return  fake user data
    robot.studStreamAppUser(auth);
    robot.studSignOut(auth);
    await robot.pumpAccountScreen(authRepository: auth);
    //tap on logout button
    await robot.tapLogoutButton();
    //expect to show logout dialog
    robot.expectLogoutDialogFound();
    //tap on logout button dialog
    await robot.tapLogoutDialogButton();
    //expect to show error dialog
    robot.expectErrorAlertNotFound();
  });
  testWidgets('Confirm logout, failure', (tester) async {
    final auth = MockFakeAuthRepository();
    final robot = AuthRobot(tester);

    //stud, in order return  fake user data
    robot.studStreamAppUser(auth);
    // stud, to throw exception on logoutButton pressed in logoutDialog
    robot.studSignOutException(auth);

    // pump account screen
    await robot.pumpAccountScreen(authRepository: auth);
    //tap on logout button
    await robot.tapLogoutButton();
    //expect to show logout dialog
    robot.expectLogoutDialogFound();
    //tap on logout button dialog
    await robot.tapLogoutDialogButton();
    //expect to show error dialog
    robot.expectErrorAlert();
  });

  testWidgets('Confirm logout, loading state', (tester) async {
    final auth = MockFakeAuthRepository();
    final robot = AuthRobot(tester);

    //stud, in order return  fake user data
    robot.studStreamAppUser(auth);
    // stud, to cause a delay before signing out
    robot.studSignOutDelay(auth);

    await tester.runAsync(() async {
      // pump account screen
      await robot.pumpAccountScreen(authRepository: auth);
      //tap on logout button
      await robot.tapLogoutButton();
      //expect to show logout dialog
      robot.expectLogoutDialogFound();
      //tap on logout button dialog
      await robot.tapLogoutDialogButton();
    });

    //expect to show circular progress indicator
    robot.expectCirculatorIndicator();
    verify(
      () => auth.signOut(),
    ).called(1);
  });
}
