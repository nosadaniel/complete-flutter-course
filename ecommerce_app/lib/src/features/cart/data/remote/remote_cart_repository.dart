import 'package:ecommerce_app/src/features/cart/data/remote/fake_remote_cart_repository.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/cart.dart';
part 'remote_cart_repository.g.dart';

abstract class RemoteCartRepository {
  Future<Cart> fetchCart(String uid);

  Stream<Cart> watchCart(String uid);

  Future<void> setCart(String uid, Cart cart);

  Future<void> clearCart(String uid);
}

@Riverpod(keepAlive: true)
RemoteCartRepository remoteCartRepository(RemoteCartRepositoryRef ref) {
  //todo: replace with "real" remote cart repository
  return FakeRemoteCartRepository(
    addDelay: true,
  );
}
