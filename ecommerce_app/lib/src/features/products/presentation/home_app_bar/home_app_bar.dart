import 'package:ecommerce_app/src/common_widgets/action_text_button.dart';
import 'package:ecommerce_app/src/constants/breakpoints.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/order_text_button.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/shopping_cart_icon.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'more_menu_button.dart';

/// Custom [AppBar] widget that is reused by the [ProductsListScreen] and
/// [ProductScreen].
/// It shows the following actions, depending on the application state:
/// - [ShoppingCartIcon]
/// - Orders button
/// - Account or Sign-in button
class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: get user from auth repository
    final user = ref.watch(authStateChangesProvider).value;
    //const user = AppUser(uid: '123', email: 'test@test.com');
    // * This widget is responsive.
    // * On large screen sizes, it shows all the actions in the app bar.
    // * On small screen sizes, it shows only the shopping cart icon and a
    // * [MoreMenuButton].
    // ! MediaQuery is used on the assumption that the widget takes up the full
    // ! width of the screen. If that's not the case, LayoutBuilder should be
    // ! used instead.
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth < Breakpoint.tablet) {
      return AppBar(
        title: Text('My Shop'.hardcoded),
        actions: [
          const ShoppingCartIcon(),
          MoreMenuButton(user: user),
        ],
      );
    } else {
      return AppBar(
        title: Text('My Shop'.hardcoded),
        actions: [
          const ShoppingCartIcon(),
          if (user != null) ...[
            const OrderTextButton(key: MoreMenuButton.ordersKey),
            ActionTextButton(
              key: MoreMenuButton.accountKey,
              text: 'Account'.hardcoded,
              onPressed: () => context.goNamed(AppRouter.account.name),
            ),
          ] else
            ActionTextButton(
              key: MoreMenuButton.signInKey,
              text: 'Sign In'.hardcoded,
              onPressed: () => context.goNamed(AppRouter.sigIn.name),
            )
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
