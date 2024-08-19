import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/payment/payment_button_controller.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const AsyncLoading<void>());
  });

  group('Pay', () {
    ProviderContainer makeContainer(FakeCheckoutService checkoutService) {
      final container = ProviderContainer(
        overrides: [checkoutServiceProvider.overrideWithValue(checkoutService)],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('make payment, success', () async {
      //setup
      final checkoutService = MockCheckoutService();
      when(() => checkoutService.placeOrder()).thenAnswer(
        (_) => Future.value(null),
      );
      final container = makeContainer(checkoutService);

      final listener = MockListener<AsyncValue<void>>();

      //initial data
      const data = AsyncData<void>(null);
      container.listen(paymentButtonControllerProvider, listener.call,
          fireImmediately: true);
      //verify initial value
      verify(() => listener(null, data));
      final controller =
          container.read(paymentButtonControllerProvider.notifier);
      //run
      await controller.pay();
      //verify in order
      verifyInOrder([
        () => listener(
              data,
              any(that: isA<AsyncLoading<void>>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading<void>>()),
              data,
            )
      ]);
      //verify
      verifyNoMoreInteractions(listener);
    });
    test('failure', () async {
      //setup
      final checkoutService = MockCheckoutService();
      when(() => checkoutService.placeOrder()).thenThrow(
        (_) => Exception('Card declined'),
      );
      final listener = MockListener<AsyncValue<void>>();

      final container = makeContainer(checkoutService);

      const data = AsyncData<void>(null);

      container.listen(paymentButtonControllerProvider, listener.call,
          fireImmediately: true);

//verify initial value in the build method
      verify(() => listener(null, data));
      final controller =
          container.read(paymentButtonControllerProvider.notifier);
      //run
      await controller.pay();

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
      verifyNoMoreInteractions(listener);
    });
  });
}
