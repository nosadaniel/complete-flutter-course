import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentDateProvider = Provider<DateTime Function()>((ref) {
  return () => DateTime.now();
});
