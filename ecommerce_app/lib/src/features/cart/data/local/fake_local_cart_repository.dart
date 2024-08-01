// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/utils/delay_call.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

class FakeLocalCartRepository implements LocalCartRepository {
  final bool addDelay;
  FakeLocalCartRepository({
    this.addDelay = true,
  });

  final _cart = InMemoryStore<Cart>(const Cart());

  @override
  Future<Cart> fetchCart() {
    return Future.value(_cart.value);
  }

  @override
  Future<void> setCart(Cart cart) async {
    await delay(addDelay);
    _cart.value = cart;
  }

  @override
  Stream<Cart> watchCart() {
    return _cart.stream;
  }
}
