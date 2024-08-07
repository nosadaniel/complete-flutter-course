import 'package:ecommerce_app/src/exceptions/app_exception.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';

sealed class CheckoutException extends AppException {
  CheckoutException(super.code, super.message);
}

class PaymentFailureEmptyCartException extends CheckoutException {
  PaymentFailureEmptyCartException()
      : super('payment-failure-empty-cart',
            'Can\'t place an order if the cart is empty'.hardcoded);
}
