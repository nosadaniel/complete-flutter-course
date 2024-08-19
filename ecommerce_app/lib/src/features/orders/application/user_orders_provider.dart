// Watch the list of user orders

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_orders_provider.g.dart';

/// NOTE: only watch this provider if the user is signed in.
///
@riverpod
Stream<List<Order>> userOrders(UserOrdersRef ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    final ordersRepository = ref.watch(ordersRepositoryProvider);
    return ordersRepository.watchUserOrders(user.uid);
  } else {
    // if user is null, just return an empty screen.
    return const Stream.empty();
  }
}

//check if a product was previously purchased by the user
@riverpod
Stream<List<Order>> matchingUserOrders(
    MatchingUserOrdersRef ref, ProductID productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref
        .watch(ordersRepositoryProvider)
        .watchUserOrders(user.uid, productId: productId);
  } else {
    // if the user is null, return an empty list (no orders)
    return Stream.value([]);
  }
}

@riverpod
int totalOrderCount(TotalOrderCountRef ref) {
  return ref
      .watch(userOrdersProvider)
      .maybeMap(data: (data) => data.value.length, orElse: () => 0);
}
