import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/fake_auth_repository.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  AccountScreenController({required this.authRepository})
      : super(const AsyncData(null));
  final FakeAuthRepository authRepository;

  /// return `true' when no error occurs
  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async => authRepository.signOut(),
    );
  }
}

final accountScreenControllerProvider =
    StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue>(
        (ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository: authRepo);
});
