import 'package:ecommerce_app/src/exceptions/app_exception.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';

sealed class CartException extends AppException {
  CartException(super.code, super.message);
}

class CartSyncFailedException extends CartException {
  CartSyncFailedException()
      : super('payment-failure-empty-cart',
            'Can\'t place an order if the cart is empty'.hardcoded);
}


