// ignore_for_file: void_checks

import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToCartController extends StateNotifier<void> {
  AddToCartController(this.ref) : super(const AsyncData(null));

  final Ref ref;

  Future<void> addItem(ProductID productId) async {
    final cartService = ref.read(cartServiceProvider);
    final quantity = ref.read(itemQuantityControllerProvider);
    final item = Item(productId: productId, quantity: quantity.value!);
    state = const AsyncLoading<void>();
    final value = await AsyncValue.guard(() => cartService.addItem(item));
    if (!value.hasError) {
      state = value;
      //reset quantity
      ref.read(itemQuantityControllerProvider.notifier).updateQuantity(1);
    } else {
      state = AsyncError(value.error!, StackTrace.current);
    }
  }
}

final addToCartControllerProvider =
    StateNotifierProvider<AddToCartController, void>((ref) {
  return AddToCartController(ref);
});

class ItemQuantityController extends StateNotifier<AsyncValue<int>> {
  ItemQuantityController() : super(const AsyncData(1));

  void updateQuantity(int quantity) {
    state = AsyncData(quantity);
  }
}

final itemQuantityControllerProvider =
    StateNotifierProvider<ItemQuantityController, AsyncValue<int>>((ref) {
  return ItemQuantityController();
});
