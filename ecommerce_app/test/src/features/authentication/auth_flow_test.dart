import 'package:flutter_test/flutter_test.dart';

import '../../robot.dart';

void main() {
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Register and sign out flow', (tester) async {
    // * Note: All tests are wrapped with `runAsync` to prevent this error:
    // * A Timer is still pending even after the widget tree was disposed.

    final r = Robot(tester);
    await r.pumpMyApp();
    r.products.expectFindAllProductCards();
    await r.openPopupMenu();
    await r.auth.openEmailPasswordSignInScreen();
    await r.auth.toggleToRegisterAccount();
    await r.auth.signInWithEmailAndPassword();
    r.products.expectFindAllProductCards();
    await r.openPopupMenu();
    await r.auth.openAccountScreen();
    await r.auth.tapLogoutButton();
    await r.auth.tapLogoutDialogButton();
    r.products.expectFindAllProductCards();
  });
}
