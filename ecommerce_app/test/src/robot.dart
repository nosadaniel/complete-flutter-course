import 'package:ecommerce_app/src/app.dart';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/fake_local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/fake_remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:ecommerce_app/src/features/reviews/data/fake_reviews_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'features/authentication/auth_robot.dart';
import 'features/cart/cart_robot.dart';
import 'features/checkout/checkout_robot.dart';
import 'features/orders/orders_robot.dart';
import 'features/products/products_robot.dart';
import 'features/reviews/reviews_robot.dart';
import 'goldens/golden_robot.dart';

class Robot {
  Robot(this.tester)
      : auth = AuthRobot(tester),
        products = ProductsRobot(tester),
        cart = CartRobot(tester),
        orders = OrdersRobot(tester),
        checkout = CheckoutRobot(
          tester,
        ),
        reviews = ReviewsRobot(tester),
        goldenRobot = GoldenRobot(tester);
  final WidgetTester tester;

  final AuthRobot auth;
  final ProductsRobot products;
  final CartRobot cart;
  final CheckoutRobot checkout;
  final OrdersRobot orders;
  final ReviewsRobot reviews;
  final GoldenRobot goldenRobot;

  Future<void> pumpMyApp() async {
    GoRouter.optionURLReflectsImperativeAPIs = true;

    /// create new repos with addDelay: false
    final authRepo = FakeAuthRepository(addDelay: false);
    final productsRepo = FakeProductsRepository(addDelay: false);
    final localCartRepository = FakeLocalCartRepository(addDelay: false);
    final remoteCartRepository = FakeRemoteCartRepository(addDelay: false);
    final reviewRespository = FakeReviewsRepository(addDelay: false);
    final orderRespository = FakeOrdersRepository(addDelay: false);

    // * Create ProviderContainer with any required overrides
    final container = ProviderContainer(
      overrides: [
        productsRepositoryProvider.overrideWithValue(productsRepo),
        authRepositoryProvider.overrideWithValue(authRepo),
        localCartRepositoryProvider.overrideWithValue(localCartRepository),
        remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
        reviewsRepositoryProvider.overrideWithValue(reviewRespository),
        ordersRepostoryProvider.overrideWithValue(orderRespository)
      ],
    );
    container.read(cartSyncServiceProvider);
    //* Entry point of the app

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openPopupMenu() async {
    final finder = find.byType(MoreMenuButton);
    final matches = finder.evaluate();
    if (matches.isNotEmpty) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
    // else no-op, as the items are already visible
  }

  //navigation
  Future<void> closePage() async {
    final finder = find.byTooltip('Close');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> goBack() async {
    final finder = find.byTooltip('Back');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }
}
