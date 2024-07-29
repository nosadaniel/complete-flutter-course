// ignore_for_file: void_checks

import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToCartController extends StateNotifier<AsyncValue<void>> {
  AddToCartController(this.ref) : super(const AsyncData(null));

  final Ref ref;

  Future<void> addItem(ProductID productId) async {
    state = const AsyncLoading();
    final cartService = ref.read(cartServiceProvider);
    final quantity = ref.read(itemQuantityControllerProvider);
    final item = Item(productId: productId, quantity: quantity);

    state = await AsyncValue.guard(() async => await cartService.addItem(item));

    if (!state.hasError) {
      //reset quantity
      ref.read(itemQuantityControllerProvider.notifier).updateQuantity(1);
    } else {
      state = AsyncError(state.error!, StackTrace.current);
    }
  }
}

final addToCartControllerProvider =
    StateNotifierProvider.autoDispose<AddToCartController, AsyncValue<void>>(
        (ref) {
  return AddToCartController(ref);
});

class ItemQuantityController extends StateNotifier<int> {
  ItemQuantityController() : super(1);

  void updateQuantity(int quantity) {
    state = quantity;
  }
}

final itemQuantityControllerProvider =
    StateNotifierProvider.autoDispose<ItemQuantityController, int>((ref) {
  return ItemQuantityController();
});
