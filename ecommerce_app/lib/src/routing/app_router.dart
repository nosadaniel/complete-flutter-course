import 'package:ecommerce_app/src/features/account/account_screen.dart';
import 'package:ecommerce_app/src/features/checkout/checkout_screen.dart';
import 'package:ecommerce_app/src/features/leave_review_page/leave_review_screen.dart';
import 'package:ecommerce_app/src/features/not_found/not_found_screen.dart';
import 'package:ecommerce_app/src/features/orders_list/orders_list_screen.dart';
import 'package:ecommerce_app/src/features/product_page/product_screen.dart';
import 'package:ecommerce_app/src/features/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/sign_in/email_password_sign_in_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/products_list/products_list_screen.dart';
import '../features/shopping_cart/shopping_cart_screen.dart';

enum NamedRouter {
  home,
  sigIn,
  cart,
  orders,
  account,
  product,
  leaveReview,
  checkout,
}

class AppRouter {
  static final goRouter = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: NamedRouter.home.name,
        builder: (context, state) => const ProductsListScreen(),
        routes: [
          GoRoute(
              path: 'product/:id',
              name: NamedRouter.product.name,
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
                  name: NamedRouter.leaveReview.name,
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
            name: NamedRouter.cart.name,
            pageBuilder: (context, state) => const MaterialPage(
              child: ShoppingCartScreen(),
              fullscreenDialog: true,
            ),
            routes: [
              GoRoute(
                path: 'checkout',
                name: NamedRouter.checkout.name,
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
            name: NamedRouter.orders.name,
            pageBuilder: (context, state) => MaterialPage(
                child: const OrdersListScreen(),
                fullscreenDialog: true,
                key: state.pageKey),
          ),
          GoRoute(
            path: 'account',
            name: NamedRouter.account.name,
            pageBuilder: (context, state) => const MaterialPage(
                child: AccountScreen(), fullscreenDialog: true),
          ),
          GoRoute(
            path: 'signIn',
            name: NamedRouter.sigIn.name,
            pageBuilder: (context, state) => const MaterialPage(
                child: EmailPasswordSignInScreen(
                    formType: EmailPasswordSignInFormType.signIn),
                fullscreenDialog: true),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
