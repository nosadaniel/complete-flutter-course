import 'package:ecommerce_app/src/features/authentication/auth_robot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Cancel logout', (tester) async {
    final robot = AuthRobot(tester);
    await robot.pumpAccountScreen();
    await robot.tapLogoutButton();
    robot.expectLogoutDialogFound();
    await robot.tapCancelDialog();
    robot.expectLogoutDialogNotFound();
  });
}
