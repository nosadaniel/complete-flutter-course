import 'package:ecommerce_app/src/features/cart/data/remote/fake_remote_cart_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/cart.dart';

abstract class RemoteCartRepository {
  Future<Cart> fetchCart(String uid);

  Stream<Cart> watchCart(String uid);

  Future<void> setCart(String uid, Cart cart);
}

final remoteCartRepositoryProvider = Provider((ref) {
  //todo: replace with "real" remote cart repository
  return FakeRemoteCartRepository();
});
