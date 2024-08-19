import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'payment_button_controller.g.dart';

@riverpod
class PaymentButtonController extends _$PaymentButtonController {
  final initial = Object();
  late var current = initial;

  // An [Object] instance is equal to itself only.
  bool get mounted {
    return current == initial;
  }

  @override
  FutureOr<void> build() {
    ref.onDispose(() => current = Object());
    //nothing to do
  }

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
