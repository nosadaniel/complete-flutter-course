import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/presentation/shopping_cart/shopping_cart_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  setUp(() {
    registerFallbackValue(const AsyncLoading<void>());
  });
  const productId = '1';
  ProviderContainer makeProviderContainer(CartService cartService) {
    final container = ProviderContainer(
      overrides: [
        cartServiceProvider.overrideWithValue(cartService),
      ],
    );
    addTearDown(() => container.dispose());
    return container;
  }

  group('updateItemQuanity', () {
    test('update quantity, success', () async {
      //setup
      const item = Item(productId: productId, quantity: 3);
      final cartService = MockCartService();
      when(() => cartService.setItem(item)).thenAnswer(
        (_) => Future.value(),
      );
      final container = makeProviderContainer(cartService);
      //create a listener
      final listener = MockListener<AsyncValue<void>>();
      //listern to the provider and call [listener] where its value changes
      container.listen(shoppingCartScreenControllerProvider, listener.call,
          fireImmediately: true);

      const data = AsyncData<void>(null);

      //verify initial value from build method
      verify(
        () => listener(null, data),
      );
      //run
      final controller =
          container.read(shoppingCartScreenControllerProvider.notifier);
      //run
      await controller.updateItemQuantity(productId, 3);

      //verify
      verifyInOrder([
        () => listener(
              data,
              any(that: isA<AsyncLoading<void>>()),
            ),
        () => listener(any(that: isA<AsyncLoading<void>>()), data)
      ]);
      // verify that the listener is no longer call
      verifyNoMoreInteractions(listener);
      verify(() => cartService.setItem(item)).called(1);
    });
    test('update quantity, failure', () async {
      //setup
      const item = Item(productId: productId, quantity: 3);
      final cartService = MockCartService();
      when(() => cartService.setItem(item)).thenThrow(
        (_) => Exception('Connection failed'),
      );

      //create a listener
      final listener = MockListener<AsyncValue<void>>();
      const data = AsyncData<void>(null);

      final container = makeProviderContainer(cartService);

      container.listen(shoppingCartScreenControllerProvider, listener.call,
          fireImmediately: true);

      //verify initial value from build method

      verify(() => listener(null, data));

      final controller =
          container.read(shoppingCartScreenControllerProvider.notifier);

      //run & verify
      await controller.updateItemQuantity(productId, 3);

      //verify
      verifyInOrder([
        //set loading state
        // * use a matcher since AsyncLoading !=  AsyncLoading with data
        () => listener(data, any(that: isA<AsyncLoading<void>>())),
        // error when complete
        () => listener(any(that: isA<AsyncLoading<void>>()),
            any(that: isA<AsyncError<void>>())),
      ]);

      //verify
      verify(() => cartService.setItem(item)).called(1);
    });
  });
  group('removItemById', () {
    test('remove item, success', () async {
      //setup
      final cartService = MockCartService();
      when(() => cartService.removeItemById(productId)).thenAnswer(
        (_) => Future.value(null),
      );

      //create a listener
      final listener = MockListener<AsyncValue<void>>();
      const data = AsyncData<void>(null);

      final container = makeProviderContainer(cartService);

      container.listen(shoppingCartScreenControllerProvider, listener.call,
          fireImmediately: true);

      //verify inital state
      verify(() => listener(null, data));

      final controller =
          container.read(shoppingCartScreenControllerProvider.notifier);
      //run
      await controller.removeItemById(productId);
      //verify by order
      verifyInOrder([
        () => listener(
              data,
              any(that: isA<AsyncLoading<void>>()),
            ),
        () => listener(any(that: isA<AsyncLoading>()), data),
      ]);
      //verify that the listener is no longer call
      verifyNoMoreInteractions(listener);
      verify(() => cartService.removeItemById(productId)).called(1);
    });
    test('remove item, failure', () async {
      //setup
      final cartService = MockCartService();
      when(() => cartService.removeItemById(productId)).thenThrow(
        (_) => Exception('Connection error'),
      );
      const data = AsyncData<void>(null);
      final container = makeProviderContainer(cartService);

      final listener = MockListener<AsyncValue<void>>();

      container.listen(shoppingCartScreenControllerProvider, listener.call,
          fireImmediately: true);

      //verify inital value from build method
      verify(() => listener(null, data));
      final controller =
          container.read(shoppingCartScreenControllerProvider.notifier);

      await controller.removeItemById(productId);

      //verify in order
      verifyInOrder([
        () => listener(
              data,
              any(that: isA<AsyncLoading<void>>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading<void>>()),
              any(that: isA<AsyncError<void>>()),
            )
      ]);
      //verify
      verifyNoMoreInteractions(listener);
      verify(() => cartService.removeItemById(productId)).called(1);
    });
  });
}
