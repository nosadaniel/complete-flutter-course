// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';

import 'package:ecommerce_app/src/utils/delay_call.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

class FakeRemoteCartRepository implements RemoteCartRepository {
  final bool addDelay;

  FakeRemoteCartRepository({
    this.addDelay = true,
  });

  final _carts = InMemoryStore<Map<String, Cart>>({});

  /// An [InMemoryStore] containing the shopping cart data for all users, where:
  /// Key: uid of the user
  /// value: Cart of that user

  @override
  Future<Cart> fetchCart(String uid) {
    return Future.value(_carts.value[uid] ?? const Cart());
  }

  @override
  Future<void> setCart(String uid, Cart cart) async {
    await delay(addDelay);
    //first, get the current carts data for all users
    final carts = _carts.value;
    //then, set the cart for the given uid

    carts[uid] = cart;
    //finally, update the carts data (will emit a new value)
    _carts.value = carts;
  }

  @override
  Stream<Cart> watchCart(String uid) {
   // debugPrint("remote watch called");
    return _carts.stream.map((data) => data[uid] ?? const Cart());
  }

  @override
  Future<void> clearCart(String uid) async {
    await setCart(uid, const Cart());
  }
}
