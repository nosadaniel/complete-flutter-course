import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_date_provider.g.dart';

@riverpod
DateTime Function() currentDate(Ref ref) {
  return () => DateTime.now();
}
