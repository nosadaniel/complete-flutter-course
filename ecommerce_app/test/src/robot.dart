import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'features/authentication/auth_robot.dart';

class Robot {
  Robot(this.tester) : auth = AuthRobot(tester);
  final WidgetTester tester;

  final AuthRobot auth;
  Future<void> pumpMyApp() async {
    GoRouter.optionURLReflectsImperativeAPIs = true;

    /// create new repos with addDelay: false
    final authRepo = FakeAuthRepository(addDelay: false);
    final productsRepo = FakeProductsRepository(addDelay: false);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // use them via provider overrides:
          authRepositoryProvider.overrideWithValue(authRepo),
          productsRepositoryProvider.overrideWithValue(productsRepo),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  void expectFindAllProductCards() {
    final finder = find.byType(ProductCard);
    expect(finder, findsNWidgets(kTestProducts.length));
  }

  Future<void> openPopupMenu() async {
    final finder = find.byType(MoreMenuButton);
    final matches = finder.evaluate();
    if (matches.isNotEmpty) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }
}
