import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/cart.dart';

abstract class LocalCartRepository {
  Future<Cart> fetchCart();

  Stream<Cart> watchCart();

  Future<void> setCart(Cart cart);
}

final localCartRepositoryProvider = Provider<LocalCartRepository>((ref) {
  // * Override this in the main method
  throw UnimplementedError();
  //return FakeLocalCartRepository(addDelay: false);
});
