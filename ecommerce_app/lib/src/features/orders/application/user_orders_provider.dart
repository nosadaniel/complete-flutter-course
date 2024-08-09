// Watch the list of user orders

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// NOTE: only watch this provider if the user is signed in.
final userOrdersProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    final ordersRepository = ref.watch(ordersRepostoryProvider);
    return ordersRepository.watchUserOrders(user.uid);
  } else {
    // if user is null, just return an empty screen.
    return const Stream.empty();
  }
});

//check if a product was previously purchased by the user
final matchingUserOrdersProvider =
    StreamProvider.autoDispose.family<List<Order>, ProductID>((ref, productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.watch(ordersRepostoryProvider).watchUserOrders(user.uid,productId: productId);
  } else {
    // if the user is null, return an empty list (no orders)
    return Stream.value([]);
  }
});
final totalOrderCountProvider = Provider.autoDispose<int>((ref) {
  return ref
      .watch(userOrdersProvider)
      .maybeMap(data: (data) => data.value.length, orElse: () => 0);
});
