import 'package:ecommerce_app/src/common_widgets/items_count_badge.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shopping cart icon with items count badge
class ShoppingCartIcon extends ConsumerWidget {
  const ShoppingCartIcon({super.key});

  // * Keys for testing using find.byKey()
  static const shoppingCartIconKey = Key('shopping-cart');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemsCount = ref.watch(cartItemsCountProvider);

    return Stack(
      children: [
        Center(
          child: IconButton(
            key: shoppingCartIconKey,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => GoRouter.of(context).goNamed(AppRouter.cart.name),
          ),
        ),
        if (cartItemsCount > 0)
          Positioned(
            top: Sizes.p4,
            right: Sizes.p4,
            child: ItemsCountBadge(itemsCount: cartItemsCount),
          ),
      ],
    );
  }
}
