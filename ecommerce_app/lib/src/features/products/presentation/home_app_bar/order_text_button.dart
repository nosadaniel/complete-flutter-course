import 'package:ecommerce_app/src/common_widgets/items_count_badge.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/orders/application/user_orders_provider.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Order text button with orders count badge
class OrderTextButton extends ConsumerWidget {
  const OrderTextButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderItemsCount = ref.watch(totalOrderCountProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
      child: Stack(
        children: [
          TextButton(
            onPressed: () => context.goNamed(AppRouter.orders.name),
            child: Text('Orders'.hardcoded,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white)),
          ),
          if (orderItemsCount > 0)
            Positioned(
                top: Sizes.p4,
                right: Sizes.p4,
                child: ItemsCountBadge(
                  itemsCount: orderItemsCount,
                )),
        ],
      ),
    );
  }
}
