import 'package:ecommerce_app/src/features/authentication/auth_robot.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mock_fake_auth_repository.dart';

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

    await robot.pumpAccountScreen(authRepository: auth);
    //tap on logout button
    await robot.tapLogoutButton();
    //expect to show logout dialog
    robot.expectLogoutDialogFound();
    //tap on logout button dialog
    await robot.tapLogoutDialog();
    //expect to show error dialog
    robot.expectLogoutErrorDialogNotFound();
  });
  testWidgets('Confirm logout, failure', (tester) async {
    final auth = MockFakeAuthRepository();
    final exception = Exception('Connection Error');
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
    await robot.tapLogoutDialog();
    //expect to show error dialog
    robot.expectLogoutError();
  });
}
