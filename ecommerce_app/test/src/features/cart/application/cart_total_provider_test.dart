import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartTotalProvider', () {
    ProviderContainer makeProviderContainer(
        {required Stream<Cart> cart, required Stream<List<Product>> products}) {
      final container = ProviderContainer(overrides: [
        cartStreamProvider.overrideWith((ref) => cart),
        productsListStreamProvider.overrideWith((ref) => products)
      ]);
      addTearDown(container.dispose);
      return container;
    }

    test('loading cart', () async {
      final container = makeProviderContainer(
        cart: const Stream.empty(),
        products: Stream.value(kTestProducts),
      );
      final total = container.read(cartTotalProvider);
      expect(total, 0);
    });

    test('one product with quantity = 1', () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'1': 1})),
        products: Stream.value(kTestProducts),
      );
      await container.read(productsListStreamProvider.future);
      await container.read(cartStreamProvider.future);
      final total = container.read(cartTotalProvider);
      expect(total, 15);
    });

    test('one product with quantity = 2', () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'1': 2})),
        products: Stream.value(kTestProducts),
      );
      await container.read(productsListStreamProvider.future);
      await container.read(cartStreamProvider.future);
      final total = container.read(cartTotalProvider);
      expect(total, 30);
    });

    test('two products', () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'1': 2, '2': 2})),
        products: Stream.value(kTestProducts),
      );
      await container.read(productsListStreamProvider.future);
      await container.read(cartStreamProvider.future);
      final total = container.read(cartTotalProvider);
      expect(total, 56); // 2 * 15 + 2 * 13
    });

    test('product not found', () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'100': 2})),
        products: Stream.value(kTestProducts),
      );
      await container.read(productsListStreamProvider.future);
      await container.read(cartStreamProvider.future);
      expect(() => container.read(cartTotalProvider), throwsStateError);
    });

    test('empty cart', () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart()),
        products: Stream.value(kTestProducts),
      );
      await container.read(productsListStreamProvider.future);
      await container.read(cartStreamProvider.future);
      final total = container.read(cartTotalProvider);
      expect(total, 0);
    });
  });
}
