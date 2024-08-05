import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentButtonController extends StateNotifier<AsyncValue<void>> {
  PaymentButtonController(this.ref) : super(const AsyncData(null));

  final Ref ref;

  Future<void> pay() async {
    state = const AsyncLoading();
    final newState =
        await AsyncValue.guard(ref.read(checkoutServiceProvider).placeOrder);
    // * Check if the controller is mounted before setting the state to prevent:
    // * Bad State: Tried to use PaymentButtonController
    if (mounted) {
      state = newState;
    }
  }
}

final paymentButtonControllerProvider = StateNotifierProvider.autoDispose<
    PaymentButtonController, AsyncValue<void>>((ref) {
  return PaymentButtonController(ref);
});
