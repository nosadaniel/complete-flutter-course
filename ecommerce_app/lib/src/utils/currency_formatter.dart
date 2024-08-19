import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'currency_formatter.g.dart';

@riverpod
NumberFormat currencyFormatter(CurrencyFormatterRef ref) {
  return

      /// Currency formatter to be used in the app.

      /// * en_US is hardcoded to ensure all prices show with a dollar sign ($)
      /// * This may or may not be what you want in your own apps.
      NumberFormat.simpleCurrency(locale: "en_US");
}
