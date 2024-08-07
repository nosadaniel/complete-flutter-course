import 'package:ecommerce_app/src/exceptions/app_exception.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';

sealed class OrderException extends AppException {
  OrderException(super.code, super.message);
}

class ParseOrderFailureException extends AppException {
  ParseOrderFailureException(this.status)
      : super('parse-order-failure', 'Could not parse order status $status'.hardcoded);
  final String status;
}
