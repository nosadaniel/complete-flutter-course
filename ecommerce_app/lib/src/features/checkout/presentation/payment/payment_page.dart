import 'package:ecommerce_app/src/constants/async_value_widget.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/payment/payment_button.dart';
import 'package:ecommerce_app/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../cart/domain/item.dart';
import '../../../cart/presentation/shopping_cart/shopping_cart_item.dart';
import '../../../cart/presentation/shopping_cart/shopping_cart_items_builder.dart';

/// Payment screen showing the items in the cart (with read-only quantities) and
/// a button to checkout.
class PaymentPage extends ConsumerWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<double>(cartTotalProvider, (_, cartTotal) {
      //If the cart total becomes 0, it means that the order has
      //been fullfilled because all the items have been removed from the cart.
      // so we should go to the orders page
      if (cartTotal == 0.0) {
        context.goNamed(NamedRouter.orders.name);
      }
    });
    final cart = ref.watch(cartStreamProvider);
    return AsyncValueWidget(
      value: cart,
      data: (cart) => ShoppingCartItemsBuilder(
        items: cart.toItemsList(),
        itemBuilder: (_, item, index) => ShoppingCartItem(
          item: item,
          itemIndex: index,
          isEditable: false,
        ),
        ctaBuilder: (_) => const PaymentButton(),
      ),
    );
  }
}
