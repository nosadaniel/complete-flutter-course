import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ItemAvailableQuatity', () {
    ProviderContainer makeProviderContainer(
        {required Stream<Cart> cart, required}) {
      final container = ProviderContainer(overrides: [
        cartStreamProvider.overrideWith((ref) => cart),
      ]);
      addTearDown(container.dispose);
      return container;
    }

    test('loading cart', () async {
      final container = makeProviderContainer(
        cart: const Stream.empty(),
      );
      final availableQuantity =
          container.read(itemAvailableQuantityProvider(kTestProducts[1]));
      expect(availableQuantity, 5);
    });

    test('empty cart', () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart()),
      );
      await container.read(cartStreamProvider.future);
      final availableQuantity =
          container.read(itemAvailableQuantityProvider(kTestProducts[1]));
      expect(availableQuantity, 5);
    });

    test('one product with quantity = 4', () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'1': 4})),
      );
      await container.read(cartStreamProvider.future);
      final availableQuantity =
          container.read(itemAvailableQuantityProvider(kTestProducts[0]));
      expect(availableQuantity, 1);
    });
    test('one product with quantity = 5', () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'1': 5})),
      );
      await container.read(cartStreamProvider.future);
      final availableQuantity =
          container.read(itemAvailableQuantityProvider(kTestProducts[0]));
      expect(availableQuantity, 0);
    });
    test('one product with quantity = 10', () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'1': 10})),
      );
      await container.read(cartStreamProvider.future);
      final availableQuantity =
          container.read(itemAvailableQuantityProvider(kTestProducts[0]));
      expect(availableQuantity, 0);
    });
  });
}
