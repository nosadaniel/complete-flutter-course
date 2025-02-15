import 'dart:math';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'cart_service.g.dart';

class CartService {
  CartService(this.ref);
  final Ref ref;

  // fetch the cart from the local or remote repository
  // depending on the user auth store
  Future<Cart> _fetchCart() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteCartRepositoryProvider).fetchCart(user.uid);
    } else {
      return ref.read(localCartRepositoryProvider).fetchCart();
    }
  }

  // save the cart to the local or remote repository
  // depending on the user auth state
  Future<void> _setCart(Cart cart) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref.read(remoteCartRepositoryProvider).setCart(user.uid, cart);
    } else {
      await ref.read(localCartRepositoryProvider).setCart(cart);
    }
  }

  // sets an item in the local or remote cart depending on the user auth state
  Future<void> setItem(Item item) async {
    //throw Exception("Connection issue");
    final cart = await _fetchCart();
    final updated = cart.setItem(item);
    await _setCart(updated);
  }

  /// adds an items in the local or remote cart depending on the user auth state
  Future<void> addItem(Item item) async {
    //throw Exception("connection issue");
    final cart = await _fetchCart();

    final updated = cart.addItem(item);
    await _setCart(updated);
  }

  // removes an item from the local or remote cart depending on the user auth state
  Future<void> removeItemById(ProductID productId) async {
    final cart = await _fetchCart();
    final updated = cart.removeItemById(productId);
    await _setCart(updated);
  }
}

@riverpod
CartService cartService(CartServiceRef ref) {
  return CartService(ref);
}

@Riverpod(keepAlive: true)
Stream<Cart> cartStream(CartStreamRef ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.read(remoteCartRepositoryProvider).watchCart(user.uid);
  } else {
    return ref.read(localCartRepositoryProvider).watchCart();
  }
}

@riverpod
int cartItemsCount(CartItemsCountRef ref) {
  return ref
      .watch(cartStreamProvider)
      .maybeMap(data: (cart) => cart.value.items.length, orElse: () => 0);
}

@riverpod
double cartTotal(CartTotalRef ref) {
  try {
    final itemsCart = ref.watch(cartStreamProvider).value ?? const Cart();
    final products = ref.watch(productsListStreamProvider).value ?? [];
    if (itemsCart.items.isNotEmpty && products.isNotEmpty) {
      return itemsCart.items.entries.map((item) {
        final Product product =
            products.firstWhere((product) => product.id == item.key);
        return product.price * item.value;
      }).reduce((value, itemPrice) => value + itemPrice);
    } else {
      return 0.0;
    }
  } catch (e) {
    rethrow;
  }
}

@riverpod
int itemAvailableQuantity(ItemAvailableQuantityRef ref, Product product) {
  final cart = ref.watch(cartStreamProvider).value;
  if (cart != null) {
    // get the current quantity for the given product in the cart
    final quantity = cart.items[product.id] ?? 0;
    return max(0, product.availableQuantity - quantity);
  } else {
    return product.availableQuantity;
  }
}
