import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/payment/payment_button_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  group('Pay', () {
    ProviderContainer makeContainer(FakeCheckoutService checkoutService) {
      final container = ProviderContainer(
        overrides: [checkoutServiceProvider.overrideWithValue(checkoutService)],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('success', () async {
      //setup
      final checkoutService = MockCheckoutService();
      when(() => checkoutService.placeOrder()).thenAnswer(
        (_) => Future.value(null),
      );
      final container = makeContainer(checkoutService);
      final controller =
          container.read(paymentButtonControllerProvider.notifier);
      //run && verify
      expectLater(
        controller.stream,
        emitsInOrder(
          [const AsyncLoading<void>(), const AsyncData<void>(null)],
        ),
      );
      await controller.pay();
    });
    test('failure', () async {
      //setup
      final checkoutService = MockCheckoutService();
      when(() => checkoutService.placeOrder()).thenThrow(
        (_) => Exception('Card declined'),
      );
      final container = makeContainer(checkoutService);
      final controller =
          container.read(paymentButtonControllerProvider.notifier);
      //run && verify
      expectLater(
        controller.stream,
        emitsInOrder(
          [
            const AsyncLoading<void>(),
            predicate<AsyncValue<void>>((value) {
              expect(value.hasError, true);
              return true;
            })
          ],
        ),
      );
      await controller.pay();
    });
  });
}
