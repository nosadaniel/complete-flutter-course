import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A fake checkout service that doesn't process real payments
class FakeCheckoutService {
  FakeCheckoutService(this.ref, this.orderDate);
  final Ref ref;
  final DateTime orderDate;

  ///Temporary client-side logic for placing an order.
  ///part of this logic should run on the server so that we can:
  /// - setup a payment intent
  /// - show the payment UI
  /// - process the payment and fullfill the order
  Future<void> placeOrder() async {
    final authRepository = ref.read(authRepositoryProvider);
    final remoteCartRepository = ref.read(remoteCartRepositoryProvider);
    final ordersRepository = ref.read(ordersRepostoryProvider);
    // * Assertion operator is ok here since this method
    // is ok here since this method is only called from
    // a place where the user is signed in
    final uid = authRepository.currentUser!.uid;
    //1. Get the cart object
    final cart = await remoteCartRepository.fetchCart(uid);
    final total = _totalPrice(cart);
    //order should be generated with UUID package
    // Since this is a fake service, we just derive it
    //from the date.
    final orderId = orderDate.toIso8601String();
    // 2. create an order
    final order = Order(
        id: orderId,
        userId: uid,
        items: cart.items,
        orderStatus: OrderStatus.confirmed,
        orderDate: orderDate,
        total: total);
    // 3. save it using the repository
    await ordersRepository.addOrder(uid, order);
    //4. Empty the cart
    remoteCartRepository.clearCart(uid);
  }

//helper method to calucate the total price
  double _totalPrice(Cart cart) {
    if (cart.items.isEmpty) {
      return 0.0;
    }
    final productsRepository = ref.read(productsRepositoryProvider);

    return cart.items.entries.map((entry) {
      final Product? product =
          productsRepository.getProduct(productId: entry.key);
      return entry.value * product!.price;
    }).reduce((value, element) => value + element);
  }
}

final checkoutServiceProvider = Provider<FakeCheckoutService>((ref) {
  return FakeCheckoutService(ref, DateTime.now());
});
