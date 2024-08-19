// ignore_for_file: void_checks

import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_to_cart_controller.g.dart';

@riverpod
class AddToCartController extends _$AddToCartController {
  @override
  FutureOr<void> build() {}

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

@riverpod
class ItemQuantityController extends _$ItemQuantityController {
  @override
  int build() {
    return 1;
  }

  void updateQuantity(int quantity) {
    state = quantity;
  }
}
