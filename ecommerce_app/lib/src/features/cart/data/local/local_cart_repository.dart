import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/cart.dart';
part 'local_cart_repository.g.dart';

abstract class LocalCartRepository {
  Future<Cart> fetchCart();

  Stream<Cart> watchCart();

  Future<void> setCart(Cart cart);
}

@Riverpod(keepAlive: true)
LocalCartRepository localCartRepository(LocalCartRepositoryRef ref) {
  // * Override this in the main method
  throw UnimplementedError();
}
