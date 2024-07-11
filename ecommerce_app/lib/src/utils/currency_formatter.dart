import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final currencyFormatterProvider = Provider((ref) {
  return

      /// Currency formatter to be used in the app.

      /// * en_US is hardcoded to ensure all prices show with a dollar sign ($)
      /// * This may or may not be what you want in your own apps.
      NumberFormat.simpleCurrency(locale: "en_US");
});
