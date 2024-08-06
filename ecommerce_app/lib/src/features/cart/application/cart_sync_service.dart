import 'dart:math';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/domain/app_user.dart';

class CartSyncService {
  CartSyncService(this.ref) {
    _init();
  }
  final Ref ref;

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider,
        (prev, nxt) async {
      final prevUser = prev?.value;
      final user = nxt.value;
      if (prevUser == null && user != null) {
        await _moveItemsToRemoteCart(user.uid);
      }
    });
  }

  ///moves all items from the local to the remote cart
  ///taking into account the available quantities
  Future<void> _moveItemsToRemoteCart(String uid) async {
    try {
      //get the local cart data
      final localCartRepository = ref.read(localCartRepositoryProvider);
      final localCart = await localCartRepository.fetchCart();
      if (localCart.items.isNotEmpty) {
        debugPrint("syn local to remote cart");

        //get the remote cart data
        final remoteCartRepository = ref.read(remoteCartRepositoryProvider);
        //fetch
        final remoteCart = await remoteCartRepository.fetchCart(uid);
        final localItemsToAdd = await _getLocalItemsToAdd(
            localCart: localCart, remoteCart: remoteCart);

        // Add all the local items to the remote cart
        final updatedRemoteCart = remoteCart.addItems(localItemsToAdd);
        //write the updated remote cart data to the repository
        await remoteCartRepository.setCart(uid, updatedRemoteCart);
        //remove all items from the local cart
        await localCartRepository.setCart(const Cart());
      }
    } catch (e) {
      //TODO: handle error and/or rethrow
      debugPrint("error while syncing => $e");
    }
  }

// ensure that items added to remote cart
// don't exceed the available quantity
  Future<List<Item>> _getLocalItemsToAdd(
      {required Cart localCart, required Cart remoteCart}) async {
    //Get the list of products (needed to read the available quantities)
    final productsRepository = ref.read(productsRepositoryProvider);
    final products = await productsRepository.fetchProducts();
    //figure out which items need to be added

    final localItemsAdd = <Item>[];
    for (final item in localCart.toItemsList()) {
      final productId = item.productId;
      final localQuantity = item.quantity;
      //get the quantity for the corresponding item in the remote cart
      final remoteQuantity = remoteCart.items[productId] ?? 0;

      final product = products.firstWhere((product) => product.id == productId);
      // Cap the quantity of each item to the available quantity
      final cappedLocalQuantity =
          min(localQuantity, product.availableQuantity - remoteQuantity);
      // if th capped quantity is > 0, add to the
      // list of items to add

      if (cappedLocalQuantity > 0) {
        localItemsAdd
            .add(Item(productId: productId, quantity: cappedLocalQuantity));
      }
    }
    return localItemsAdd;
  }
}

final cartSyncServiceProvider = Provider<CartSyncService>((ref) {
  return CartSyncService(ref);
});
