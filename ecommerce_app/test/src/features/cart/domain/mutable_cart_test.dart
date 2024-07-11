import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('set item', () {
    test('empty cart - set item with quantity', () {
      final expectedItems = {'1': 2};
      final cart =
          const Cart().setItem(const Item(productId: '1', quantity: 2));
      expect(cart.items, expectedItems);
    });
    test('cart with same item - override quantity', () {
      final expectedItems = {'1': 2};
      final cart = const Cart()
          .addItem(const Item(productId: '1', quantity: 2))
          .setItem(const Item(productId: '1', quantity: 2));
      expect(cart.items, expectedItems);
    });
    test('cart with different item - set item with quantity', () {
      final cart = const Cart()
          .addItem(const Item(productId: '2', quantity: 2))
          .setItem(const Item(productId: '1', quantity: 1));
      expect(cart.items, {'2': 2, '1': 1});
    });
  });
  group('add item', () {
    test('empty cart - add item', () {
      final expectedItems = {'1': 2};
      final cart =
          const Cart().addItem(const Item(productId: '1', quantity: 2));
      expect(cart.items, expectedItems);
    });

    test('empty cart - add two different items', () {
      final cart = const Cart()
          .addItem(const Item(productId: '1', quantity: 2))
          .addItem(const Item(productId: '2', quantity: 2));
      expect(cart.items, {'1': 2, '2': 2});
    });
    test('empty cart - add two same items with different quatity', () {
      final cart = const Cart()
          .addItem(const Item(productId: '1', quantity: 2))
          .addItem(const Item(productId: '1', quantity: 2));
      expect(cart.items, {'1': 4});
    });
  });

  group('add items', () {
    test('empty cart - add items', () {
      final cart = const Cart().addItems([
        const Item(productId: '1', quantity: 2),
        const Item(productId: '2', quantity: 3),
      ]);
      expect(cart.items, {'1': 2, '2': 3});
    });
    test('empty cart - add two same items with different quatity', () {
      final cart = const Cart().addItems([
        const Item(productId: '1', quantity: 2),
        const Item(productId: '2', quantity: 3),
      ]);
      expect(cart.items, {'1': 2, '2': 3});
    });
  });

  group('remove, add, update and clear items', () {
    test('empty cart - remove item by id', () {
      final cart = const Cart().removeItemById('1');
      expect(cart.items, {});
    });
    test('empty - add, then remove item by id', () {
      final cart = const Cart()
          .addItem(const Item(productId: '1', quantity: 2))
          .removeItemById('1');
      expect(cart.items, {});
    });
    test('empty - add, then update item quatity by id if exist', () {
      final cart = const Cart()
          .addItem(const Item(productId: '1', quantity: 2))
          .updateItemIfExists(const Item(productId: '1', quantity: 3));
      expect(cart.items, {'1': 3});
    });

    test(
        'empty - add, then update item quatity by id and if not exist, then return original item',
        () {
      final cart = const Cart()
          .addItem(const Item(productId: '1', quantity: 2))
          .updateItemIfExists(const Item(productId: '2', quantity: 3));
      expect(cart.items, {'1': 2});
    });
    test('empty - add, then clear item', () {
      final cart =
          const Cart().addItem(const Item(productId: '1', quantity: 2)).clear();
      expect(cart.items, {});
    });
  });
}
