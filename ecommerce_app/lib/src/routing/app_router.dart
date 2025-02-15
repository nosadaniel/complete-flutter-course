import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_form_type.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/checkout_screen/checkout_screen.dart';
import 'package:ecommerce_app/src/features/products/presentation/product_screen/product_screen.dart';
import 'package:ecommerce_app/src/routing/not_found_screen.dart';
import 'package:ecommerce_app/src/utils/go_router_refreshStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/authentication/presentation/account/account_screen.dart';
import '../features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';

import '../features/cart/presentation/shopping_cart/shopping_cart_screen.dart';
import '../features/orders/presentation/orders_list/orders_list_screen.dart';
import '../features/products/presentation/products_list/products_list_screen.dart';
import '../features/reviews/presentation/leave_review_page/leave_review_screen.dart';

enum AppRouter {
  home,
  sigIn,
  cart,
  orders,
  account,
  product,
  leaveReview,
  checkout,
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (_, state) {
      final isLoggedIn = auth.currentUser != null;
      if (isLoggedIn) {
        if (state.uri.path == '/${AppRouter.sigIn.name}') {
          return '/';
        }
      } else {
        if (state.uri.path == '/${AppRouter.account.name}' ||
            state.uri.path == '/${AppRouter.orders.name}') {
          return '/';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(auth.authStateChanges()),
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(
        path: '/',
        name: AppRouter.home.name,
        builder: (context, state) => const ProductsListScreen(),
        routes: [
          GoRoute(
              path: 'product/:id',
              name: AppRouter.product.name,
              pageBuilder: (context, state) {
                final productId = state.pathParameters["id"]!;
                return MaterialPage(
                  child: ProductScreen(productId: productId),
                  fullscreenDialog: true,
                );
              },
              routes: [
                GoRoute(
                  path: 'review',
                  name: AppRouter.leaveReview.name,
                  pageBuilder: (context, state) {
                    final productId = state.pathParameters["id"]!;
                    return MaterialPage(
                      child: LeaveReviewScreen(productId: productId),
                      fullscreenDialog: true,
                    );
                  },
                ),
              ]),
          GoRoute(
            path: 'cart',
            name: AppRouter.cart.name,
            pageBuilder: (context, state) => const MaterialPage(
              child: ShoppingCartScreen(),
              fullscreenDialog: true,
            ),
            routes: [
              GoRoute(
                path: 'checkout',
                name: AppRouter.checkout.name,
                pageBuilder: (context, state) {
                  return const MaterialPage(
                    child: CheckoutScreen(),
                    fullscreenDialog: true,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'orders',
            name: AppRouter.orders.name,
            pageBuilder: (context, state) => MaterialPage(
                child: const OrdersListScreen(),
                fullscreenDialog: true,
                key: state.pageKey),
          ),
          GoRoute(
            path: 'account',
            name: AppRouter.account.name,
            pageBuilder: (context, state) => const MaterialPage(
                child: AccountScreen(), fullscreenDialog: true),
          ),
          GoRoute(
            path: 'signIn',
            name: AppRouter.sigIn.name,
            pageBuilder: (context, state) => const MaterialPage(
                child: EmailPasswordSignInScreen(
                    formType: EmailPasswordSignInFormType.signIn),
                fullscreenDialog: true),
          ),
        ],
      ),
    ],
  );
});
